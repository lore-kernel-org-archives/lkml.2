Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1FJSRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:17:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34236 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FJSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:17:42 -0400
Date: Fri, 10 Jun 2011 23:47:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinned
Message-ID: <20110610181719.GA30330@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
 <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
 <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-06-08 20:25:00]:

> Hi Kamalesh,
> 
> I'm unable to reproduce the results you describe.  One possibility is
> load-balancer interaction -- can you describe the topology of the
> platform you are running this on?
> 
> On both a straight NUMA topology and a hyper-threaded platform I
> observe a ~4% delta between the pinned and un-pinned cases.
> 
> Thanks -- results below,
> 
> - Paul
> 
> 
(snip)

Hi Paul,

That box is down. I tried running the test on the 2-socket quad-core with 
HT and I was not able to reproduce the issue. CPU idle time reported with 
both pinned and un-pinned case was ~0. But if we create a cgroup hirerachy 
of 3 levels above the 5 cgroups, instead of the current hirerachy where all
the 5 cgroups created under /cgroup. The Idle time is seen on 2-socket 
quad-core (HT) box.

				-----------
				| cgroups |
				-----------
				     |
				-----------
				| level 1 |
				-----------
				     |
				-----------
				| level 2 |
				-----------
				     |
				-----------
				| level 3 |
				-----------
			      /   /   |   \     \
			     /	 /    |    \     \
			cgrp1  cgrp2 cgrp3 cgrp4 cgrp5


Un-pinned run
--------------

Average CPU Idle percentage 24.8333%
Bandwidth shared with remaining non-Idle 75.1667%
Bandwidth of Group 1 = 8.3700 i.e = 6.2900% of non-Idle CPU time 75.1667%
|...... subgroup 1/1	= 49.9900	i.e = 3.1400% of 6.2900% Groups non-Idle CPU time
|...... subgroup 1/2	= 50.0000	i.e = 3.1400% of 6.2900% Groups non-Idle CPU time
 
 
Bandwidth of Group 2 = 8.3700 i.e = 6.2900% of non-Idle CPU time 75.1667%
|...... subgroup 2/1	= 49.9900	i.e = 3.1400% of 6.2900% Groups non-Idle CPU time
|...... subgroup 2/2	= 50.0000	i.e = 3.1400% of 6.2900% Groups non-Idle CPU time
 
 
Bandwidth of Group 3 = 16.6500 i.e = 12.5100% of non-Idle CPU time 75.1667%
|...... subgroup 3/1	= 25.0000	i.e = 3.1200% of 12.5100% Groups non-Idle CPU time
|...... subgroup 3/2	= 24.9100	i.e = 3.1100% of 12.5100% Groups non-Idle CPU time
|...... subgroup 3/3	= 25.0800	i.e = 3.1300% of 12.5100% Groups non-Idle CPU time
|...... subgroup 3/4	= 24.9900	i.e = 3.1200% of 12.5100% Groups non-Idle CPU time
 
 
Bandwidth of Group 4 = 29.3600 i.e = 22.0600% of non-Idle CPU time 75.1667%
|...... subgroup 4/1	= 12.0200	i.e = 2.6500% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/2	= 12.3800	i.e = 2.7300% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/3	= 13.6300	i.e = 3.0000% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/4	= 12.7000	i.e = 2.8000% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/5	= 12.8000	i.e = 2.8200% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/6	= 11.9600	i.e = 2.6300% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/7	= 12.7400	i.e = 2.8100% of 22.0600% Groups non-Idle CPU time
|...... subgroup 4/8	= 11.7300	i.e = 2.5800% of 22.0600% Groupsnon-Idle CPU time
 
 
Bandwidth of Group 5 = 37.2300 i.e = 27.9800% of non-Idle CPU time 75.1667%
|...... subgroup 5/1	= 47.7200	i.e = 13.3500%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/2	= 5.2000	i.e = 1.4500% 	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/3	= 6.3600	i.e = 1.7700% 	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/4	= 6.3600	i.e = 1.7700%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/5	= 7.9800	i.e = 2.2300%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/6	= 5.1800	i.e = 1.4400%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/7	= 7.4900	i.e = 2.0900%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/8	= 5.9200	i.e = 1.6500%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/9	= 7.7500	i.e = 2.1600%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/10	= 4.8100	i.e = 1.3400%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/11	= 4.9300	i.e = 1.3700%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/12	= 6.8900	i.e = 1.9200%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/13	= 6.0700	i.e = 1.6900%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/14	= 6.5200	i.e = 1.8200%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/15	= 5.9200	i.e = 1.6500%	of 27.9800% Groups non-Idle CPU time
|...... subgroup 5/16	= 6.6400	i.e = 1.8500% 	of 27.9800% Groups non-Idle CPU time

Pinned Run
----------

Average CPU Idle percentage 0%
Bandwidth shared with remaining non-Idle 100%
Bandwidth of Group 1 = 6.2700 i.e = 6.2700% of non-Idle CPU time 100%
|...... subgroup 1/1	= 50.0100	i.e = 3.1300% of 6.2700% Groups non-Idle CPU time
|...... subgroup 1/2	= 49.9800	i.e = 3.1300% of 6.2700% Groups non-Idle CPU time
 
 
Bandwidth of Group 2 = 6.2700 i.e = 6.2700% of non-Idle CPU time 100%
|...... subgroup 2/1	= 50.0000	i.e = 3.1300% of 6.2700% Groups non-Idle CPU time
|...... subgroup 2/2	= 49.9900	i.e = 3.1300% of 6.2700% Groups non-Idle CPU time
 
 
Bandwidth of Group 3 = 12.5300 i.e = 12.5300% of non-Idle CPU time 100%
|...... subgroup 3/1	= 25.0100	i.e = 3.1300% of 12.5300% Groups non-Idle CPU time
|...... subgroup 3/2	= 25.0000	i.e = 3.1300% of 12.5300% Groups non-Idle CPU time
|...... subgroup 3/3	= 24.9900	i.e = 3.1300% of 12.5300% Groups non-Idle CPU time
|...... subgroup 3/4	= 24.9900	i.e = 3.1300% of 12.5300% Groups non-Idle CPU time
 
 
Bandwidth of Group 4 = 25.0200 i.e = 25.0200% of non-Idle CPU time 100%
|...... subgroup 4/1	= 12.5100	i.e = 3.1300% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/2	= 12.5000	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/3	= 12.5000	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/4	= 12.5000	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/5	= 12.4900	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/6	= 12.4900	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/7	= 12.4900	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
|...... subgroup 4/8	= 12.4800	i.e = 3.1200% of 25.0200% Groups non-Idle CPU time
 
 
Bandwidth of Group 5 = 49.8800 i.e = 49.8800% of non-Idle CPU time 100%
|...... subgroup 5/1	= 49.9600	i.e = 24.9200% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/2	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/3	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/4	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/5	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/6	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/7	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/8	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/9	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/10	= 6.2500	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/11	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/12	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/13	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/14	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/15	= 6.2300	i.e = 3.1000% of 49.8800% Groups non-Idle CPU time
|...... subgroup 5/16	= 6.2400	i.e = 3.1100% of 49.8800% Groups non-Idle CPU time

Modified script
---------------

#!/bin/bash

NR_TASKS1=2
NR_TASKS2=2
NR_TASKS3=4
NR_TASKS4=8
NR_TASKS5=16

BANDWIDTH=1
SUBGROUP=1
PRO_SHARES=0
MOUNT_POINT=/cgroups/
MOUNT=/cgroups/
LOAD=./while1
LEVELS=3

usage()
{
	echo "Usage $0: [-b 0|1] [-s 0|1] [-p 0|1]"
	echo "-b 1|0 set/unset  Cgroups bandwidth control (default set)"
	echo "-s Create sub-groups for every task (default creates sub-group)"
	echo "-p create propotional shares based on cpus"
	exit
}
while getopts ":b:s:p:" arg
do
	case $arg in
	b)
		BANDWIDTH=$OPTARG
		shift
		if [ $BANDWIDTH -gt 1 ] && [ $BANDWIDTH -lt  0 ]
		then
			usage
		fi
		;;
	s)
		SUBGROUP=$OPTARG
		shift
		if [ $SUBGROUP -gt 1 ] && [ $SUBGROUP -lt 0 ]
		then
			usage
		fi
		;;
	p)
		PRO_SHARES=$OPTARG
		shift
		if [ $PRO_SHARES -gt 1 ] && [ $PRO_SHARES -lt 0 ]
		then
			usage
		fi
		;;

	*)

	esac
done
if [ ! -d $MOUNT ]
then
	mkdir -p $MOUNT
fi
test()
{
	echo -n "[ "
	if [ $1 -eq 0 ]
	then
		echo -ne '\E[42;40mOk'
	else
		echo -ne '\E[31;40mFailed'
		tput sgr0
		echo " ]"
		exit
	fi
	tput sgr0
	echo " ]"
}
mount_cgrp()
{
	echo -n "Mounting root cgroup "
	mount -t cgroup -ocpu,cpuset,cpuacct none $MOUNT_POINT &> /dev/null
	test $?
}

umount_cgrp()
{
	echo -n "Unmounting root cgroup "
	cd /root/
	umount $MOUNT_POINT
	test $?
}

create_hierarchy()
{
	mount_cgrp
	cpuset_mem=`cat $MOUNT/cpuset.mems`
	cpuset_cpu=`cat $MOUNT/cpuset.cpus`
	echo -n "creating hierarchy of levels $LEVELS "
	for (( i=1; i<=$LEVELS; i++ ))
	do
		MOUNT="${MOUNT}/level${i}"
		mkdir $MOUNT
		echo $cpuset_mem > $MOUNT/cpuset.mems
		echo $cpuset_cpu > $MOUNT/cpuset.cpus
		echo "-1" > $MOUNT/cpu.cfs_quota_us
		echo "500000" > $MOUNT/cpu.cfs_period_us
		echo -n " .."
	done
	echo " "
	echo $MOUNT
	echo -n "creating groups/sub-groups ..."
	for (( i=1; i<=5; i++ ))
	do
		mkdir $MOUNT/$i
		echo $cpuset_mem > $MOUNT/$i/cpuset.mems
		echo $cpuset_cpu > $MOUNT/$i/cpuset.cpus
		echo -n ".."
		if [ $SUBGROUP -eq 1 ]
		then
			jj=$(eval echo "\$NR_TASKS$i")
			for (( j=1; j<=$jj; j++ ))
			do
				mkdir -p $MOUNT/$i/$j
				echo $cpuset_mem > $MOUNT/$i/$j/cpuset.mems
				echo $cpuset_cpu > $MOUNT/$i/$j/cpuset.cpus
				echo -n ".."
			done
		fi
	done
	echo "."
}

cleanup()
{
	pkill -9 while1 &> /dev/null
	sleep 10
	echo -n "Umount groups/sub-groups .."
	for (( i=1; i<=5; i++ ))
	do
		if [ $SUBGROUP -eq 1 ]
		then
			jj=$(eval echo "\$NR_TASKS$i")
			for (( j=1; j<=$jj; j++ ))
			do
				rmdir $MOUNT/$i/$j
				echo -n ".."
			done
		fi
		rmdir $MOUNT/$i
		echo -n ".."
	done
	cd $MOUNT
	cd ../
	for (( i=$LEVELS; i>=1; i-- ))
	do
		rmdir level$i
		cd ../	
	done
	echo " "
	umount_cgrp
}

load_tasks()
{
	for (( i=1; i<=5; i++ ))
	do
		jj=$(eval echo "\$NR_TASKS$i")
		shares="1024"
		if [ $PRO_SHARES -eq 1 ]
		then
			eval shares=$(echo "$jj * 1024" | bc)
		fi
		echo $shares > $MOUNT/$i/cpu.shares
		for (( j=1; j<=$jj; j++ ))
		do
			echo "-1" > $MOUNT/$i/cpu.cfs_quota_us
			echo "500000" > $MOUNT/$i/cpu.cfs_period_us
			if [ $SUBGROUP -eq 1 ]
			then

				$LOAD &
				echo $! > $MOUNT/$i/$j/tasks
				echo "1024" > $MOUNT/$i/$j/cpu.shares

				if [ $BANDWIDTH -eq 1 ]
				then
					echo "500000" > $MOUNT/$i/$j/cpu.cfs_period_us
					echo "250000" > $MOUNT/$i/$j/cpu.cfs_quota_us
				fi
			else
				$LOAD & 
				echo $! > $MOUNT/$i/tasks
				echo $shares > $MOUNT/$i/cpu.shares

				if [ $BANDWIDTH -eq 1 ]
				then
					echo "500000" > $MOUNT/$i/cpu.cfs_period_us
					echo "250000" > $MOUNT/$i/cpu.cfs_quota_us
				fi
			fi
		done
	done
	echo "Capturing idle cpu time with vmstat...."
	vmstat 2 100 &> vmstat_log &
}

pin_tasks()
{
	cpu=0
	count=1
	for (( i=1; i<=5; i++ ))
	do
		if [ $SUBGROUP -eq 1 ]
		then
			jj=$(eval echo "\$NR_TASKS$i")
			for (( j=1; j<=$jj; j++ ))
			do
				if [ $count -gt 2 ]
				then
					cpu=$((cpu+1))
					count=1
				fi
				echo $cpu > $MOUNT/$i/$j/cpuset.cpus
				count=$((count+1))
			done
		else
			case $i in
			1)
				echo 0 > $MOUNT/$i/cpuset.cpus;;
			2)
				echo 1 > $MOUNT/$i/cpuset.cpus;;
			3)
				echo "2-3" > $MOUNT/$i/cpuset.cpus;;
			4)
				echo "4-6" > $MOUNT/$i/cpuset.cpus;;
			5)
				echo "7-15" > $MOUNT/$i/cpuset.cpus;;
			esac
		fi
	done
	
}

print_results()
{
	eval gtot=$(cat sched_log|grep -i while|sed 's/R//g'|awk '{gtot+=$7};END{printf "%f", gtot}')
	for (( i=1; i<=5; i++ ))	
	do
		eval temp=$(cat sched_log_$i|sed 's/R//g'| awk '{gtot+=$7};END{printf "%f",gtot}')
		eval tavg=$(echo "scale=4;(($temp / $gtot) * $1)/100 " | bc)
		eval avg=$(echo  "scale=4;($temp / $gtot) * 100" | bc)
		eval pretty_tavg=$( echo "scale=4; $tavg * 100"| bc) # F0r pretty format
		echo "Bandwidth of Group $i = $avg i.e = $pretty_tavg% of non-Idle CPU time $1%"
		if [ $SUBGROUP -eq 1 ]
		then
			jj=$(eval echo "\$NR_TASKS$i")
			for (( j=1; j<=$jj; j++ ))
			do
				eval tmp=$(cat sched_log_$i-$j|sed 's/R//g'| awk '{gtot+=$7};END{printf "%f",gtot}')
				eval stavg=$(echo "scale=4;($tmp / $temp) * 100" | bc)
				eval pretty_stavg=$(echo "scale=4;(($tmp / $temp) * $tavg) * 100" | bc)
				echo -n "|"
				echo -e "...... subgroup $i/$j\t= $stavg\ti.e = $pretty_stavg% of $pretty_tavg% Groups non-Idle CPU time"
			done
		fi
		echo " "
		echo " "
	done
}

capture_results()
{
	cat /proc/sched_debug > sched_log
	lev=""
	for (( i=1; i<=$LEVELS; i++ ))
	do
		lev="$lev\/level${i}"	
	done
	pkill -9 vmstat 
	avg=$(cat vmstat_log |grep -iv "system"|grep -iv "swpd"|awk ' { if ( NR != 1) {id+=$15 }}END{print (id/(NR-1))}')

	rem=$(echo "scale=2; 100 - $avg" |bc)
	echo "Average CPU Idle percentage $avg%"	
	echo "Bandwidth shared with remaining non-Idle $rem%" 
	for (( i=1; i<=5; i++ ))
	do
		cat sched_log |grep -i while1|grep -i "$lev\/$i" > sched_log_$i
		if [ $SUBGROUP -eq 1 ]
		then
			jj=$(eval echo "\$NR_TASKS$i")
			for (( j=1; j<=$jj; j++ ))
			do
				cat sched_log |grep -i while1|grep -i "$lev\/$i\/$j" > sched_log_$i-$j
			done
		fi
	done
	print_results $rem
}

create_hierarchy
pin_tasks

load_tasks
sleep 60
capture_results
cleanup
exit

