Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1CARzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:55:12 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:40516 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233Ab1CARzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:55:10 -0500
Message-ID: <4D6D32F3.3000305@blueyonder.co.uk>
Date: Tue, 01 Mar 2011 17:54:59 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7 ThunderBrowse/3.3.4
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc3-git installed modules zero bytes long - only on root
 xfs
References: <4CF5116B.8040204@blueyonder.co.uk> <4D685A53.9000900@blueyonder.co.uk> <4D6870A9.7070405@blueyonder.co.uk>
In-Reply-To: <4D6870A9.7070405@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem occurs on the systems with root on xfs, the boxes with ext4 
have not been affected.
On the 2 affected boxes, 2.6.36-rc6-git6 - one had no problems and and 
one several rebuilds and reinstalls of modules had to be done to get it 
to work with the exception of one module.
slipstream:/home/lancelot # depmod -ae -F /boot/System.map
WARNING: Can't read module
/lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/mtd/nftl.ko: Not a directory

Listing the module it says 0 bytes whereas before the reboot it was OK.
slipstream:/home/lancelot # l
/lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/mtd/nftl.ko
-rw-r--r-- 1 root root 0 Feb 26 22:33
/lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/mtd/nftl.ko

# rpm -qa|grep xfsprogs 

xfsprogs-3.1.4-1.3.x86_64

slipstream:/home/lancelot # df -T
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
rootfs      rootfs   903211908 615966196 287245712  69% /
devtmpfs  devtmpfs     4056088      1024   4055064   1% /dev
tmpfs        tmpfs     4096140     14928   4081212   1% /dev/shm
/dev/sda2      xfs   903211908 615966196 287245712  69% /
none         tmpfs     4096140         0   4096140   0% /lib/bootchart/tmpfs
/dev/sda1 reiserfs    52426492    854848  51571644   2% /boot
/dev/sdb1 reiserfs   302735588 263377460  39358128  87% 
/home/lancelot/ftp
none         tmpfs     4096140       252   4095888   1% /tmp 

none         tmpfs     4096140         0   4096140   0% 
/lib/bootchart/tmpfs

tindog:~ # df -T
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
rootfs      rootfs   912135984 386160972 525975012  43% /
devtmpfs  devtmpfs     1990668       316   1990352   1% /dev
tmpfs        tmpfs     2029860      4476   2025384   1% /dev/shm
/dev/sda1      xfs   912135984 386160972 525975012  43% /
none         tmpfs     2029860         0   2029860   0% /lib/bootchart/tmpfs
/dev/sdb1    btrfs   419931036  47466788 362246284  12% /data1
none         tmpfs     2029860       568   2029292   1% /tmp
none         tmpfs     2029860         0   2029860   0% /lib/bootchart/tmpfs
Regards
Sid.

On 26/02/11 03:16, Sid Boyce wrote:
> The laptop with Model: 15.104.2 "AMD Turion(tm) 64 X2 Mobile Technology
> TL-58"
> is also at 11.4 RC1, no problem after the reboot.
> sepulot:~ # l /lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/net
> total 48280
> drwxr-xr-x 43 root root 4096 Feb 26 03:02 ./
> drwxr-xr-x 61 root root 4096 Feb 26 03:03 ../
> -rw-r--r-- 1 root root 665983 Feb 26 03:02 3c59x.ko
> -rw-r--r-- 1 root root 635335 Feb 26 03:02 8139cp.ko
> -rw-r--r-- 1 root root 560068 Feb 26 03:02 8139too.ko
> -rw-r--r-- 1 root root 410065 Feb 26 03:02 8390.ko
> etc.
> Regards
> Sid.
>
> On 26/02/11 01:41, Sid Boyce wrote:
>> This problem has showed up again in 2.6.38-rc6-git5 and openSUSE 11.4
>> RC1. The previous kernel 2.6.38-rc6-git2 was OK.
>> The modules are OK before a reboot, after a reboot all modules are zero
>> bytes long. I'm building 2.6.38-rc6-git6 to see if that suffers the same
>> problem, e.g.
>> # ls -l /lib/modules/2.6.38-rc6-git5/kernel/drivers/net|less
>> total 3652
>> drwxr-xr-x 34 root root 4096 Feb 26 00:10 ./
>> drwxr-xr-x 52 root root 4096 Feb 26 00:10 ../
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 3c59x.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 8139cp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 8139too.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 8390.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 acenic.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 amd8111e.ko
>> drwxr-xr-x 2 root root 21 Feb 26 00:10 appletalk/
>> drwxr-xr-x 2 root root 21 Feb 26 00:10 atl1c/
>> drwxr-xr-x 2 root root 21 Feb 26 00:10 atl1e/
>> drwxr-xr-x 2 root root 34 Feb 26 00:10 atlx/
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 atp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 b44.ko
>> drwxr-xr-x 2 root root 22 Feb 26 00:10 benet/
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 bnx2.ko
>> drwxr-xr-x 2 root root 21 Feb 26 00:10 bnx2x/
>> drwxr-xr-x 2 root root 23 Feb 26 00:10 bonding/
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 bsd_comp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 cassini.ko
>> drwxr-xr-x 2 root root 20 Feb 26 00:10 chelsio/
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 cnic.ko
>> drwxr-xr-x 2 root root 21 Feb 26 00:10 cxgb3/
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 de600.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 de620.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 defxx.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 dl2k.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 dnet.ko
>> -rw-r--r-- 1 root root 0 Feb 26 00:10 dummy.ko
>>
>> Asus Crosshair III Motherboard, Phenom II X4 and 8G of memory. I have
>> seen the same problem on another Asus box ASUS M2N32-SLI Deluxe, Athlon
>> 64X2 6000+, 6G of memory.
>> slipstream:/usr/src/linux-2.6.38-rc6-git6 # l
>> /lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/net|less
>> total 3184
>> drwxr-xr-x 34 root root 4096 Feb 26 01:04 ./
>> drwxr-xr-x 52 root root 4096 Feb 26 01:05 ../
>> -rw-r--r-- 1 root root 89335 Feb 26 01:04 3c59x.ko
>> -rw-r--r-- 1 root root 38119 Feb 26 01:04 8139cp.ko
>> -rw-r--r-- 1 root root 57751 Feb 26 01:04 8139too.ko
>> -rw-r--r-- 1 root root 16304 Feb 26 01:04 8390.ko
>> -rw-r--r-- 1 root root 46020 Feb 26 01:04 acenic.ko
>> -rw-r--r-- 1 root root 32751 Feb 26 01:04 amd8111e.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 appletalk/
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 atl1c/
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 atl1e/
>> drwxr-xr-x 2 root root 34 Feb 26 01:04 atlx/
>> -rw-r--r-- 1 root root 19580 Feb 26 01:04 atp.ko
>> -rw-r--r-- 1 root root 45240 Feb 26 01:04 b44.ko
>> drwxr-xr-x 2 root root 22 Feb 26 01:04 benet/
>> -rw-r--r-- 1 root root 101219 Feb 26 01:04 bnx2.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 bnx2x/
>> drwxr-xr-x 2 root root 23 Feb 26 01:04 bonding/
>> -rw-r--r-- 1 root root 9346 Feb 26 01:04 bsd_comp.ko
>> -rw-r--r-- 1 root root 67407 Feb 26 01:04 cassini.ko
>> drwxr-xr-x 2 root root 20 Feb 26 01:04 chelsio/
>> -rw-r--r-- 1 root root 74672 Feb 26 01:04 cnic.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 cxgb3/
>> -rw-r--r-- 1 root root 22436 Feb 26 01:04 de600.ko
>> -rw-r--r-- 1 root root 26692 Feb 26 01:04 de620.ko
>> -rw-r--r-- 1 root root 24494 Feb 26 01:04 defxx.ko
>> -rw-r--r-- 1 root root 35267 Feb 26 01:04 dl2k.ko
>> -rw-r--r-- 1 root root 30334 Feb 26 01:04 dnet.ko
>> -rw-r--r-- 1 root root 7527 Feb 26 01:04 dummy.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 e1000/
>> drwxr-xr-x 2 root root 22 Feb 26 01:04 e1000e/
>> -rw-r--r-- 1 root root 54097 Feb 26 01:04 e100.ko
>> -rw-r--r-- 1 root root 33518 Feb 26 01:04 enc28j60.ko
>> slipstream:/usr/src/linux-2.6.38-rc6-git6 # l
>> /lib/modules/2.6.38-rc6-git6-smp/kernel/drivers/usb/serial/
>> total 1440
>> drwxr-xr-x 2 root root 4096 Feb 26 01:05 ./
>> drwxr-xr-x 10 root root 108 Feb 26 01:05 ../
>> -rw-r--r-- 1 root root 8239 Feb 26 01:04 aircable.ko
>> -rw-r--r-- 1 root root 17764 Feb 26 01:04 ark3116.ko
>> -rw-r--r-- 1 root root 17138 Feb 26 01:04 belkin_sa.ko
>> -rw-r--r-- 1 root root 18969 Feb 26 01:04 ch341.ko
>> -rw-r--r-- 1 root root 30341 Feb 26 01:04 cp210x.ko
>> -rw-r--r-- 1 root root 20317 Feb 26 01:05 cyberjack.ko
>> -rw-r--r-- 1 root root 38456 Feb 26 01:05 cypress_m8.ko
>> -rw-r--r-- 1 root root 31567 Feb 26 01:05 digi_acceleport.ko
>> -rw-r--r-- 1 root root 7316 Feb 26 01:05 empeg.ko
>> -rw-r--r-- 1 root root 103261 Feb 26 01:05 ftdi_sio.ko
>> -rw-r--r-- 1 root root 5650 Feb 26 01:05 funsoft.ko
>> -rw-r--r-- 1 root root 32346 Feb 26 01:05 garmin_gps.ko
>> -rw-r--r-- 1 root root 5585 Feb 26 01:05 hp4x.ko
>> -rw-r--r-- 1 root root 82198 Feb 26 01:05 io_edgeport.ko
>>
>>
>> All good and ready for a reboot as was 2.6.38-rc6-git5.
>>
>> After reboot, 2.6.36-rc6-git6
>> ===============================
>> total 3184
>> drwxr-xr-x 34 root root 4096 Feb 26 01:04 ./
>> drwxr-xr-x 52 root root 4096 Feb 26 01:05 ../
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 3c59x.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 8139cp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 8139too.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 8390.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 acenic.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 amd8111e.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 appletalk/
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 atl1c/
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 atl1e/
>> drwxr-xr-x 2 root root 34 Feb 26 01:04 atlx/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 atp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 b44.ko
>> drwxr-xr-x 2 root root 22 Feb 26 01:04 benet/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 bnx2.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 bnx2x/
>> drwxr-xr-x 2 root root 23 Feb 26 01:04 bonding/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 bsd_comp.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 cassini.ko
>> drwxr-xr-x 2 root root 20 Feb 26 01:04 chelsio/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 cnic.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 cxgb3/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 de600.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 de620.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 defxx.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 dl2k.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 dnet.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 dummy.ko
>> drwxr-xr-x 2 root root 21 Feb 26 01:04 e1000/
>> drwxr-xr-x 2 root root 22 Feb 26 01:04 e1000e/
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 e100.ko
>> -rw-r--r-- 1 root root 0 Feb 26 01:04 enc28j60.ko
>>
>>
>> Regards
>> Sid.
>>
>> On 30/11/10 14:59, Sid Boyce wrote:
>>> openSUSE 11.3 on one box and openSUSE 11.4 Milestone 4 on the other.
>>> I have a message that says the built modules not found. When I check e.g
>>> /lib/modules/2.7.37-rc3-git7-smp, most modules are zero bytes long.
>>> I have to "make modules_install" and use modprobe on each.
>>> To get the network up on the 11.3 box "modprobe r6189" then "rcnetwork
>>> restart", "modprobe rtl8187", "/etc/init.d/network-remotefs start",
>>> etc., etc.
>>> Then ifconfig is OK for those devices.
>>> eth_s1_0 Link encap:Ethernet HWaddr 00:1C:F0:BB:14:E1
>>> inet addr:192.168.10.10 Bcast:192.168.10.255 Mask:255.255.255.0
>>> inet6 addr: fe80::21c:f0ff:febb:14e1/64 Scope:Link
>>> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
>>> RX packets:1927 errors:0 dropped:0 overruns:0 frame:0
>>> TX packets:1923 errors:0 dropped:0 overruns:0 carrier:0
>>> collisions:0 txqueuelen:1000
>>> RX bytes:287532 (280.7 Kb) TX bytes:283044 (276.4 Kb)
>>> Interrupt:17 Base address:0xe000
>>> wlan0 Link encap:Ethernet HWaddr 00:15:AF:23:04:37
>>> inet addr:192.168.1.4 Bcast:192.168.1.255 Mask:255.255.255.0
>>> inet6 addr: fe80::215:afff:fe23:437/64 Scope:Link
>>> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
>>> RX packets:25 errors:0 dropped:0 overruns:0 frame:0
>>> TX packets:62 errors:0 dropped:0 overruns:0 carrier:0
>>> collisions:0 txqueuelen:1000
>>> RX bytes:4324 (4.2 Kb) TX bytes:18470 (18.0 Kb)
>>>
>>> On 11.3 module-init-tools-3.12-1.3.x86_64
>>> On 11.4 Milestone 4 module-init-tools-3.12-5.3.x86_64
>>>
>>> tindog:/usr/src/linux-2.6.37-rc3-git7 # grep MODULE .config
>>> CONFIG_MODULES=y
>>> # CONFIG_MODULE_FORCE_LOAD is not set
>>> CONFIG_MODULE_UNLOAD=y
>>> CONFIG_MODULE_FORCE_UNLOAD=y
>>> CONFIG_MODULE_SRCVERSION_ALL=y
>>>
>>>
>>> Another guy has emailed me saying he's seen the same.
>>> 11.3
>>> ====
>>> gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux)
>>> 11.4 Milestone 4
>>> ================
>>> gcc version 4.5.1 20101116 [gcc-4_5-branch revision 166793] (SUSE Linux)
>>> Regards
>>> Sid.
>>
>>
>
>


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

