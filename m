Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2DCLHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:07:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2DCLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:07:19 -0400
MIME-Version: 1.0
Date: Tue, 3 Apr 2012 13:07:18 +0200
Message-ID: <CACKLOr3R_aHAqem2a2vjrwCcqq9z4ZRgEya1jXPDr1Shu8gGrg@mail.gmail.com>
Subject: [VFS] Regression, commit 00292bbf769620dea923dbd906afd88955f7ea19
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we are just testing linux-3.4-rc1 with a Visstrim_SM10 board.
Furthermore, we use a squashfs filesystem in NOR as root device and we
have a jffs2 configuration filesystem which is also mounted at
startup.

With the stated approach, which worked properly with older kernel
versions, we get the following messages when booting this kernel:

---
[...]
Synthesizing initial hotplug events
Mounting filesystems
VFS: Busy inodes after unmount of mtd_inodefs. Self-destruct in 5
seconds.  Have a nice day...
VFS: Busy inodes after unmount of mtd_inodefs. Self-destruct in 5
seconds.  Have a nice day...
Loading cfg slot 1
Running depmod
WARNING: Couldn't open directory /lib/modules/3.4.0-rc1: No such file
or directory
Configuring the network.
udhcpc (v1.19.4) started
eth0: Freescale FEC PHY driver [Generic PHY]
(mii_bus:phy_addr=imx27-fec-1:1f, irq=-1)
Sending discover...
PHY: imx27-fec-1:1f - Link is Up - 100/Full
Sending discover...
Sending select for 192.168.0.111...
Lease of 192.168.0.111 obtained, lease time 28800
deleting routers
SIOCDELRT: No such process
adding dns 192.168.0.7
FATAL: Could not load /lib/modules/3.4.0-rc1/modules.dep: No such file
or directory
iptables-restore v1.4.12.2: iptables-restore: unable to initialize table 'raw'

Error occurred at line: 2
Try `iptables-restore -h' or 'iptables-restore --help' for more information.
Starting syslogd and klogd
Unable to handle kernel NULL pointer dereference at virtual address 000000c8
pgd = c3304000
[000000c8] *pgd=a3358831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Not tainted  (3.4.0-rc1 #1)
PC is at jffs2_kill_fragtree+0x1c/0xb4
LR is at jffs2_do_clear_inode+0x68/0x110
pc : [<c01bdf60>]    lr : [<c01c0250>]    psr: 20000013
sp : c32ffea8  ip : c332b664  fp : be929ba4
r10: c25602b8  r9 : c3010e50  r8 : c32ffef0
r7 : 00000000  r6 : 00000000  r5 : c25a77a0  r4 : 000000c0
r3 : 000000c0  r2 : c0514188  r1 : 00000000  r0 : c25a77b0
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: a3304000  DAC: 00000015
Process fw_printenv (pid: 527, stack limit = 0xc32fe270)
Stack: (0xc32ffea8 to 0xc3300000)
fea0:                   00000000 c25a77a0 c3361400 c32fe000 c32ffef0 c01c0250
fec0: c32fe000 c25a77c8 c03af99c c00d62e4 c25a77c8 c25a784c c32ffef0 c00d6a18
fee0: c332b5d8 c25a77c8 c332b664 c00d6fb4 c32ffef0 c32ffef0 c332b600 c332b664
ff00: c03af99c c32d6128 00000000 c00c0eb4 c332b600 c3361400 c32d5540 c025d74c
ff20: c332b600 c01c9d20 c332b600 c05008a4 c32d5540 c00c1280 00000000 c3001cc0
ff40: c32d5540 c0260f3c c32d5548 c32d5540 00000010 c00bfcdc 00000000 00000000
ff60: c32d5540 00000000 c301b8c0 c301b8c0 c32d5540 c32fe000 00000000 c00bc92c
ff80: 00000001 00000003 c32fe000 c00bca04 0000b41c 00000000 000088b8 00000006
ffa0: c00147e8 c0014640 0000b41c 00000000 00000003 00014250 00000000 00000000
ffc0: 0000b41c 00000000 000088b8 00000006 00000000 00000000 b6f16000 be929ba4
ffe0: 00000000 be929b80 0000a6c8 b6e6799c 60000010 00000003 00000000 00000000
[<c01bdf60>] (jffs2_kill_fragtree+0x1c/0xb4) from [<c01c0250>]
(jffs2_do_clear_inode+0x68/0x110)
[<c01c0250>] (jffs2_do_clear_inode+0x68/0x110) from [<c00d62e4>]
(evict+0xa8/0x1b4)
[<c00d62e4>] (evict+0xa8/0x1b4) from [<c00d6a18>] (dispose_list+0x30/0x40)
[<c00d6a18>] (dispose_list+0x30/0x40) from [<c00d6fb4>]
(evict_inodes+0xe8/0x128)
[<c00d6fb4>] (evict_inodes+0xe8/0x128) from [<c00c0eb4>]
(generic_shutdown_super+0x44/0xd8)
[<c00c0eb4>] (generic_shutdown_super+0x44/0xd8) from [<c025d74c>]
(kill_mtd_super+0xc/0x20)
[<c025d74c>] (kill_mtd_super+0xc/0x20) from [<c01c9d20>]
(jffs2_kill_sb+0x28/0x34)
[<c01c9d20>] (jffs2_kill_sb+0x28/0x34) from [<c00c1280>]
(deactivate_locked_super+0x44/0x6c)
[<c00c1280>] (deactivate_locked_super+0x44/0x6c) from [<c0260f3c>]
(mtdchar_close+0x5c/0x68)
[<c0260f3c>] (mtdchar_close+0x5c/0x68) from [<c00bfcdc>] (fput+0xbc/0x250)
[<c00bfcdc>] (fput+0xbc/0x250) from [<c00bc92c>] (filp_close+0x58/0x7c)
[<c00bc92c>] (filp_close+0x58/0x7c) from [<c00bca04>] (sys_close+0xb4/0x10c)
[<c00bca04>] (sys_close+0xb4/0x10c) from [<c0014640>]
(ret_fast_syscall+0x0/0x2c)
Code: e3500000 08bd81f0 e1a04000 e3a07000 (e5943008)
---[ end trace f65774f6ba719f2c ]---
---

We've tried a git bisec and found out that the offending commit is the
following:

commit 00292bbf769620dea923dbd906afd88955f7ea19
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Mar 23 13:47:52 2012 -0400

    mtdchar: kill persistently held vfsmount

    ... and mtdchar_notifier along with it; just have ->drop_inode() that
    will unconditionally get evict them instead of dances on mtd device
    removal and use simple_pin_fs() instead of kern_mount()

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


If we revert this commit the previously stated problems disappear.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
