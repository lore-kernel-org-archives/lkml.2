Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0LCCqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:46:11 -0500
Received: from mailman.will.to ([68.164.136.125]:59856 "EHLO will.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0LCCqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:46:09 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 21:46:08 EST
Message-ID: <4CF858A3.2050202@will.to>
Date: Thu, 02 Dec 2010 21:40:35 -0500
From: Doug Hughes <doug@will.to>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: strange linux kernel NFS problem(s)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (will.to [68.164.136.125]); Thu, 02 Dec 2010 21:40:35 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, this is my first post, but not my first problem of this nature. It 
just so happens that this is the first one with a recent kernel to give 
useful data, useful enough to post it and seek some advice on the subject:

symptoms: machine gets high load, nfs mount processes hang, and things 
(particularly NFS) stop working. ssh and ip connectivity still works, as 
does ps.

*general protection fault: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 1
Modules linked in: nfs auth_rpcgss autofs4 i2c_dev i2c_core lockd sunrpc 
cachefiles fscache ipmi_si ipmi_devintf ipmi_msghandler ip6t_REJECT 
xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 video output battery 
ac parport_pc lp parport joydev button sr_mod pcspkr iTCO_wdt shpchp 
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod usb_storage 
pata_acpi ata_piix ata_generic libata uhci_hcd ohci_hcd ehci_hcd [last 
unloaded: microcode]

Pid: 28573, comm: python2.5 Not tainted 2.6.34 #3 X7DWT/X7DWT
RIP: 0010:[<ffffffffa0292cdb>]  [<ffffffffa0292cdb>] 
nfs_release+0x64/0x94 [nfs]
RSP: 0018:ffff88041ccb9d58  EFLAGS: 00010246
RAX: ffff88041c47d160 RBX: ffff88041c47d1e8 RCX: ff88041c47d16088
RDX: ffff88042c593288 RSI: ffff88042c504e40 RDI: ffff88041c47d294
RBP: ffff88041ccb9d78 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000300000000 R11: 0000000000000000 R12: ffff88042c593240
R13: ffff88042c504e40 R14: ffff88041ea59ec0 R15: ffff8804273f55c0
FS:  0000000000000000(0000) GS:ffff880001840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003fd5c03350 CR3: 0000000001613000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python2.5 (pid: 28573, threadinfo ffff88041ccb8000, task 
ffff8803e246adf0)
Stack:
  0000000300000000 ffff88042c504e40 ffff88041c47d1e8 ffff88041c47d1e8
<0> ffff88041ccb9d98 ffffffffa0290fc5 0000000000000010 ffff88042c504e40
<0> ffff88041ccb9dd8 ffffffff810a75b7 ffff88042caf3120 ffff88042c687768
Call Trace:
  [<ffffffffa0290fc5>] nfs_file_release+0x5c/0x61 [nfs]
  [<ffffffff810a75b7>] __fput+0xf6/0x1bf
  [<ffffffff810a78ba>] fput+0x15/0x17
  [<ffffffff8108ccff>] remove_vma+0x36/0x6c
  [<ffffffff8108ce54>] exit_mmap+0x11f/0x141
  [<ffffffff81030119>] mmput+0x2d/0xc3
  [<ffffffff81033e9f>] exit_mm+0x10b/0x118
  [<ffffffff81064b75>] ? audit_free+0x191/0x1c4
  [<ffffffff81035074>] do_exit+0x200/0x685
  [<ffffffff81035567>] do_group_exit+0x6e/0x98
  [<ffffffff810355a3>] sys_exit_group+0x12/0x16
  [<ffffffff81001eab>] system_call_fastpath+0x16/0x1b
Code: 11 e1 49 8d 54 24 48 49 8b 4c 24 48 48 8b 42 08 48 89 41 08 48 89 
08 48 8d 83 78 ff ff ff 48 8b 48 08 49 89 44 24 48 48 89 50 08 <48> 89 
11 48 89 4a 08 fe 83 ac 00 00 00 41 8b 75 38 4c 89 e7 81
RIP  [<ffffffffa0292cdb>] nfs_release+0x64/0x94 [nfs]
  RSP <ffff88041ccb9d58>
---[ end trace 1ac7372e162481b8 ]---
Fixing recursive fault but reboot is needed!
mount: server antonrootfs.d.stor.en.desres.deshaw.com not responding, 
timed out
[root@antonfe0002 ~]# uptime
  20:58:04 up 12 days,  1:05,  4 users,  load average: 20.98, 20.23, 18.99
*
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 Nov20 ?        00:00:04 init [3]
root         2     0  0 Nov20 ?        00:00:00 [kthreadd]
root         3     2  0 Nov20 ?        00:00:00 [migration/0]
root         4     2  0 Nov20 ?        02:42:37 [ksoftirqd/0]
root         5     2  0 Nov20 ?        00:00:00 [migration/1]
root         6     2  3 Nov20 ?        10:04:25 [ksoftirqd/1]
root         7     2  0 Nov20 ?        00:00:00 [migration/2]
root         8     2  0 Nov20 ?        01:39:58 [ksoftirqd/2]
root         9     2  0 Nov20 ?        00:00:00 [migration/3]
root        10     2  4 Nov20 ?        13:28:17 [ksoftirqd/3]
root        11     2  0 Nov20 ?        00:00:00 [migration/4]
root        12     2  7 Nov20 ?        20:39:20 [ksoftirqd/4]
root        13     2  0 Nov20 ?        00:00:00 [migration/5]
root        14     2  0 Nov20 ?        00:06:39 [ksoftirqd/5]
root        15     2  0 Nov20 ?        00:00:00 [migration/6]
root        16     2  7 Nov20 ?        21:56:03 [ksoftirqd/6]
root        17     2  0 Nov20 ?        00:00:00 [migration/7]
root        18     2  1 Nov20 ?        03:06:59 [ksoftirqd/7]
root        19     2  0 Nov20 ?        00:00:06 [events/0]
root        20     2  0 Nov20 ?        00:00:22 [events/1]
root        21     2  0 Nov20 ?        00:00:09 [events/2]
root        22     2  0 Nov20 ?        00:00:08 [events/3]
root        23     2  0 Nov20 ?        00:00:05 [events/4]
root        24     2  0 Nov20 ?        00:00:33 [events/5]
root        25     2  0 Nov20 ?        00:00:07 [events/6]
root        26     2  0 Nov20 ?        00:00:12 [events/7]
root        27     2  0 Nov20 ?        00:00:00 [khelper]
root        32     2  0 Nov20 ?        00:00:00 [async/mgr]
root       175     2  0 Nov20 ?        00:00:00 [sync_supers]
root       177     2  0 Nov20 ?        00:00:00 [bdi-default]
root       178     2  0 Nov20 ?        00:00:00 [kintegrityd/0]
root       179     2  0 Nov20 ?        00:00:00 [kintegrityd/1]
root       180     2  0 Nov20 ?        00:00:00 [kintegrityd/2]
root       181     2  0 Nov20 ?        00:00:00 [kintegrityd/3]
root       182     2  0 Nov20 ?        00:00:00 [kintegrityd/4]
root       183     2  0 Nov20 ?        00:00:00 [kintegrityd/5]
root       184     2  0 Nov20 ?        00:00:00 [kintegrityd/6]
root       185     2  0 Nov20 ?        00:00:00 [kintegrityd/7]
root       186     2  0 Nov20 ?        00:00:00 [kblockd/0]
root       187     2  0 Nov20 ?        00:00:00 [kblockd/1]
root       188     2  0 Nov20 ?        00:00:00 [kblockd/2]
root       189     2  0 Nov20 ?        00:00:00 [kblockd/3]
root       190     2  0 Nov20 ?        00:00:00 [kblockd/4]
root       191     2  0 Nov20 ?        00:00:00 [kblockd/5]
root       192     2  0 Nov20 ?        00:00:00 [kblockd/6]
root       193     2  0 Nov20 ?        00:00:00 [kblockd/7]
root       195     2  0 Nov20 ?        00:00:00 [kacpid]
root       196     2  0 Nov20 ?        00:00:00 [kacpi_notify]
root       197     2  0 Nov20 ?        00:00:00 [kacpi_hotplug]
root       304     2  0 Nov20 ?        00:00:00 [khubd]
root       307     2  0 Nov20 ?        00:00:00 [kseriod]
root       416     2  0 Nov20 ?        00:00:00 [kswapd0]
root       417     2  0 Nov20 ?        00:00:00 [aio/0]
root       418     2  0 Nov20 ?        00:00:00 [aio/1]
root       419     2  0 Nov20 ?        00:00:00 [aio/2]
root       420     2  0 Nov20 ?        00:00:00 [aio/3]
root       421     2  0 Nov20 ?        00:00:00 [aio/4]
root       422     2  0 Nov20 ?        00:00:00 [aio/5]
root       423     2  0 Nov20 ?        00:00:00 [aio/6]
root       424     2  0 Nov20 ?        00:00:00 [aio/7]
root       426     2  0 Nov20 ?        00:00:00 [crypto/0]
root       427     2  0 Nov20 ?        00:00:00 [crypto/1]
root       428     2  0 Nov20 ?        00:00:00 [crypto/2]
root       429     2  0 Nov20 ?        00:00:00 [crypto/3]
root       430     2  0 Nov20 ?        00:00:00 [crypto/4]
root       431     2  0 Nov20 ?        00:00:00 [crypto/5]
root       432     2  0 Nov20 ?        00:00:00 [crypto/6]
root       433     2  0 Nov20 ?        00:00:00 [crypto/7]
root       635     2  0 Nov20 ?        00:00:00 [kpsmoused]
root       656     2  0 Nov20 ?        00:00:02 [edac-poller]
root       701     2  0 Nov20 ?        00:00:00 [usbhid_resumer]
root       713     2  0 Nov20 ?        00:00:00 [ata/0]
root       714     2  0 Nov20 ?        00:00:00 [ata/1]
root       715     2  0 Nov20 ?        00:00:00 [ata/2]
root       716     2  0 Nov20 ?        00:00:00 [ata/3]
root       717     2  0 Nov20 ?        00:00:00 [ata/4]
root       718     2  0 Nov20 ?        00:00:00 [ata/5]
root       719     2  0 Nov20 ?        00:00:00 [ata/6]
root       720     2  0 Nov20 ?        00:00:00 [ata/7]
root       721     2  0 Nov20 ?        00:00:00 [ata_aux]
root       724     2  0 Nov20 ?        00:00:00 [scsi_eh_0]
root       725     2  0 Nov20 ?        00:00:00 [scsi_eh_1]
root       733     2  0 Nov20 ?        00:00:00 [scsi_eh_2]
root       734     2  0 Nov20 ?        00:00:00 [usb-storage]
root       753     2  0 Nov20 ?        00:00:00 [kstriped]
root       759     2  0 Nov20 ?        00:00:00 [ksnapd]
root       763     2  0 Nov20 ?        00:33:13 [md3_raid1]
root       766     2  0 Nov20 ?        00:00:24 [md2_raid1]
root       769     2  0 Nov20 ?        00:00:46 [md1_raid1]
root       772     2  0 Nov20 ?        00:00:49 [md0_raid1]
root       777     2  0 Nov20 ?        00:00:00 [kjournald]
root       803     2  0 Nov20 ?        00:00:00 [kauditd]
root       840     1  0 Nov20 ?        00:00:03 /sbin/udevd -d
root      1450  3450  0 20:01 ?        00:00:00 crond
root      1451  1450  0 20:01 ?        00:00:00 /bin/bash 
/usr/bin/run-parts /et
root      1452  1451  0 20:01 ?        00:00:00 /bin/bash 
/etc/cron.hourly/mcelo
root      1453  1451  0 20:01 ?        00:00:00 awk -v 
progname=/etc/cron.hourly
root      1454  1452  0 20:01 ?        00:00:00 /usr/sbin/mcelog 
--ignorenodev -
0001001   2207  3393  0 20:10 ?        00:00:00 sshd: 0001001 [priv]
sshd      2208  2207  0 20:10 ?        00:00:00 sshd: 0001001 [net]
root      2210  3230  0 20:10 ?        00:00:00 /bin/mount -t nfs -s -o 
retry=10
root      2211  2210  0 20:10 ?        00:00:00 /sbin/mount.nfs fish1.nyc
root      2323     2  0 Nov20 ?        00:00:00 [kdmflush]
root      2358     2  0 Nov20 ?        00:00:00 [kjournald]
root      2359     2  0 Nov20 ?        00:00:01 [kjournald]
root      2585  3393  0 12:43 ?        00:00:00 sshd: 001002[priv]
001002    2590  2585  0 12:43 ?        00:00:00 sshd: 001002@pts/3
001002    2591  2590  0 12:43 pts/3    00:00:00 -bash
root      2740     2  0 17:53 ?        00:00:00 [kslowd000]
root      2933     1  0 Nov20 ?        00:00:00 auditd
root      2935  2933  0 Nov20 ?        00:00:00 /sbin/audispd
root      2962     2  0 Nov20 ?        00:26:41 [kipmi0]
root      2981     1  0 Nov20 ?        00:00:01 syslogd -m 0
root      2984     1  0 Nov20 ?        00:00:00 klogd -x
root      3019     1  0 Nov20 ?        00:00:00 cachefilesd
root      3031     1  0 Nov20 ?        00:01:50 irqbalance
rpc       3047     1  0 Nov20 ?        00:00:00 portmap
root      3073     2  0 Nov20 ?        00:00:00 [rpciod/0]
root      3074     2  0 Nov20 ?        00:00:00 [rpciod/1]
root      3075     2  0 Nov20 ?        00:00:00 [rpciod/2]
root      3076     2  0 Nov20 ?        00:00:00 [rpciod/3]
root      3077     2  0 Nov20 ?        00:00:00 [rpciod/4]
root      3078     2  0 Nov20 ?        00:00:00 [rpciod/5]
root      3079     2  0 Nov20 ?        00:00:00 [rpciod/6]
root      3080     2  0 Nov20 ?        00:00:00 [rpciod/7]
root      3086     1  0 Nov20 ?        00:00:00 rpc.statd
root      3135     1  0 Nov20 ?        00:00:02 mdadm --monitor --scan 
-f --pid-
root      3156     1  0 Nov20 ?        00:00:01 rpc.idmapd
root      3195     1  0 Nov20 ?        00:00:00 /usr/sbin/acpid
root      3230     1  0 Nov20 ?        00:02:33 automount
daemon    3318     1  0 Nov20 ?        00:00:35 /usr/sbin/munged
root      3333     1  0 Nov20 ?        00:02:07 /usr/sbin/snmpd -Lsd -Lf 
/dev/nu
distcc    3378     1  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3379  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
root      3393     1  0 Nov20 ?        00:00:00 /usr/sbin/sshd
distcc    3412  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3414  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
root      3450     1  0 Nov20 ?        00:00:01 crond
distcc    3459  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
root      3466     1  0 Nov20 ?        00:00:00 /opt/slurm/sbin/slurmd
postfix   3476     1  0 Nov20 ?        00:00:00 /usr/sbin/nullmailer-send
root      3496     1  0 Nov20 ?        00:00:00 /usr/sbin/atd
distcc    3564  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3594  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
root      3596     1  0 Nov20 ?        00:00:00 /usr/sbin/smartd -q never
root      3599     1  0 Nov20 tty1     00:00:00 /sbin/mingetty tty1
root      3600     1  0 Nov20 tty2     00:00:00 /sbin/mingetty tty2
root      3601     1  0 Nov20 tty3     00:00:00 /sbin/mingetty tty3
root      3602     1  0 Nov20 tty4     00:00:00 /sbin/mingetty tty4
root      3603     1  0 Nov20 tty5     00:00:00 /sbin/mingetty tty5
root      3604     1  0 Nov20 tty6     00:00:00 /sbin/mingetty tty6
distcc    3618  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3620  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3623  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
distcc    3626  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
--daemon --allo
root      3638     1  0 Nov20 ttyS1    00:00:00 /sbin/agetty -L ttyS1 
19200 vt10
root      3639     1  0 Nov20 ttyS0    00:00:00 /sbin/agetty -L ttyS0 
115200 vt1
root      3650     2  0 Nov20 ?        00:00:00 [nfsiod]
root      4782     1  0 Nov20 ?        00:00:33 /usr/bin/python 
/opt/rocks/bin/g
nobody    4824     1  0 Nov20 ?        00:00:35 /usr/sbin/gmond
root      5164  3393  0 20:48 ?        00:00:00 sshd: root@pts/8
001003    5211     1  0 20:48 ?        00:00:00 /usr/bin/xauth -q -
root      6264  3393  0 20:57 ?        00:00:00 sshd: root@pts/10
root      6274  6264  0 20:57 pts/10   00:00:00 -bash
root      6335  6274  0 20:58 pts/10   00:00:00 ps -ef
root      7138     2  0 Nov20 ?        00:00:00 [lockd]
001003    7607     1  0 17:55 ?        00:00:00 -bash
root      7890  3393  0 Nov20 ?        00:00:00 sshd: 001004 [priv]
001004    7898  7890  0 Nov20 ?        00:00:03 sshd: 001004@pts/0
001004    7899  7898  0 Nov20 pts/0    00:00:00 -tcsh
root     25087     2  0 16:12 ?        00:00:00 [kslowd001]
ntp      25923     1  0 05:38 ?        00:00:00 ntpd -u ntp:ntp -p 
/var/run/ntpd
root     27886  3393  0 Nov22 ?        00:00:00 sshd: 001005 [priv]
001005   27893 27886  0 Nov22 ?        00:00:02 sshd: 001005@pts/1
001005   27895 27893  0 Nov22 pts/1    00:00:00 -bash
001003   28573  7607  0 19:03 ?        00:00:00 [python2.5]
001003   29197     1  0 19:10 ?        00:00:00 -bash
001003   30030 29197 99 19:11 ?        01:46:10 python2.5 
/u/nyc/001003/lib/root
001003   30127     1  0 19:12 ?        00:00:00 /usr/bin/xauth -q -
001003   30149     1  0 19:12 ?        00:00:00 -bash
root     30181  3230  0 19:12 ?        00:00:00 /bin/mount -t nfs -s -o 
retry=10
root     30182 30181  0 19:12 ?        00:00:00 /sbin/mount.nfs host3.nyc
root     30245  3393  0 19:13 ?        00:00:00 sshd: root@pts/7
root     30353     1  0 19:14 ?        00:00:00 /sbin/umount.nfs 
/data/desrad-p
root     30504     1  0 19:16 ?        00:00:00 /sbin/umount.nfs 
/u/nyc/001008
root     31003  3230  0 19:22 ?        00:00:00 /bin/mount -t nfs -s -o 
retry=10
root     31004 31003  0 19:22 ?        00:00:00 /sbin/mount.nfs host3.nyc
root     31569     1  0 19:30 ?        00:00:00 /sbin/umount.nfs 
/proj/desrad-a
root     31632     1  0 19:31 ?        00:00:00 /sbin/umount.nfs 
/u/nyc/0001001
root     31653     1  0 19:31 ?        00:00:00 /sbin/umount.nfs 
/proj/desrad

