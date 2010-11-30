Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0K3IOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:14:48 -0500
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:37930 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab0K3IOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:14:47 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 03:14:46 EST
Message-ID: <4CF4AF6F.4080808@univ-nantes.fr>
Date: Tue, 30 Nov 2010 09:01:51 +0100
From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Reply-To: jean-philippe.menil@univ-nantes.fr
Organization: IRTS - DSI - =?ISO-8859-1?Q?Universit=E9_de_Nantes?=
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Kernel bug (2.6.36) with vhost_net
Content-Type: multipart/mixed;
 boundary="------------020702050303020804090400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020702050303020804090400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

recently, i was testing the vhost_net module.

Already was fine during several hours, until a kernel bug?
The kernel is a 2.6.36, qemu-kvm was compiled against the last git 
version (0.13.50) with the --enable-vhost-net option.

root@ayrshire:~# /usr/bin/qemu-system-x86_64 --version
QEMU emulator version 0.13.50 (qemu-kvm-devel), Copyright (c) 2003-2008 
Fabrice Bellard
root@ayrshire:~# uname -a
Linux ayrshire 2.6.36-dsiun-1b #2 SMP Tue Oct 26 17:52:00 CEST 2010 
x86_64 GNU/Linux

On the host, i've just cherged the module (modprobe vhost_net)and 
restart libvirt.

root@ayrshire:~# modinfo vhost_net
filename: 
/lib/modules/2.6.36-dsiun-1b/kernel/drivers/vhost/vhost_net.ko
description:    Host kernel accelerator for virtio net
author:         Michael S. Tsirkin
license:        GPL v2
version:        0.0.1
srcversion:     04194AACE1868FBD0CFFA6B
depends:        tun,macvtap
vermagic:       2.6.36-dsiun-1b SMP mod_unload modversions

The guest is starting with libvirt, here is the command passed to qemu:

-S -M pc-0.13 -enable-kvm -m 4096 -smp 3,sockets=1,cores=1,threads=1 
-name 2-portailCROUS-2 -uuid 3f79b053-3583-36d0-0f26-a4ad6afa818e 
-nodefconfig -nodefaults -chardev 
socket,id=monitor,path=/var/lib/libvirt/qemu/2-portailCROUS-2.monitor,server,nowait 
-mon chardev=monitor,mode=readline -rtc base=utc -boot c -drive 
file=/dev/mapper/LocalDisk-portailCROUS--2,if=none,id=drive-virtio-disk0,boot=on,format=raw 
-device 
virtio-blk-pci,bus=pci.0,addr=0x10,drive=drive-virtio-disk0,id=virtio-disk0 
-netdev tap,fd=17,id=hostnet0,vhost=on,vhostfd=18 -device 
virtio-net-pci,netdev=hostnet0,id=net0,mac=de:ad:be:ed:02:01,bus=pci.0,addr=0x3 
-netdev tap,fd=19,id=hostnet1,vhost=on,vhostfd=20 -device 
virtio-net-pci,netdev=hostnet1,id=net1,mac=de:ad:be:ed:02:02,bus=pci.0,addr=0x4 
-netdev tap,fd=21,id=hostnet2,vhost=on,vhostfd=22 -device 
virtio-net-pci,netdev=hostnet2,id=net2,mac=de:ad:be:ed:02:03,bus=pci.0,addr=0x5 
-netdev tap,fd=23,id=hostnet3,vhost=on,vhostfd=24 -device 
virtio-net-pci,netdev=hostnet3,id=net3,mac=de:ad:be:ed:02:04,bus=pci.0,addr=0x6 
-netdev tap,fd=25,id=hostnet4,vhost=on,vhostfd=26 -device 
virtio-net-pci,netdev=hostnet4,id=net4,mac=de:ad:be:ed:02:06,bus=pci.0,addr=0x7 
-netdev tap,fd=27,id=hostnet5,vhost=on,vhostfd=28 -device 
virtio-net-pci,netdev=hostnet5,id=net5,mac=de:ad:be:ed:02:07,bus=pci.0,addr=0x8 
-netdev tap,fd=29,id=hostnet6,vhost=on,vhostfd=30 -device 
virtio-net-pci,netdev=hostnet6,id=net6,mac=de:ad:be:ed:02:08,bus=pci.0,addr=0x9 
-netdev tap,fd=31,id=hostnet7,vhost=on,vhostfd=32 -device 
virtio-net-pci,netdev=hostnet7,id=net7,mac=de:ad:be:ed:02:09,bus=pci.0,addr=0xa 
-netdev tap,fd=33,id=hostnet8,vhost=on,vhostfd=34 -device 
virtio-net-pci,netdev=hostnet8,id=net8,mac=de:ad:be:ed:02:0a,bus=pci.0,addr=0xb 
-netdev tap,fd=35,id=hostnet9,vhost=on,vhostfd=36 -device 
virtio-net-pci,netdev=hostnet9,id=net9,mac=de:ad:be:ed:02:0b,bus=pci.0,addr=0xc 
-netdev tap,fd=37,id=hostnet10,vhost=on,vhostfd=38 -device 
virtio-net-pci,netdev=hostnet10,id=net10,mac=de:ad:be:ed:02:0c,bus=pci.0,addr=0xd 
-netdev tap,fd=39,id=hostnet11,vhost=on,vhostfd=40 -device 
virtio-net-pci,netdev=hostnet11,id=net11,mac=de:ad:be:ed:02:0d,bus=pci.0,addr=0xe 
-netdev tap,fd=41,id=hostnet12,vhost=on,vhostfd=42 -device 
virtio-net-pci,netdev=hostnet12,id=net12,mac=de:ad:be:ed:02:0e,bus=pci.0,addr=0xf 
-usb -vnc 0.0.0.0:2 -vga cirrus -device 
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x11

portail2:~# uname -a
Linux portail2 2.6.36-trunk-amd64 #1 SMP Wed Oct 27 14:28:29 UTC 2010 
x86_64 GNU/Linux

Following, is the trace from the host:

Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717374] 
BUG: unable to handle kernel NULL pointer dereference at 0000000000000128
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717421] 
IP: [<ffffffffa03b340a>] kvm_set_irq+0x51/0xdc [kvm]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717458] 
PGD 7f3d0b067 PUD 846a9d067 PMD 0
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717485] 
Oops: 0000 [#1] SMP
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717509] 
last sysfs file: /sys/devices/system/cpu/cpu11/cache/index2/shared_cpu_map
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717553] 
CPU 0
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717555] 
Modules linked in: vhost_net macvtap macvlan veth crc32c libcrc32c tun 
fuse xt_physdev ip6t_LOG ip6table_filter ip6_tables ipt_LOG xt_multiport 
xt_limit xt_tcpudp xt_state iptable_filter ip_tables x_tables 
nf_conntrack_tftp nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 
8021q bridge stp ext2 mbcache dm_round_robin dm_multipath 
nf_conntrack_ipv6 nf_conntrack kvm_amd kvm ipv6 snd_pcm snd_timer snd 
soundcore snd_page_alloc psmouse tpm_tis serio_raw pcspkr button shpchp 
i2c_nforce2 tpm ghes i2c_core pci_hotplug hed tpm_bios processor joydev 
evdev dcdbas xfs exportfs dm_mod sr_mod cdrom usbhid hid usb_storage ses 
sd_mod enclosure ohci_hcd megaraid_sas lpfc scsi_transport_fc scsi_tgt 
scsi_mod bnx2 thermal thermal_sys ehci_hcd [last unloaded: vhost_net]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717915]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717936] 
Pid: 10203, comm: kworker/0:0 Not tainted 2.6.36-dsiun-1b #2 
0K543T/PowerEdge M605
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.717981] 
RIP: 0010:[<ffffffffa03b340a>]  [<ffffffffa03b340a>] 
kvm_set_irq+0x51/0xdc [kvm]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718029] 
RSP: 0018:ffff8808235ddd30  EFLAGS: 00010246
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718054] 
RAX: 0000000000000000 RBX: ffff88046db2c7e0 RCX: 0000000000000001
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718095] 
RDX: 0000000000000036 RSI: 0000000000000000 RDI: ffff88046db2c300
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718137] 
RBP: 0000000000000036 R08: ffff8808235dc000 R09: ffff880427a4a078
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718178] 
R10: 0000000000000001 R11: ffff88086d5342e0 R12: ffff88046db2c300
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718219] 
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718263] 
FS:  00007f8926718710(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718306] 
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718331] 
CR2: 0000000000000128 CR3: 000000065b376000 CR4: 00000000000006f0
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718373] 
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.718414] 
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
Process kworker/0:0 (pid: 10203, threadinfo ffff8808235dc000, task 
ffff88086c96bc30)
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
Stack:
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
ffff880001812a40 ffffffff81001542 ffffffff8100917d ffff88086c96bc30
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
<0> ffff88086c96bc30 0000000000812a40 0000000000000000 ffff88086d5342e0
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
<0> ffff88086d181180 ffffffff810394df ffff880001812a40 ffff88086c96bc30
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
Call Trace:
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81001542>] ? __switch_to+0xc5/0x287
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff8100917d>] ? sched_clock+0x5/0x8
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff810394df>] ? finish_task_switch+0x34/0xab
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff812c9f4e>] ? common_interrupt+0xe/0x13
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffffa03b3f77>] ? irqfd_inject+0x0/0x31 [kvm]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffffa03b3f96>] ? irqfd_inject+0x1f/0x31 [kvm]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff810554e1>] ? process_one_work+0x250/0x3ce
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81055a02>] ? worker_thread+0x1cf/0x345
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81055833>] ? worker_thread+0x0/0x345
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81055833>] ? worker_thread+0x0/0x345
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff810585c2>] ? kthread+0x7a/0x82
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81003824>] ? kernel_thread_helper+0x4/0x10
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81058548>] ? kthread+0x0/0x82
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
[<ffffffff81003820>] ? kernel_thread_helper+0x0/0x10
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
Code: 8b 1d fb 91 02 00 48 85 db 74 18 48 8b 7b 08 44 89 f9 44 89 ea 89 
ee ff 13 48 83 c3 10 48 83 3b 00 eb e6 49 8b 84 24 30 24 00 00 <3b> a8 
28 01 00 00 72 0a 31 db 83 cd ff 49 89 e6 eb 61 89 ed 48
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
RIP  [<ffffffffa03b340a>] kvm_set_irq+0x51/0xdc [kvm]
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
RSP <ffff8808235ddd30>
Nov 29 19:14:09 ayrshire.u06.univ-nantes.prive kernel: [807437.720003] 
CR2: 0000000000000128

Is this a known issue?
Can someone advise me, on how to solve this issue?

Regards.

--------------020702050303020804090400
Content-Type: text/x-vcard; charset=utf-8;
 name="jean-philippe_menil.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jean-philippe_menil.vcf"

begin:vcard
fn:Jean-Philippe Menil
n:Menil;Jean-Philippe
org;quoted-printable:Universit=C3=A9 de Nantes;IRTS - DSI
adr;quoted-printable:;;2, rue de la Houssini=C3=A8re;Nantes;Loire-Atlantique;44332;France
email;internet:jean-philippe.menil@univ-nantes.fr
title;quoted-printable:Administrateur R=C3=A9seau
tel;work:02.53.48.49.27
tel;fax:02.51.12.58.60
url:http://www.criun.univ-nantes.fr/
version:2.1
end:vcard


--------------020702050303020804090400--
