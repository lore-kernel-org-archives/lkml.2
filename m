Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0LCRgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:36:06 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:49786 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0LCRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:36:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19705.10909.860332.657164@quad.stoffel.home>
Date: Fri, 3 Dec 2010 12:36:29 -0500
From: "John Stoffel" <john@stoffel.org>
To: Doug Hughes <doug@will.to>
Cc: linux-kernel@vger.kernel.org
Subject: Re: strange linux kernel NFS problem(s)
In-Reply-To: <4CF858A3.2050202@will.to>
References: <4CF858A3.2050202@will.to>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Doug" == Doug Hughes <doug@will.to> writes:

Doug> So, this is my first post, but not my first problem of this
Doug> nature. It just so happens that this is the first one with a
Doug> recent kernel to give useful data, useful enough to post it and
Doug> seek some advice on the subject:

kernel 2.6.34 is still pretty old, and there have been lots of NFS
fixes.  Can you upgrade to something newer as a test?  Also, what
distro are you using?  

Is this an NFS client or the NFS server which is crapping out?  More
details please...

John


Doug> symptoms: machine gets high load, nfs mount processes hang, and things 
Doug> (particularly NFS) stop working. ssh and ip connectivity still works, as 
Doug> does ps.

Doug> *general protection fault: 0000 [#1] SMP
Doug> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Doug> CPU 1
Doug> Modules linked in: nfs auth_rpcgss autofs4 i2c_dev i2c_core lockd sunrpc 
Doug> cachefiles fscache ipmi_si ipmi_devintf ipmi_msghandler ip6t_REJECT 
Doug> xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 video output battery 
Doug> ac parport_pc lp parport joydev button sr_mod pcspkr iTCO_wdt shpchp 
Doug> dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod usb_storage 
Doug> pata_acpi ata_piix ata_generic libata uhci_hcd ohci_hcd ehci_hcd [last 
Doug> unloaded: microcode]

Doug> Pid: 28573, comm: python2.5 Not tainted 2.6.34 #3 X7DWT/X7DWT
Doug> RIP: 0010:[<ffffffffa0292cdb>]  [<ffffffffa0292cdb>] 
Doug> nfs_release+0x64/0x94 [nfs]
Doug> RSP: 0018:ffff88041ccb9d58  EFLAGS: 00010246
Doug> RAX: ffff88041c47d160 RBX: ffff88041c47d1e8 RCX: ff88041c47d16088
Doug> RDX: ffff88042c593288 RSI: ffff88042c504e40 RDI: ffff88041c47d294
Doug> RBP: ffff88041ccb9d78 R08: 0000000000000000 R09: 0000000000000000
Doug> R10: 0000000300000000 R11: 0000000000000000 R12: ffff88042c593240
Doug> R13: ffff88042c504e40 R14: ffff88041ea59ec0 R15: ffff8804273f55c0
Doug> FS:  0000000000000000(0000) GS:ffff880001840000(0000) knlGS:0000000000000000
Doug> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Doug> CR2: 0000003fd5c03350 CR3: 0000000001613000 CR4: 00000000000006e0
Doug> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Doug> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Doug> Process python2.5 (pid: 28573, threadinfo ffff88041ccb8000, task 
Doug> ffff8803e246adf0)
Doug> Stack:
Doug>   0000000300000000 ffff88042c504e40 ffff88041c47d1e8 ffff88041c47d1e8
Doug> <0> ffff88041ccb9d98 ffffffffa0290fc5 0000000000000010 ffff88042c504e40
Doug> <0> ffff88041ccb9dd8 ffffffff810a75b7 ffff88042caf3120 ffff88042c687768
Doug> Call Trace:
Doug>   [<ffffffffa0290fc5>] nfs_file_release+0x5c/0x61 [nfs]
Doug>   [<ffffffff810a75b7>] __fput+0xf6/0x1bf
Doug>   [<ffffffff810a78ba>] fput+0x15/0x17
Doug>   [<ffffffff8108ccff>] remove_vma+0x36/0x6c
Doug>   [<ffffffff8108ce54>] exit_mmap+0x11f/0x141
Doug>   [<ffffffff81030119>] mmput+0x2d/0xc3
Doug>   [<ffffffff81033e9f>] exit_mm+0x10b/0x118
Doug>   [<ffffffff81064b75>] ? audit_free+0x191/0x1c4
Doug>   [<ffffffff81035074>] do_exit+0x200/0x685
Doug>   [<ffffffff81035567>] do_group_exit+0x6e/0x98
Doug>   [<ffffffff810355a3>] sys_exit_group+0x12/0x16
Doug>   [<ffffffff81001eab>] system_call_fastpath+0x16/0x1b
Doug> Code: 11 e1 49 8d 54 24 48 49 8b 4c 24 48 48 8b 42 08 48 89 41 08 48 89 
Doug> 08 48 8d 83 78 ff ff ff 48 8b 48 08 49 89 44 24 48 48 89 50 08 <48> 89 
Doug> 11 48 89 4a 08 fe 83 ac 00 00 00 41 8b 75 38 4c 89 e7 81
Doug> RIP  [<ffffffffa0292cdb>] nfs_release+0x64/0x94 [nfs]
Doug>   RSP <ffff88041ccb9d58>
Doug> ---[ end trace 1ac7372e162481b8 ]---
Doug> Fixing recursive fault but reboot is needed!
Doug> mount: server antonrootfs.d.stor.en.desres.deshaw.com not responding, 
Doug> timed out
Doug> [root@antonfe0002 ~]# uptime
Doug>   20:58:04 up 12 days,  1:05,  4 users,  load average: 20.98, 20.23, 18.99
Doug> *
Doug> UID        PID  PPID  C STIME TTY          TIME CMD
Doug> root         1     0  0 Nov20 ?        00:00:04 init [3]
Doug> root         2     0  0 Nov20 ?        00:00:00 [kthreadd]
Doug> root         3     2  0 Nov20 ?        00:00:00 [migration/0]
Doug> root         4     2  0 Nov20 ?        02:42:37 [ksoftirqd/0]
Doug> root         5     2  0 Nov20 ?        00:00:00 [migration/1]
Doug> root         6     2  3 Nov20 ?        10:04:25 [ksoftirqd/1]
Doug> root         7     2  0 Nov20 ?        00:00:00 [migration/2]
Doug> root         8     2  0 Nov20 ?        01:39:58 [ksoftirqd/2]
Doug> root         9     2  0 Nov20 ?        00:00:00 [migration/3]
Doug> root        10     2  4 Nov20 ?        13:28:17 [ksoftirqd/3]
Doug> root        11     2  0 Nov20 ?        00:00:00 [migration/4]
Doug> root        12     2  7 Nov20 ?        20:39:20 [ksoftirqd/4]
Doug> root        13     2  0 Nov20 ?        00:00:00 [migration/5]
Doug> root        14     2  0 Nov20 ?        00:06:39 [ksoftirqd/5]
Doug> root        15     2  0 Nov20 ?        00:00:00 [migration/6]
Doug> root        16     2  7 Nov20 ?        21:56:03 [ksoftirqd/6]
Doug> root        17     2  0 Nov20 ?        00:00:00 [migration/7]
Doug> root        18     2  1 Nov20 ?        03:06:59 [ksoftirqd/7]
Doug> root        19     2  0 Nov20 ?        00:00:06 [events/0]
Doug> root        20     2  0 Nov20 ?        00:00:22 [events/1]
Doug> root        21     2  0 Nov20 ?        00:00:09 [events/2]
Doug> root        22     2  0 Nov20 ?        00:00:08 [events/3]
Doug> root        23     2  0 Nov20 ?        00:00:05 [events/4]
Doug> root        24     2  0 Nov20 ?        00:00:33 [events/5]
Doug> root        25     2  0 Nov20 ?        00:00:07 [events/6]
Doug> root        26     2  0 Nov20 ?        00:00:12 [events/7]
Doug> root        27     2  0 Nov20 ?        00:00:00 [khelper]
Doug> root        32     2  0 Nov20 ?        00:00:00 [async/mgr]
Doug> root       175     2  0 Nov20 ?        00:00:00 [sync_supers]
Doug> root       177     2  0 Nov20 ?        00:00:00 [bdi-default]
Doug> root       178     2  0 Nov20 ?        00:00:00 [kintegrityd/0]
Doug> root       179     2  0 Nov20 ?        00:00:00 [kintegrityd/1]
Doug> root       180     2  0 Nov20 ?        00:00:00 [kintegrityd/2]
Doug> root       181     2  0 Nov20 ?        00:00:00 [kintegrityd/3]
Doug> root       182     2  0 Nov20 ?        00:00:00 [kintegrityd/4]
Doug> root       183     2  0 Nov20 ?        00:00:00 [kintegrityd/5]
Doug> root       184     2  0 Nov20 ?        00:00:00 [kintegrityd/6]
Doug> root       185     2  0 Nov20 ?        00:00:00 [kintegrityd/7]
Doug> root       186     2  0 Nov20 ?        00:00:00 [kblockd/0]
Doug> root       187     2  0 Nov20 ?        00:00:00 [kblockd/1]
Doug> root       188     2  0 Nov20 ?        00:00:00 [kblockd/2]
Doug> root       189     2  0 Nov20 ?        00:00:00 [kblockd/3]
Doug> root       190     2  0 Nov20 ?        00:00:00 [kblockd/4]
Doug> root       191     2  0 Nov20 ?        00:00:00 [kblockd/5]
Doug> root       192     2  0 Nov20 ?        00:00:00 [kblockd/6]
Doug> root       193     2  0 Nov20 ?        00:00:00 [kblockd/7]
Doug> root       195     2  0 Nov20 ?        00:00:00 [kacpid]
Doug> root       196     2  0 Nov20 ?        00:00:00 [kacpi_notify]
Doug> root       197     2  0 Nov20 ?        00:00:00 [kacpi_hotplug]
Doug> root       304     2  0 Nov20 ?        00:00:00 [khubd]
Doug> root       307     2  0 Nov20 ?        00:00:00 [kseriod]
Doug> root       416     2  0 Nov20 ?        00:00:00 [kswapd0]
Doug> root       417     2  0 Nov20 ?        00:00:00 [aio/0]
Doug> root       418     2  0 Nov20 ?        00:00:00 [aio/1]
Doug> root       419     2  0 Nov20 ?        00:00:00 [aio/2]
Doug> root       420     2  0 Nov20 ?        00:00:00 [aio/3]
Doug> root       421     2  0 Nov20 ?        00:00:00 [aio/4]
Doug> root       422     2  0 Nov20 ?        00:00:00 [aio/5]
Doug> root       423     2  0 Nov20 ?        00:00:00 [aio/6]
Doug> root       424     2  0 Nov20 ?        00:00:00 [aio/7]
Doug> root       426     2  0 Nov20 ?        00:00:00 [crypto/0]
Doug> root       427     2  0 Nov20 ?        00:00:00 [crypto/1]
Doug> root       428     2  0 Nov20 ?        00:00:00 [crypto/2]
Doug> root       429     2  0 Nov20 ?        00:00:00 [crypto/3]
Doug> root       430     2  0 Nov20 ?        00:00:00 [crypto/4]
Doug> root       431     2  0 Nov20 ?        00:00:00 [crypto/5]
Doug> root       432     2  0 Nov20 ?        00:00:00 [crypto/6]
Doug> root       433     2  0 Nov20 ?        00:00:00 [crypto/7]
Doug> root       635     2  0 Nov20 ?        00:00:00 [kpsmoused]
Doug> root       656     2  0 Nov20 ?        00:00:02 [edac-poller]
Doug> root       701     2  0 Nov20 ?        00:00:00 [usbhid_resumer]
Doug> root       713     2  0 Nov20 ?        00:00:00 [ata/0]
Doug> root       714     2  0 Nov20 ?        00:00:00 [ata/1]
Doug> root       715     2  0 Nov20 ?        00:00:00 [ata/2]
Doug> root       716     2  0 Nov20 ?        00:00:00 [ata/3]
Doug> root       717     2  0 Nov20 ?        00:00:00 [ata/4]
Doug> root       718     2  0 Nov20 ?        00:00:00 [ata/5]
Doug> root       719     2  0 Nov20 ?        00:00:00 [ata/6]
Doug> root       720     2  0 Nov20 ?        00:00:00 [ata/7]
Doug> root       721     2  0 Nov20 ?        00:00:00 [ata_aux]
Doug> root       724     2  0 Nov20 ?        00:00:00 [scsi_eh_0]
Doug> root       725     2  0 Nov20 ?        00:00:00 [scsi_eh_1]
Doug> root       733     2  0 Nov20 ?        00:00:00 [scsi_eh_2]
Doug> root       734     2  0 Nov20 ?        00:00:00 [usb-storage]
Doug> root       753     2  0 Nov20 ?        00:00:00 [kstriped]
Doug> root       759     2  0 Nov20 ?        00:00:00 [ksnapd]
Doug> root       763     2  0 Nov20 ?        00:33:13 [md3_raid1]
Doug> root       766     2  0 Nov20 ?        00:00:24 [md2_raid1]
Doug> root       769     2  0 Nov20 ?        00:00:46 [md1_raid1]
Doug> root       772     2  0 Nov20 ?        00:00:49 [md0_raid1]
Doug> root       777     2  0 Nov20 ?        00:00:00 [kjournald]
Doug> root       803     2  0 Nov20 ?        00:00:00 [kauditd]
Doug> root       840     1  0 Nov20 ?        00:00:03 /sbin/udevd -d
Doug> root      1450  3450  0 20:01 ?        00:00:00 crond
Doug> root      1451  1450  0 20:01 ?        00:00:00 /bin/bash 
Doug> /usr/bin/run-parts /et
Doug> root      1452  1451  0 20:01 ?        00:00:00 /bin/bash 
Doug> /etc/cron.hourly/mcelo
Doug> root      1453  1451  0 20:01 ?        00:00:00 awk -v 
Doug> progname=/etc/cron.hourly
Doug> root      1454  1452  0 20:01 ?        00:00:00 /usr/sbin/mcelog 
Doug> --ignorenodev -
Doug> 0001001   2207  3393  0 20:10 ?        00:00:00 sshd: 0001001 [priv]
Doug> sshd      2208  2207  0 20:10 ?        00:00:00 sshd: 0001001 [net]
Doug> root      2210  3230  0 20:10 ?        00:00:00 /bin/mount -t nfs -s -o 
Doug> retry=10
Doug> root      2211  2210  0 20:10 ?        00:00:00 /sbin/mount.nfs fish1.nyc
Doug> root      2323     2  0 Nov20 ?        00:00:00 [kdmflush]
Doug> root      2358     2  0 Nov20 ?        00:00:00 [kjournald]
Doug> root      2359     2  0 Nov20 ?        00:00:01 [kjournald]
Doug> root      2585  3393  0 12:43 ?        00:00:00 sshd: 001002[priv]
Doug> 001002    2590  2585  0 12:43 ?        00:00:00 sshd: 001002@pts/3
Doug> 001002    2591  2590  0 12:43 pts/3    00:00:00 -bash
Doug> root      2740     2  0 17:53 ?        00:00:00 [kslowd000]
Doug> root      2933     1  0 Nov20 ?        00:00:00 auditd
Doug> root      2935  2933  0 Nov20 ?        00:00:00 /sbin/audispd
Doug> root      2962     2  0 Nov20 ?        00:26:41 [kipmi0]
Doug> root      2981     1  0 Nov20 ?        00:00:01 syslogd -m 0
Doug> root      2984     1  0 Nov20 ?        00:00:00 klogd -x
Doug> root      3019     1  0 Nov20 ?        00:00:00 cachefilesd
Doug> root      3031     1  0 Nov20 ?        00:01:50 irqbalance
Doug> rpc       3047     1  0 Nov20 ?        00:00:00 portmap
Doug> root      3073     2  0 Nov20 ?        00:00:00 [rpciod/0]
Doug> root      3074     2  0 Nov20 ?        00:00:00 [rpciod/1]
Doug> root      3075     2  0 Nov20 ?        00:00:00 [rpciod/2]
Doug> root      3076     2  0 Nov20 ?        00:00:00 [rpciod/3]
Doug> root      3077     2  0 Nov20 ?        00:00:00 [rpciod/4]
Doug> root      3078     2  0 Nov20 ?        00:00:00 [rpciod/5]
Doug> root      3079     2  0 Nov20 ?        00:00:00 [rpciod/6]
Doug> root      3080     2  0 Nov20 ?        00:00:00 [rpciod/7]
Doug> root      3086     1  0 Nov20 ?        00:00:00 rpc.statd
Doug> root      3135     1  0 Nov20 ?        00:00:02 mdadm --monitor --scan 
Doug> -f --pid-
Doug> root      3156     1  0 Nov20 ?        00:00:01 rpc.idmapd
Doug> root      3195     1  0 Nov20 ?        00:00:00 /usr/sbin/acpid
Doug> root      3230     1  0 Nov20 ?        00:02:33 automount
Doug> daemon    3318     1  0 Nov20 ?        00:00:35 /usr/sbin/munged
Doug> root      3333     1  0 Nov20 ?        00:02:07 /usr/sbin/snmpd -Lsd -Lf 
Doug> /dev/nu
Doug> distcc    3378     1  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3379  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> root      3393     1  0 Nov20 ?        00:00:00 /usr/sbin/sshd
Doug> distcc    3412  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3414  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> root      3450     1  0 Nov20 ?        00:00:01 crond
Doug> distcc    3459  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> root      3466     1  0 Nov20 ?        00:00:00 /opt/slurm/sbin/slurmd
Doug> postfix   3476     1  0 Nov20 ?        00:00:00 /usr/sbin/nullmailer-send
Doug> root      3496     1  0 Nov20 ?        00:00:00 /usr/sbin/atd
Doug> distcc    3564  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3594  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> root      3596     1  0 Nov20 ?        00:00:00 /usr/sbin/smartd -q never
Doug> root      3599     1  0 Nov20 tty1     00:00:00 /sbin/mingetty tty1
Doug> root      3600     1  0 Nov20 tty2     00:00:00 /sbin/mingetty tty2
Doug> root      3601     1  0 Nov20 tty3     00:00:00 /sbin/mingetty tty3
Doug> root      3602     1  0 Nov20 tty4     00:00:00 /sbin/mingetty tty4
Doug> root      3603     1  0 Nov20 tty5     00:00:00 /sbin/mingetty tty5
Doug> root      3604     1  0 Nov20 tty6     00:00:00 /sbin/mingetty tty6
Doug> distcc    3618  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3620  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3623  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> distcc    3626  3378  0 Nov20 ?        00:00:00 /usr/bin/distccd 
Doug> --daemon --allo
Doug> root      3638     1  0 Nov20 ttyS1    00:00:00 /sbin/agetty -L ttyS1 
Doug> 19200 vt10
Doug> root      3639     1  0 Nov20 ttyS0    00:00:00 /sbin/agetty -L ttyS0 
Doug> 115200 vt1
Doug> root      3650     2  0 Nov20 ?        00:00:00 [nfsiod]
Doug> root      4782     1  0 Nov20 ?        00:00:33 /usr/bin/python 
Doug> /opt/rocks/bin/g
Doug> nobody    4824     1  0 Nov20 ?        00:00:35 /usr/sbin/gmond
Doug> root      5164  3393  0 20:48 ?        00:00:00 sshd: root@pts/8
Doug> 001003    5211     1  0 20:48 ?        00:00:00 /usr/bin/xauth -q -
Doug> root      6264  3393  0 20:57 ?        00:00:00 sshd: root@pts/10
Doug> root      6274  6264  0 20:57 pts/10   00:00:00 -bash
Doug> root      6335  6274  0 20:58 pts/10   00:00:00 ps -ef
Doug> root      7138     2  0 Nov20 ?        00:00:00 [lockd]
Doug> 001003    7607     1  0 17:55 ?        00:00:00 -bash
Doug> root      7890  3393  0 Nov20 ?        00:00:00 sshd: 001004 [priv]
Doug> 001004    7898  7890  0 Nov20 ?        00:00:03 sshd: 001004@pts/0
Doug> 001004    7899  7898  0 Nov20 pts/0    00:00:00 -tcsh
Doug> root     25087     2  0 16:12 ?        00:00:00 [kslowd001]
Doug> ntp      25923     1  0 05:38 ?        00:00:00 ntpd -u ntp:ntp -p 
Doug> /var/run/ntpd
Doug> root     27886  3393  0 Nov22 ?        00:00:00 sshd: 001005 [priv]
Doug> 001005   27893 27886  0 Nov22 ?        00:00:02 sshd: 001005@pts/1
Doug> 001005   27895 27893  0 Nov22 pts/1    00:00:00 -bash
Doug> 001003   28573  7607  0 19:03 ?        00:00:00 [python2.5]
Doug> 001003   29197     1  0 19:10 ?        00:00:00 -bash
Doug> 001003   30030 29197 99 19:11 ?        01:46:10 python2.5 
Doug> /u/nyc/001003/lib/root
Doug> 001003   30127     1  0 19:12 ?        00:00:00 /usr/bin/xauth -q -
Doug> 001003   30149     1  0 19:12 ?        00:00:00 -bash
Doug> root     30181  3230  0 19:12 ?        00:00:00 /bin/mount -t nfs -s -o 
Doug> retry=10
Doug> root     30182 30181  0 19:12 ?        00:00:00 /sbin/mount.nfs host3.nyc
Doug> root     30245  3393  0 19:13 ?        00:00:00 sshd: root@pts/7
Doug> root     30353     1  0 19:14 ?        00:00:00 /sbin/umount.nfs 
Doug> /data/desrad-p
Doug> root     30504     1  0 19:16 ?        00:00:00 /sbin/umount.nfs 
Doug> /u/nyc/001008
Doug> root     31003  3230  0 19:22 ?        00:00:00 /bin/mount -t nfs -s -o 
Doug> retry=10
Doug> root     31004 31003  0 19:22 ?        00:00:00 /sbin/mount.nfs host3.nyc
Doug> root     31569     1  0 19:30 ?        00:00:00 /sbin/umount.nfs 
Doug> /proj/desrad-a
Doug> root     31632     1  0 19:31 ?        00:00:00 /sbin/umount.nfs 
Doug> /u/nyc/0001001
Doug> root     31653     1  0 19:31 ?        00:00:00 /sbin/umount.nfs 
Doug> /proj/desrad

Doug> --
Doug> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Doug> the body of a message to majordomo@vger.kernel.org
Doug> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Doug> Please read the FAQ at  http://www.tux.org/lkml/

-- 
