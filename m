Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2EZTiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 15:38:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41912 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2EZTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 15:38:22 -0400
Message-ID: <1338061161.4284.16.camel@lappy>
Subject: ecryptfs: kernel BUG at fs/ecryptfs/miscdev.c:52
From: Sasha Levin <levinsasha928@gmail.com>
To: tyhicks <tyhicks@canonical.com>,
        "dustin.kirkland" <dustin.kirkland@gazzang.com>
Cc: ecryptfs <ecryptfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 26 May 2012 21:39:21 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During fuzzing with trinity inside a KVM guest, using latest linux-next kernel, I've stumbled on the following:

[  175.995560] ------------[ cut here ]------------
[  175.996026] kernel BUG at fs/ecryptfs/miscdev.c:52!
[  175.996026] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  175.996026] CPU 3 
[  175.996026] Pid: 7903, comm: trinity-child3 Tainted: G        W    3.4.0-next-20120524-sasha #296 Bochs Bochs
[  175.996026] RIP: 0010:[<ffffffff813e945a>]  [<ffffffff813e945a>] ecryptfs_miscdev_poll+0x5a/0x150
[  175.996026] RSP: 0018:ffff88002d4a3aa8  EFLAGS: 00010282
[  175.996026] RAX: 00000000ffffffea RBX: ffff88002d4a3b98 RCX: ffff880019d3c348
[  175.996026] RDX: ffffffff84444140 RSI: 000000000b32e681 RDI: ffff88002d4a3ab0
[  175.996026] RBP: ffff88002d4a3ad8 R08: cbf7d334712ee681 R09: 0200000000000000
[  175.996026] R10: 2000000000000000 R11: 3408000000000000 R12: ffff88003d53c000
[  176.022035] R13: 000000000b32e681 R14: ffff88002d4b059c R15: ffff88003d53c000
165983 iteration[  176.026020] FS:  00007f0abac73700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[  176.026020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
s.
[  176.026020] CR2: 00000000011750d8 CR3: 0000000039722000 CR4: 00000000000407e0
[  176.026020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  176.026020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  176.026020] Process trinity-child3 (pid: 7903, threadinfo ffff88002d4a2000, task ffff88002d503000)
[  176.026020] Stack:
[  176.026020]  ffff88002d4b069c ffff880019d3c348 ffff88002d4b069c ffff88002d4b069c
[  176.026020]  ffff88002d4a3b44 ffff88002d4a3b98 ffff88002d4a3b78 ffffffff8124d9bc
[  176.026020]  ffff88002d503000 ffff88002d503000 01ffffff811f5afe 0000000000000000
[  176.026020] Call Trace:
[  176.026020]  [<ffffffff8124d9bc>] do_poll+0x11c/0x2b0
[  176.026020]  [<ffffffff8124dcbf>] do_sys_poll+0x16f/0x240
[  176.026020]  [<ffffffff8114dfdd>] ? __lock_acquired+0x3d/0x2e0
[  176.026020]  [<ffffffff811fade6>] ? do_wp_page+0x5c6/0x800
[  176.026020]  [<ffffffff811faf73>] ? do_wp_page+0x753/0x800
197143 iteration[  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
s.
[  176.026020]  [<ffffffff83249080>] ? _raw_spin_unlock+0x30/0x60
[  176.026020]  [<ffffffff811fafe8>] ? do_wp_page+0x7c8/0x800
[  176.026020]  [<ffffffff8114dfdd>] ? __lock_acquired+0x3d/0x2e0
[  176.026020]  [<ffffffff8198044d>] ? debug_object_activate+0x6d/0x1b0
[  176.026020]  [<ffffffff81980532>] ? debug_object_activate+0x152/0x1b0
[  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
[  176.026020]  [<ffffffff8114b4cd>] ? trace_hardirqs_off+0xd/0x10
[  176.026020]  [<ffffffff83249144>] ? _raw_spin_unlock_irqrestore+0x94/0xc0
[  176.026020]  [<ffffffff81980532>] ? debug_object_activate+0x152/0x1b0
[  176.026020]  [<ffffffff819611ee>] ? rb_insert_color+0x9e/0x160
[  176.026020]  [<ffffffff8110c488>] ? __hrtimer_start_range_ns+0x448/0x490
[  176.026020]  [<ffffffff8197e060>] ? do_raw_spin_unlock+0xd0/0xe0
[  176.026020]  [<ffffffff8124df6c>] sys_poll+0x6c/0x100
[  176.026020]  [<ffffffff8324a1f9>] system_call_fastpath+0x16/0x1b
[  176.026020] Code: 00 00 44 8b 68 24 e8 66 cc e5 01 48 8d 7d d8 48 c7 c2 40 41 44 84 44 89 ee e8 a3 ef ff ff 85 c0 75 09 48 8b 7d 
d8 48 85 ff 75 0e <0f> 0b 0f 1f 40 00 eb fe 66 0f 1f 44 00 00 48 83 c7 28 31 f6 e8 
[  176.026020] RIP  [<ffffffff813e945a>] ecryptfs_miscdev_poll+0x5a/0x150
[  176.026020]  RSP <ffff88002d4a3aa8>
[  176.028658] ---[ end trace 8f6ca168297608bd ]---

