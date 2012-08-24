Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2HXNNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:13:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33429 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2HXNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:13:06 -0400
Message-ID: <50377DDD.7060404@acm.org>
Date: Fri, 24 Aug 2012 13:13:01 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Kernel hangs in truncate_inode_pages()
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If I log in with the open-iscsi initiator to an iSCSI target an power
down the target the initiator hangs in truncate_inode_pages(). This
happens systematically with kernel 3.6-rc3 and it's something I've
never seen with kernel 3.4 or before. Has anyone else already run into
this issue ?

>From the output of echo w >/proc/sysrq-trigger:

SysRq : Show Blocked State
 task                        PC stack   pid father
udisks-part-id  D ffffffff810f7530     0 30803  10057 0x00000006
ffff8801063c39a8 0000000000000046 ffff880126955d60 0000000000000002
ffff8801063c3fd8 ffff880126955d60 ffff8801063c3fd8 ffff8801063c3fd8
ffffffff81813420 ffff880126955d60 ffff8801063c39a8 ffff88012fa13990
Call Trace:
[<ffffffff810f7530>] ? __lock_page+0x70/0x70
[<ffffffff8140c4e9>] schedule+0x29/0x70
[<ffffffff8140c5bf>] io_schedule+0x8f/0xd0
[<ffffffff810f753e>] sleep_on_page+0xe/0x20
[<ffffffff8140a0fa>] __wait_on_bit_lock+0x5a/0xc0
[<ffffffff810fa45a>] ? find_get_pages+0x2a/0x1c0
[<ffffffff81104f7f>] ? release_pages+0x1af/0x200
[<ffffffff810f7527>] __lock_page+0x67/0x70
[<ffffffff810615a0>] ? autoremove_wake_function+0x40/0x40
[<ffffffff81106976>] truncate_inode_pages_range+0x456/0x480
[<ffffffff8109590d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff8109be5a>] ? on_each_cpu_cond+0xaa/0xf0
[<ffffffff81106a25>] truncate_inode_pages+0x15/0x20
[<ffffffff8118389f>] kill_bdev+0x2f/0x40
[<ffffffff81184096>] __blkdev_put+0x76/0x1d0
[<ffffffff8118424d>] blkdev_put+0x5d/0x180
[<ffffffff81184395>] blkdev_close+0x25/0x30
[<ffffffff8114c43c>] __fput+0xcc/0x240
[<ffffffff8114c5be>] ____fput+0xe/0x10
[<ffffffff8105d419>] task_work_run+0x69/0xa0
[<ffffffff8104165f>] do_exit+0x78f/0x930
[<ffffffff810514f0>] ? get_signal_to_deliver+0xf0/0x6f0
[<ffffffff8140d1e7>] ? _raw_spin_lock_irq+0x17/0x60
[<ffffffff8140d930>] ? _raw_spin_unlock_irq+0x30/0x50
[<ffffffff81041b5e>] do_group_exit+0x4e/0xc0
[<ffffffff81051628>] get_signal_to_deliver+0x228/0x6f0
[<ffffffff8100223c>] do_signal+0x3c/0x620
[<ffffffff81415dcc>] ? sysret_signal+0x5/0x3d
[<ffffffff810028ad>] do_notify_resume+0x6d/0xb0
[<ffffffff8120846e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff81415fd8>] int_signal+0x12/0x17

Bart.
