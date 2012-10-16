Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2JPJdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:33:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48354 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2JPJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:33:19 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 11:33:18 +0200
Message-ID: <CADpTngUeZhngwTgHSKhZi0wntTVGDdkNzPrD9UBGM_s8bnoQZA@mail.gmail.com>
Subject: fs/inode.c WARNING still present in 3.6.2
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm still seeing WARNING in dmesg of 3.6.2 version (and it seems
related to high load on servers), as reported for 3.6.1. is it
something dangerous?
If details are needed, please CC: as I'm not subscribed to this
mailing list now .

Many thanks for any answer :)

[64356.668774] ------------[ cut here ]------------
[64356.668811] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
[64356.668842] Hardware name: ProLiant BL465c G6
[64356.668871] Pid: 30987, comm: php Tainted: G        W    3.6.2-hll-2scsi #1
[64356.668904] Call Trace:
[64356.668932]  [<ffffffff81057884>] ? warn_slowpath_common+0x73/0x87
[64356.668965]  [<ffffffff810ec738>] ? drop_nlink+0x1b/0x35
[64356.668996]  [<ffffffff8118ae8d>] ? nfs_dentry_iput+0x33/0x49
[64356.669028]  [<ffffffff810eaa30>] ? d_kill+0xe8/0x108
[64356.669058]  [<ffffffff810eb111>] ? dput+0x147/0x154
[64356.669088]  [<ffffffff810d9f56>] ? __fput+0x19a/0x1b2
[64356.669119]  [<ffffffff8106be48>] ? task_work_run+0x4c/0x60
[64356.669151]  [<ffffffff81606da8>] ? int_signal+0x12/0x17
[64356.669181] ---[ end trace e416cf64a1ef779c ]---

[  247.332506] ------------[ cut here ]------------
[  247.332610] WARNING: at fs/ext3/inode.c:1754
ext3_journalled_writepage+0x55/0x1a7()
[  247.332735] Hardware name: ProLiant BL465c G7
[  247.332825] Pid: 2255, comm: flush-8:0 Not tainted 3.6.2-hll-2scsi #1
[  247.332921] Call Trace:
[  247.333008]  [<ffffffff81057884>] ? warn_slowpath_common+0x73/0x87
[  247.333105]  [<ffffffff8115ccc2>] ? ext3_journalled_writepage+0x55/0x1a7
[  247.333205]  [<ffffffff810a2833>] ? __writepage+0xa/0x21
[  247.333297]  [<ffffffff810a31db>] ? write_cache_pages+0x206/0x2f8
[  247.333392]  [<ffffffff810a2829>] ? set_page_dirty+0x5e/0x5e
[  247.333487]  [<ffffffff810a330b>] ? generic_writepages+0x3e/0x55
[  247.333583]  [<ffffffff810f4eb0>] ? __writeback_single_inode+0x39/0xd1
[  247.333679]  [<ffffffff810f5c69>] ? writeback_sb_inodes+0x206/0x392
[  247.333775]  [<ffffffff810f5e5c>] ? __writeback_inodes_wb+0x67/0xa2
[  247.333870]  [<ffffffff810f5ffa>] ? wb_writeback+0xfd/0x18b
[  247.333963]  [<ffffffff810a36d1>] ? bdi_dirty_limit+0x27/0x81
[  247.334057]  [<ffffffff810f61c5>] ? wb_do_writeback+0x13d/0x1a2
[  247.334153]  [<ffffffff81061e9b>] ? add_timer_on+0x61/0x61
[  247.334246]  [<ffffffff810f62a9>] ? bdi_writeback_thread+0x7f/0x13e
[  247.334342]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  247.334436]  [<ffffffff810f622a>] ? wb_do_writeback+0x1a2/0x1a2
[  247.334532]  [<ffffffff8106e134>] ? kthread+0x81/0x89
[  247.334626]  [<ffffffff810d0000>] ? __slab_alloc+0x206/0x371
[  247.334722]  [<ffffffff81607b74>] ? kernel_thread_helper+0x4/0x10
[  247.334817]  [<ffffffff8106e0b3>] ? kthread_worker_fn+0xe0/0xe0
[  247.334911]  [<ffffffff81607b70>] ? gs_change+0xb/0xb
[  247.335002] ---[ end trace b659ad32aabdb2cd ]---

-- 
Fabio
