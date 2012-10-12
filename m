Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab2JLM6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:58:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48074 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab2JLM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:57:56 -0400
MIME-Version: 1.0
Date: Fri, 12 Oct 2012 14:57:55 +0200
Message-ID: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
Subject: ext3 issue on 3.6.1
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm getting this message on a hp g7 server with kernel 3.6.1:

[  248.026545] ------------[ cut here ]------------
[  248.026723] WARNING: at fs/ext3/inode.c:1754
ext3_journalled_writepage+0x55/0x1a7()
[  248.026920] Hardware name: ProLiant BL465c G7
[  248.027049] Pid: 2266, comm: flush-8:0 Not tainted 3.6.1-1000hz-preempt #2
[  248.027199] Call Trace:
[  248.027340]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
[  248.027482]  [<ffffffff8115cb86>] ? ext3_journalled_writepage+0x55/0x1a7
[  248.027653]  [<ffffffff810a279b>] ? __writepage+0xa/0x21
[  248.027787]  [<ffffffff810a3143>] ? write_cache_pages+0x206/0x2f8
[  248.027935]  [<ffffffff810a2791>] ? set_page_dirty+0x5e/0x5e
[  248.028053]  [<ffffffff81297933>] ? queue_unplugged+0x28/0x34
[  248.028188]  [<ffffffff810a3273>] ? generic_writepages+0x3e/0x55
[  248.028294]  [<ffffffff810f4da0>] ? __writeback_single_inode+0x39/0xd1
[  248.028416]  [<ffffffff810f5b59>] ? writeback_sb_inodes+0x206/0x392
[  248.028551]  [<ffffffff810f5d4c>] ? __writeback_inodes_wb+0x67/0xa2
[  248.028675]  [<ffffffff810f5eea>] ? wb_writeback+0xfd/0x18b
[  248.028794]  [<ffffffff810a3639>] ? bdi_dirty_limit+0x27/0x81
[  248.028908]  [<ffffffff810f60b5>] ? wb_do_writeback+0x13d/0x1a2
[  248.029031]  [<ffffffff81061edb>] ? add_timer_on+0x61/0x61
[  248.029142]  [<ffffffff810f6199>] ? bdi_writeback_thread+0x7f/0x13e
[  248.029306]  [<ffffffff810f611a>] ? wb_do_writeback+0x1a2/0x1a2
[  248.029401]  [<ffffffff810f611a>] ? wb_do_writeback+0x1a2/0x1a2
[  248.029498]  [<ffffffff8106e0dc>] ? kthread+0x81/0x89
[  248.029592]  [<ffffffff816003b4>] ? kernel_thread_helper+0x4/0x10
[  248.029687]  [<ffffffff8106e05b>] ? kthread_worker_fn+0xe0/0xe0
[  248.029781]  [<ffffffff816003b0>] ? gs_change+0xb/0xb
[  248.029872] ---[ end trace e60232a455c8e2dc ]---

[13031.051521] ------------[ cut here ]------------
[13031.051576] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
[13031.051624] Hardware name: ProLiant BL465c G7
[13031.051668] Pid: 3344, comm: php Tainted: G        W
3.6.1-1000hz-preempt #2
[13031.051746] Call Trace:
[13031.051787]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
[13031.051837]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
[13031.051885]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
[13031.051934]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
[13031.051980]  [<ffffffff810eb001>] ? dput+0x147/0x154
[13031.052027]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
[13031.052073]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
[13031.052123]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
[13031.052169] ---[ end trace e60232a455c8e2dd ]---


[13031.126373] ------------[ cut here ]------------
[13031.126425] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
[13031.126473] Hardware name: ProLiant BL465c G7
[13031.126517] Pid: 3344, comm: php Tainted: G        W
3.6.1-1000hz-preempt #2
[13031.126595] Call Trace:
[13031.126636]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
[13031.126686]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
[13031.126734]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
[13031.126801]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
[13031.126849]  [<ffffffff810eb001>] ? dput+0x147/0x154
[13031.126896]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
[13031.126944]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
[13031.126994]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
[13031.127040] ---[ end trace e60232a455c8e2de ]---

the server has a RAID bus controller: Hewlett-Packard Company Smart
Array G6 controllers (rev 01)
with hpsa driver. I don't know what exactly else could be useful to
dig into this, just let me know; please cc: me because I'm not
subscribed to the list right now.

Thanks.


-- 
Fabio
