Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2BXJoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:44:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BXJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:44:29 -0500
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 15:14:28 +0530
Message-ID: <CADDb1s3hy-=vEWKevmtpbSLiPZ727SEa4P1XeRCb+xVeevzWnw@mail.gmail.com>
Subject: kernel BUG at fs/namei.c:1320!
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have encountered a BUG_ON in VFS

kernel version: 2.6.35.14
Architecture: ARM

Test Case: Tried to remove a file from a corrupted filesystem.

>From the trigger BUG_ON point it points that the inode which
is to be removed - has not matching parent directory from which it is
to be removed.

Even though -it is reasonable - to verify this parent/child behaviour,
but I have a
doubt about the placement of BUG_ON at this place. Because this leads to 'halt'
of complete system - even though it is related to particular filesystem(file).
So, instead of BUG_ON -> WARN_ON could have been used to highlight the issue.

Please share your opinion - also is this really related with the FS
corruption thing or can be
some issue with the dentry caching part?


kernel BUG at fs/namei.c:1320!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = deb5c000
[00000000] *pgd=a577d031, *pte=00000000, *ppte=00000000
...
...
PC is at __bug+0x2c/0x38
LR is at sub_preempt_count+0x4c/0x68
pc : [<c003f4b8>]    lr : [<c038f8ac>]    psr: 60000013
sp : deb39ed0  ip : deb39df0  fp : deb39edc
r10: 00000000  r9 : deb38000  r8 : c003b708
r7 : 00000028  r6 : 00000001  r5 : e401c9d0  r4 : e41a5220
r3 : 00000000  r2 : 40000000  r1 : c04b3ce4  r0 : 00000034
...
...
Backtrace(CPU 1):
[<c003f48c>] (__bug+0x0/0x38) from [<c0142cb0>] (may_delete+0x44/0x134)
[<c0142c6c>] (may_delete+0x0/0x134) from [<c014446c>] (vfs_rmdir+0x24/0xdc)
 r7:00000028 r6:0000000c r5:e401cbb8 r4:e41a5220
[<c0144448>] (vfs_rmdir+0x0/0xdc) from [<c0146068>] (do_rmdir+0xac/0xf8)
 r6:0000000c r5:00000000 r4:e41a5220 r3:e41a5220
[<c0145fbc>] (do_rmdir+0x0/0xf8) from [<c014610c>] (sys_rmdir+0x20/0x24)
 r5:ffffffff r4:00994388
[<c01460ec>] (sys_rmdir+0x0/0x24) from [<c003b4c0>] (ret_fast_syscall+0x0/0x48)
Code: e59f0010 e1a01003 eb0d28f0 e3a03000 (e5833000)


Thanks & Regards,
Amit Sahrawat
