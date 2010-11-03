Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0KCByc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:54:32 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:51692 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752798Ab0KCBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:54:30 -0400
Date: Wed, 3 Nov 2010 12:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: [oops, 2.6.37-rc1] Unpacking initramfs failed, oops in
 free_init_pages()
Message-ID: <20101103015427.GA31163@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Not sure yet if the initramfs image is corrupt or not yet, but it
triggered this crash on startup:

....
[    2.835987] Unpacking initramfs...
[    2.839374] Initramfs unpacking failed: junk in compressed archive
[    2.845846] Freeing initrd memory: 44108k freed
[    2.850364] BUG: unable to handle kernel paging request at ffff8800014ed000
[    2.857314] IP: [<ffffffff8102d33e>] free_init_pages+0xd2/0xf8
[    2.863138] PGD 1604063 PUD 1608063 PMD 332945063 PTE 14ed161
[    2.868896] Oops: 0003 [#1] SMP 
[    2.872123] last sysfs file: 
[    2.875077] CPU 0 
[    2.876904] Modules linked in:
[    2.880132] 
[    2.881615] Pid: 1, comm: swapper Not tainted 2.6.37-rc1+ #114 0W844P/PowerEdge R510
[    2.889325] RIP: 0010:[<ffffffff8102d33e>]  [<ffffffff8102d33e>] free_init_pages+0xd2/0xf8
[    2.897565] RSP: 0018:ffff880333441eb0  EFLAGS: 00010246
[    2.902853] RAX: 00000000cccccccc RBX: ffff880004000000 RCX: 0000000000000400
[    2.909957] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800014ed000
[    2.917063] RBP: ffff8800014ed000 R08: 0000000000000002 R09: 0000000000000005
[    2.924168] R10: 0000000000000000 R11: 0000003434313038 R12: 0000000000000400
[    2.931273] R13: ffffea0000000000 R14: 00000000cccccccc R15: 0000000000000000
[    2.938378] FS:  0000000000000000(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
[    2.946436] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.952157] CR2: ffff8800014ed000 CR3: 0000000001603000 CR4: 00000000000006f0
[    2.959264] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.966368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.973473] Process swapper (pid: 1, threadinfo ffff880333440000, task ffff880633060000)
[    2.981529] Stack:
[    2.983529]  ffff880000000000 ffffffff8169213d 0000000000000000 0000000000000200
[    2.990928]  0000000000000000 ffffffff81692220 ffffffff81705b50 ffffffff81002079
[    2.998327]  000000000000000f ffffffff81705b50 ffffffff81674180 0000000000000200
[    3.005730] Call Trace:
[    3.008167]  [<ffffffff8169213d>] ? populate_rootfs+0x0/0xfd
[    3.013803]  [<ffffffff81692220>] ? populate_rootfs+0xe3/0xfd
[    3.019524]  [<ffffffff81002079>] ? do_one_initcall+0x78/0x131
[    3.025333]  [<ffffffff816906dc>] ? kernel_init+0x162/0x1ec
[    3.030883]  [<ffffffff8100a8a4>] ? kernel_thread_helper+0x4/0x10
[    3.036950]  [<ffffffff8169057a>] ? kernel_init+0x0/0x1ec
[    3.042325]  [<ffffffff8100a8a0>] ? kernel_thread_helper+0x0/0x10
[    3.048391] Code: 01 e8 f0 80 60 01 fb 48 89 ef e8 d2 41 00 00 48 c1 e8 0c 48 89 ef 4c 89 e1 48 6b c0 38 31 f6 42 c7 44 28 08 01 00 00 00 44 89 f0 <f3> ab 48 89 ef 
[    3.067787] RIP  [<ffffffff8102d33e>] free_init_pages+0xd2/0xf8
[    3.073691]  RSP <ffff880333441eb0>
[    3.077162] CR2: ffff8800014ed000
[    3.080465] ---[ end trace 52609fe2a2756609 ]---
[    3.085076] Kernel panic - not syncing: Attempted to kill init

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
