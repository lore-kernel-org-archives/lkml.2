Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab2EWCns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:43:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55535 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab2EWCnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:43:46 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 10:43:45 +0800
Message-ID: <CABawtvMgrsAQaQy7RO5XFbj7qu8+4WHqaZbbNQOeEwhMs58Oyw@mail.gmail.com>
Subject: Huge memory takes too long time to initialize on 4TB ?
From: ethan zhao <ethan.kernel@gmail.com>
To: aarcange@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, aarcange

   When I boot kernel 2.6.39-100.6.1.el6uek.x86_64(actually 3.0.26)on
a 4TB memory machine, got following call trace,
That shows huge memory take too long time to initialize ? any help ?,
I compared the huge_memory.c code between 3.0.26 and the current
3.2.x, no change.

Pid: 1, comm: swapper Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff814fb2d9>]  [<ffffffff814fb2d9>]
_raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff887d8efbfe18  EFLAGS: 00000282
RAX: 0000000018080200 RBX: 0000000000000006 RCX: 0140000000000400
RDX: ffffea0541bfe8d0 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff887d8efbfe20 R08: 0000000000000004 R09: 0000000000000000
R10: ffff89807ffcbfe8 R11: 0000000000000300 R12: ffffffff81503f4e
R13: 0000000000000000 R14: 0000000000000082 R15: ffff887d8efbfe00
FS:  0000000000000000(0000) GS:ffff8a807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff887d8efbe000, task ffff887d8efbc040)
Stack:
 ffff89807ffece00 ffff887d8efbfe60 ffffffff811105d1 0000000000000000
 000000000000000a 0000000000000000 ffffffff818ea81d 0000000000000000
 0000000000000000 ffff887d8efbfe80 ffffffff81157f2a 0000000000000000
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff818ea81d>] ? kmem_cache_init_late+0x87/0x87
 [<ffffffff81157f2a>] set_recommended_min_free_kbytes+0x8a/0xa0
 [<ffffffff818ea935>] hugepage_init+0x118/0x12d
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 66 90 e8 bb 2b b4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89
e5 53 66 66 66 66 90 48 89 f3 e8 ee 2b b4 ff 66 90 48 89 df 57 9d
 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff818ea81d>] ? kmem_cache_init_late+0x87/0x87
 [<ffffffff81157f2a>] set_recommended_min_free_kbytes+0x8a/0xa0
 [<ffffffff818ea935>] hugepage_init+0x118/0x12d
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
