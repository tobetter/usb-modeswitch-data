#!/bin/bash

set -e

# Commit identifiant
cid=$1

function get_desc
{
id=$1

fn=usb_modeswitch.d/$id

if test -e $fn; then
	echo -n "[$id] "
	head -n 2 $fn | tail -n 1 | sed -e 's/^# //g'
else
	echo "[$id] (Removed or renamed)"
fi
}

git show --stat $cid | while read line
do
	echo $line | grep 'usb_modeswitch.d/' >/dev/null && true
	# Are we handling a configuration file
	if [ $? -eq 0 ] 
	then
		# Pure additions
		echo $line | grep '+' | grep -v '-'  >/dev/null && true
		if [ $? -eq 0 ]
		then
			tag="+";
		else
			tag="×";
		fi
		id=`echo $line | sed -e 's,^usb_modeswitch.d/\(.*\) | .*$,\1,'`
		echo -n "   $tag "
		get_desc $id;
	fi
done

