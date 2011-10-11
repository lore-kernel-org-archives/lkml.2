Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1JKHry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:47:54 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:48224 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1JKHrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:47:53 -0400
X-RZG-AUTH: :OGUIemC4aeq7VQ5CklLnl+lamhSiPJ/bKwJ+V5E0wcy/mIEnnv9YT5uzQcU=
X-RZG-CLASS-ID: mo00
Message-ID: <4E93F49C.3060008@pruetz.net>
Date: Tue, 11 Oct 2011 09:47:40 +0200
From: =?ISO-8859-15?Q?Tilo_Pr=FCtz?= <tilo@pruetz.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111005 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tytso@mit.edu, adilger.kernel@dilger.ca
Subject: Kernel Bug in ext4/inode.c
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.493672, version=1.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am running a server with Gentoo Linux and kernel 2.6.39. This server
also is my DVR using MythTV. Every now and then the server locks up
(actually I have activated reboot on oops to work around the problem).

Sometimes I have a kernel report in the syslog:

------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:2118!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/ppp0/uevent
CPU 0
Modules linked in: ppp_async crc_ccitt nvidia(P) fcpci(P) scsi_wait_scan

Pid: 27841, comm: mythbackend Tainted: P            2.6.39-gentoo-r3
#2 System manufacturer System Product Name/M2N-E
RIP: 0010:[<ffffffff8116f580>]  [<ffffffff8116f580>]
mpage_da_submit_io+0x268/0x3bf
RSP: 0018:ffff88004262bba8  EFLAGS: 00010286
RAX: ffffea000048b650 RBX: ffffea000051d118 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880000826890 RDI: 0000000000005d38
RBP: ffff88004262bcf8 R08: 000000000d654538 R09: 0100000000002820
R10: 0000000000005d0d R11: 0000000000000000 R12: ffff88004262bde8
R13: ffff88004262bd28 R14: ffff88005ef46150 R15: 0000000000005d37
FS:  00007fbeb053f700(0000) GS:ffff88007fc00000(0000)
knlGS:00000000f74aa8e0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fdcb7a36000 CR3: 000000006b721000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mythbackend (pid: 27841, threadinfo ffff88004262a000, task
ffff88007fb83330)
Stack:
 ffff88007b193b88 ffff88004262bc98 ffff88004741c138 000004ac00001424
 ffff88004262bc28 0000000000005d70 ffff88005ef46298 00000000811a337f
 0000000000005d70 000000010000000e ffff88004262bc30 0000100000000000
Call Trace:
 [<ffffffff811731df>] mpage_da_map_and_submit+0x2c6/0x2dc
 [<ffffffff8117390a>] ext4_da_writepages+0x2d4/0x465
 [<ffffffff810aafd6>] do_writepages+0x1c/0x26
 [<ffffffff810a3bc0>] __filemap_fdatawrite_range+0x4b/0x4d
 [<ffffffff810a3bea>] filemap_write_and_wait_range+0x28/0x51
 [<ffffffff810fcba1>] vfs_fsync_range+0x30/0x75
 [<ffffffff810fcc3b>] vfs_fsync+0x17/0x19
 [<ffffffff810fcc66>] do_fsync+0x29/0x3e
 [<ffffffff810fcc89>] sys_fdatasync+0xe/0x12
 [<ffffffff8155f4fb>] system_call_fastpath+0x16/0x1b
Code: c1 00 02 00 00 74 09 f0 80 60 01 fd 4c 89 40 18 4c 8b 08 41 f7
c1 00 10 00 00 75 09 4c 8b 08 41 80 e1 20 74 0a 4c 39 40 18 74 04 <0f>
0b eb fe 41 f6 45 12 80 74 05 f0 80 48 02 80 f0 80 60 01 ef
RIP  [<ffffffff8116f580>] mpage_da_submit_io+0x268/0x3bf
 RSP <ffff88004262bba8>
---[ end trace c228cd85b8ef2f99 ]---


What can I do to avoid such crashes and what can I do to give you more
information (e.g. how to create a kernel dump).


Best regards

Tilo Prütz
