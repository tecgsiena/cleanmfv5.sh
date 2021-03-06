#!/bin/sh
# Alexandre Jeronimo Correa - ajcorrea@gmail.com
# Script para AirOS Ubiquiti
# Remove o worm MF e atualiza para a ultima versao do AirOS disponivel oficial
#
##### NAO ALTERAR ####

#Verifica se o equipamento eh UBNT por algumas caracteristicas
if [ ! -e "/bin/ubntbox" ] ; then
        echo "Nao Ubiquiti"
	exit
fi

#Mostra info do radio
mca-status | grep deviceName
echo "#################################################"

/bin/sed -ir '/mcad/ c ' /etc/inittab
/bin/sed -ir '/mcuser/ c ' /etc/passwd
/bin/rm -rf /etc/persistent/https
/bin/rm -rf /etc/persistent/mcuser
/bin/rm -rf /etc/persistent/mf.tar
/bin/rm -rf /etc/persistent/.mf
/bin/rm -rf /etc/persistent/rc.poststart
/bin/rm -rf /etc/persistent/rc.prestart
#remove v2
/bin/rm -rf /etc/persistent/mf.tgz
/bin/kill -HUP `/bin/pidof init`
/bin/kill -9 `/bin/pidof mcad`
/bin/kill -9 `/bin/pidof init`
/bin/kill -9 `/bin/pidof search`
/bin/kill -9 `/bin/pidof mother`
/bin/kill -9 `/bin/pidof sleep`
#Para processos v2
/bin/kill -9 `/bin/pidof sprd`
/bin/kill -9 `/bin/pidof infect`
/bin/kill -9 `/bin/pidof scan`

# Verificar o uso do Compliance Test
# Compliance Teste Country Code = 511
# Brazil Country code = 76
CCATUAL=$(iwpriv wifi0 getCountryID |  sed 's/wifi0     getCountryID://')
if [ $CCATUAL -eq '511' ]; then
        touch /etc/persistent/ct
        /bin/sed -ir '/radio.1.countrycode/ c radio.1.countrycode=511' /tmp/system.cfg
        /bin/sed -ir '/radio.countrycode/ c radio.countrycode=511' /tmp/system.cfg
fi

#Salva modificacoes...
/bin/cfgmtd -w -p /etc/

fullver=`cat /etc/version | sed 's/XW.v//' | sed 's/XM.v//' | sed 's/TI.v//'`

##if [ "$fullver" == "5.6.6" ]; then
if [ "$fullver" == "6.0.7" ]; then
        echo "Atualizado... Done"
        exit
fi

versao=`cat /etc/version | cut -d'.' -f1`
cd /tmp
rm -rf /tmp/firmware.bin
rm -rf /tmp/X*.bin
rm -rf /tmp/T*.bin

if [ "$versao" == "XM" ]; then
        #URL='http://dl.ubnt.com/firmwares/XN-fw/v5.6.6/XM.v5.6.6.29183.160526.1225.bin'
	URL='http://177.87.36.2/ubnt/firmwares/XM.v6.1.4.bin'
fi
if [ "$versao" == "XW" ]; then
        #URL='http://dl.ubnt.com/firmwares/XW-fw/v5.6.6/XW.v5.6.6.29183.160526.1205.bin'
	URL='http://177.87.36.2/ubnt/firmwares/XW.v6.1.4.bin'
fi
if [ "$versao" == "TI" ]; then
        #URL='http://dl.ubnt.com/firmwares/XN-fw/v5.6.6/TI.v5.6.6.29183.160526.1144.bin'
	URL='http://177.87.36.2/ubnt/firmwares/TI.v6.1.4.bin'
fi

wget -c $URL -O /tmp/firmware.bin

if [ -e "/tmp/firmware.bin" ] ; then
        ubntbox fwupdate.real -m /tmp/firmware.bin
fi

## URLS 5.6.6
## http://dl.ubnt.com/firmwares/XN-fw/v5.6.6/XM.v5.6.6.29183.160526.1225.bin
## http://dl.ubnt.com/firmwares/XW-fw/v5.6.6/XW.v5.6.6.29183.160526.1205.bin
## http://dl.ubnt.com/firmwares/XN-fw/v5.6.6/TI.v5.6.6.29183.160526.1144.bin
## URLS 5.6.9
## http://dl.ubnt.com/firmwares/XN-fw/v5.6.9/XM.v5.6.9.29546.160819.1157.bin
## http://dl.ubnt.com/firmwares/XW-fw/v5.6.9/XW.v5.6.9.29546.160819.1146.bin
## http://dl.ubnt.com/firmwares/XN-fw/v5.6.9/TI.v5.6.9.29546.160819.1135.bin
## URLS 6.0.4
## https://dl.ubnt.com/firmwares/XN-fw/v6.0.4/XM.v6.0.4.30805.170505.1525.bin
## https://dl.ubnt.com/firmwares/XW-fw/v6.0.4/XW.v6.0.4.30805.170505.1510.bin
## https://dl.ubnt.com/firmwares/XN-fw/v6.0.4/TI.v6.0.4.30805.170505.1456.bin
## URLS 6.0.7
## https://dl.ubnt.com/firmwares/XN-fw/v6.0.7/XM.v6.0.7.31601.170908.1247.bin
## https://dl.ubnt.com/firmwares/XW-fw/v6.0.7/XW.v6.0.7.31601.170908.1232.bin
## https://dl.ubnt.com/firmwares/XN-fw/v6.0.7/TI.v6.0.7.31601.170908.1216.bin
