Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2AROex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:34:53 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:49930 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757704Ab2AROev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:34:51 -0500
thread-index: AczV7kBDq/UWtuefTsWYgcRV3btgcg==
Thread-Topic: [ANNOUNCE] 3.2-rc6-rt9 - bugsplat
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.2-rc6-rt9 - bugsplat
Date: Wed, 18 Jan 2012 15:33:26 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>
References: <alpine.LFD.2.02.1112212310390.3020@ionos>
In-reply-to: <alpine.LFD.2.02.1112212310390.3020@ionos>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201181533.26301.tim.sander@hbm.com>
X-OriginalArrivalTime: 18 Jan 2012 14:34:14.0277 (UTC) FILETIME=[4030BB50:01CCD5EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

I am reporting for 3.2-rt10 (which was not announced, so just replyed to the latest announcement...)

The platform is an arm i.mx35 pcm043 with local modifications.

I just managed to get 3.2-rt10 up and running. It just showed a bugsplat when i tried to reproduce the 
error reported with the 3.0-rt series: "ksoftirq running wild". This segfault occoured probably at the same 
time the ksoftirqd problem started with 3.0-rt.

Best regards
Tim


fpga: try to mmap (normal)
fpga: hbm_mmap_kmem finished
init: avahi-autoip main process (490) terminated with status 1
init: avahi-autoip main process ended, respawning
eth0: Freescale FEC PHY driver [Micrel KS8041] (mii_bus:phy_addr=1:00, irq=-1)
eth0: no IPv6 routers present
FEC: MDIO read timeout
PHY: 1:00 - Link is Up - 100/Full
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7044000
[00000000] *pgd=87b01831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in: canterm(O) iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables msp(O) ipv6 fpga(O) af_packet i2c_imx netx(O) netx_reset(O) 
systemled(O) dspload(O) fpgaload(O) mxc_nand nand nand_ids nand_ecc
CPU: 0    Tainted: G           O  (3.2.0-rt10-00008-ga71a9ff-dirty #194)
PC is at rt_mutex_slowunlock+0x18/0x8c
LR is at walk_stackframe+0x24/0x40
pc : [<c0235cd8>]    lr : [<c0010d0c>]    psr: 60000013
sp : c7383d90  ip : c7383d30  fp : c7383da4
r10: ffffffff  r9 : 00000000  r8 : c0324504
r7 : c734178c  r6 : 00000003  r5 : 00000000  r4 : c73416e0
r3 : 00000000  r2 : c7383d90  r1 : c7383d60  r0 : c0019234
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87044008  DAC: 00000015
Process ifconfig (pid: 597, stack limit = 0xc7382268)
Stack: (0xc7383d90 to 0xc7384000)
3d80:                                     c73416e0 40000013 c7383db4 c7383da8
3da0: c0235d5c c0235ccc c7383ddc c7383db8 c00566cc c0235d58 00000003 c7068800
3dc0: 00000000 c7068b14 c78ca000 00000002 c7383dec c7383de0 c0056728 c005659c
3de0: c7383e1c c7383df0 bf043558 c00566f0 bf0433fc 00000002 00000000 fffffff9
3e00: bf085b94 c78ca000 c7383ed0 00000000 c7383e44 c7383e20 c003f11c bf043408
3e20: ffffffff c78ca000 00000002 00000000 c78da560 c7b5c468 c7383e5c c7383e48
3e40: c003f1b8 c003f0e8 00000000 c7383e58 c7383e74 c7383e60 c01c27f8 c003f1a4
3e60: c78ca000 00000001 c7383e8c c7383e78 c01c4cc8 c01c27c0 c78ca000 00001003
3e80: c7383eac c7383e90 c01c4d3c c01c4ca0 00000000 c7b4b860 00000000 c78ca000
3ea0: c7383f1c c7383eb0 c020d914 c01c4d04 c03406a0 bee59f18 00008914 bee59c38
3ec0: 30687465 00000000 00000000 00000000 00061042 bee59f18 0005543c 00000000
3ee0: 00061042 bee59f18 0005543c 00000000 30687465 0000891c bee59c38 00008914
3f00: 00000003 c000dee4 c7382000 00000000 c7383f34 c7383f20 c020ea08 c020d620
3f20: c748f6c0 00008914 c7383f54 c7383f38 c01b0f64 c020e948 c01b0d5c c7bfe560
3f40: bee59c38 00008914 c7383f7c c7383f58 c0090ea4 c01b0d68 c7383f74 c7383f68
3f60: c7bfe560 bee59c38 00008914 00000003 c7383fa4 c7383f80 c0090f20 c0090c28
3f80: c7383fac 00000000 0005ad94 bee59e3c bee59f26 00000036 00000000 c7383fa8
3fa0: c000dd60 c0090eec 0005ad94 bee59e3c 00000003 00008914 bee59c38 0005ad94
3fc0: 0005ad94 bee59e3c bee59f26 00000036 00055c74 00000000 00000000 00000000
3fe0: 000000f5 bee59c18 0000f224 401ad32c 60000010 00000003 980c8108 542a4c44
Backtrace: 
[<c0235cc0>] (rt_mutex_slowunlock+0x0/0x8c) from [<c0235d5c>] (rt_mutex_unlock+0x10/0x14)
 r5:40000013 r4:c73416e0
[<c0235d4c>] (rt_mutex_unlock+0x0/0x14) from [<c00566cc>] (rcu_read_unlock_special+0x13c/0x154)
[<c0056590>] (rcu_read_unlock_special+0x0/0x154) from [<c0056728>] (__rcu_read_unlock+0x44/0x48)
 r8:00000002 r7:c78ca000 r6:c7068b14 r5:00000000 r4:c7068800
r3:00000003
[<c00566e4>] (__rcu_read_unlock+0x0/0x48) from [<bf043558>] (packet_notifier+0x15c/0x168 [af_packet])
[<bf0433fc>] (packet_notifier+0x0/0x168 [af_packet]) from [<c003f11c>] (notifier_call_chain+0x40/0x70)
[<c003f0dc>] (notifier_call_chain+0x0/0x70) from [<c003f1b8>] (raw_notifier_call_chain+0x20/0x28)
 r8:c7b5c468 r7:c78da560 r6:00000000 r5:00000002 r4:c78ca000
r3:ffffffff
[<c003f198>] (raw_notifier_call_chain+0x0/0x28) from [<c01c27f8>] (call_netdevice_notifiers+0x44/0x58)
[<c01c27b4>] (call_netdevice_notifiers+0x0/0x58) from [<c01c4cc8>] (__dev_notify_flags+0x34/0x64)
 r5:00000001 r4:c78ca000
[<c01c4c94>] (__dev_notify_flags+0x0/0x64) from [<c01c4d3c>] (dev_change_flags+0x44/0x4c)
 r5:00001003 r4:c78ca000
[<c01c4cf8>] (dev_change_flags+0x0/0x4c) from [<c020d914>] (devinet_ioctl+0x300/0x690)
 r6:c78ca000 r5:00000000 r4:c7b4b860 r3:00000000
[<c020d614>] (devinet_ioctl+0x0/0x690) from [<c020ea08>] (inet_ioctl+0xcc/0x104)
[<c020e93c>] (inet_ioctl+0x0/0x104) from [<c01b0f64>] (sock_ioctl+0x208/0x25c)
 r4:00008914 r3:c748f6c0
[<c01b0d5c>] (sock_ioctl+0x0/0x25c) from [<c0090ea4>] (do_vfs_ioctl+0x288/0x2c4)
 r6:00008914 r5:bee59c38 r4:c7bfe560 r3:c01b0d5c
[<c0090c1c>] (do_vfs_ioctl+0x0/0x2c4) from [<c0090f20>] (sys_ioctl+0x40/0x64)
 r7:00000003 r6:00008914 r5:bee59c38 r4:c7bfe560
[<c0090ee0>] (sys_ioctl+0x0/0x64) from [<c000dd60>] (ret_fast_syscall+0x0/0x30)
 r7:00000036 r6:bee59f26 r5:bee59e3c r4:0005ad94
Code: e24cb004 e1a05000 e3a00001 ebf78d20 (e5953000) 
Segmentation fault

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
