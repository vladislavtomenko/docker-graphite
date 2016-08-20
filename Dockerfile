from	centos
run	yum clean all

## Install required packages
run	yum -y update
run	yum install -y net-snmp perl pycairo python-devel git gcc-c++
run	yum install -y epel-release
run	yum install -y python-pip node npm
run	pip install 'django<1.6'
run	pip install 'Twisted<12'
run	pip install 'django-tagging<0.4'
run	pip install whisper
run	pip install carbon
run	pip install graphite-web
run	pip install gunicorn
run	pip install pytz
run	yum install -y supervisor

#
## Add system service config
run	mkdir /var/log/supervisord/
run	cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
run	cp /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf

#
## Add graphite config
add	./storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
run	cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
run	cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
add	./local_settings.py /opt/graphite/webapp/graphite/local_settings.py
run	cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput

#
## Carbon line receiver port
expose	2003
## Carbon UDP receiver port
expose	2003/udp
## Carbon pickle receiver port
expose	2004
## Carbon cache query port
expose	7002
## Graphite web port
expose	8000
#
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
cmd	/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
