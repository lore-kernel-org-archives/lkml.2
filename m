Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1AUPJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:09:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1AUPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:09:05 -0500
Date: Fri, 21 Jan 2011 16:09:02 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
Message-ID: <20110121150902.GF5302@quack.suse.cz>
References: <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
 <20101031122437.GA6296@quack.suse.cz>
 <20101031224012.GB13207@quack.suse.cz>
 <20101105213324.GA25520@quack.suse.cz>
 <alpine.LNX.2.01.1011052302400.17206@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1101202344170.26671@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1101202344170.26671@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 20-01-11 23:50:36, Jan Engelhardt wrote:
> On Friday 2010-11-05 23:03, Jan Engelhardt wrote:
> >On Friday 2010-11-05 22:33, Jan Kara wrote:
> >>  OK, so at Kernel Summit we agreed to fix the issue as I originally wanted
> >>by patches
> >>http://marc.info/?l=linux-fsdevel&m=128861735213143&w=2
> >>and
> >>http://marc.info/?l=linux-fsdevel&m=128861734813131&w=2
> >>
> >>  I needed one more patch to resolve the issue (attached) which I've just
> >>posted for review and possible inclusion.
> >
> >If you have a branch that has all three and is easy to fetch, I'll
> >get on it right away.
> 
> I tested these now [2.6.37-rc1+yourpatches].
> 
> Within the last 13 days of uptime, the following messages have
> accumulated, however the machine is still alive, so I guess it's
> fine. (I see Andrew merged the patches already, so if it becomes
> a problem again I will notice it within the next kernel releases.)
  Thanks for an update :) I went through the messages bellow and there
are no signs of bdi-writeout causing any problems. Apparently your disk
is rather busy (maybe in combination with suboptiomal IO scheduling
decisions?) since I could attribute all the reports to waiting for an
IO on a buffer to finish.

								Honza

> INFO: task flush-259:0:324 blocked for more than 120
> seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> flush-259:0   D 00000000005a3d38     0   324      2 0x18000000000
> Call Trace: 
>  [00000000005a39c4] do_get_write_access+0x244/0x480
>  [00000000005a3d38] jbd2_journal_get_write_access+0x18/0x40
>  [0000000000591278] __ext4_journal_get_write_access+0x18/0x60
>  [0000000000572a94] ext4_reserve_inode_write+0x54/0xa0
>  [0000000000572afc] ext4_mark_inode_dirty+0x1c/0x1e0
>  [000000000058ba98] ext4_ext_insert_extent+0x718/0x17a0
>  [000000000058f2d4] ext4_ext_map_blocks+0x9f4/0x12c0
>  [00000000005742f4] ext4_map_blocks+0x1b4/0x240
>  [0000000000576864] mpage_da_map_and_submit+0x84/0x420
>  [0000000000576f5c] write_cache_pages_da+0x27c/0x3e0
>  [00000000005772f8] ext4_da_writepages+0x238/0x4a0
>  [00000000004cc7a4] do_writepages+0x24/0x60
>  [0000000000525264] writeback_single_inode+0x84/0x240
>  [00000000005258d8] writeback_sb_inodes+0x98/0x140
>  [0000000000525f44] writeback_inodes_wb+0xc4/0x180
>  [0000000000526294] wb_writeback+0x294/0x300
> INFO: task jbd2/sda2-8:327 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> jbd2/sda2-8   D 000000000052ce28     0   327      2 0x58000000000
> Call Trace: 
>  [00000000007880d4] io_schedule+0x54/0xc0
>  [000000000052ce28] sync_buffer+0x48/0x60
>  [000000000078895c] __wait_on_bit+0x7c/0xe0
>  [0000000000788a04] out_of_line_wait_on_bit+0x44/0x60
>  [00000000005a4e10] jbd2_journal_commit_transaction+0x850/0x1280
>  [00000000005a87bc] kjournald2+0x9c/0x1c0
>  [0000000000482b84] kthread+0x64/0x80
>  [000000000042b790] kernel_thread+0x30/0x60
>  [0000000000482e84] kthreadd+0xe4/0x160
> INFO: task lighttpd:3260 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> lighttpd      D 000000000052ce28     0  3260      1 0x410051101000080
> Call Trace: 
>  [00000000007880d4] io_schedule+0x54/0xc0
>  [000000000052ce28] sync_buffer+0x48/0x60
>  [000000000078895c] __wait_on_bit+0x7c/0xe0
>  [0000000000788a04] out_of_line_wait_on_bit+0x44/0x60
>  [000000000057ba44] ext4_find_entry+0x3c4/0x520
>  [000000000057c7c8] ext4_lookup+0x28/0x180
>  [000000000050e5a0] d_alloc_and_lookup+0x40/0x80
>  [000000000050e6dc] do_lookup+0xfc/0x160
>  [0000000000510578] link_path_walk+0x6b8/0xb00
>  [0000000000510aa8] path_walk+0x28/0xa0
>  [0000000000510b64] do_path_lookup+0x44/0xa0
>  [0000000000510f6c] user_path_at+0x2c/0x80
>  [00000000005090c8] vfs_fstatat+0x28/0x80
>  [000000000044390c] compat_sys_stat64+0xc/0x40
>  [0000000000406114] linux_sparc_syscall32+0x34/0x40
> INFO: task rsync:2451 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> rsync         D 00000000005a3d38     0  2451   2445 0x410061101000080
> Call Trace: 
>  [00000000005a39c4] do_get_write_access+0x244/0x480
>  [00000000005a3d38] jbd2_journal_get_write_access+0x18/0x40
>  [0000000000591278] __ext4_journal_get_write_access+0x18/0x60
>  [0000000000572a94] ext4_reserve_inode_write+0x54/0xa0
>  [0000000000572afc] ext4_mark_inode_dirty+0x1c/0x1e0
>  [0000000000577844] ext4_dirty_inode+0x24/0x40
>  [0000000000525b60] __mark_inode_dirty+0x20/0x200
>  [0000000000519d84] file_update_time+0xc4/0x140
>  [00000000004c43f4] __generic_file_aio_write+0x1f4/0x3a0
>  [00000000004c45d4] generic_file_aio_write+0x34/0xc0
>  [0000000000504338] do_sync_write+0x78/0xc0
>  [00000000005049a8] vfs_write+0x68/0x140
>  [0000000000504c4c] SyS_write+0x2c/0x60
>  [0000000000406114] linux_sparc_syscall32+0x34/0x40
> INFO: task cron:4376 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> cron          D 00000000004c33f8     0  4376   3244 0x210021101000080
> Call Trace: 
>  [00000000007880d4] io_schedule+0x54/0xc0
>  [00000000004c33f8] sync_page+0x58/0x80
>  [0000000000788808] __wait_on_bit_lock+0x68/0xe0
>  [00000000004c3360] __lock_page+0x40/0x60
>  [00000000004c4eac] __lock_page_or_retry+0x4c/0x60
>  [00000000004c5108] filemap_fault+0x248/0x3c0
>  [00000000004dca90] __do_fault+0x30/0x480
>  [00000000004df27c] handle_mm_fault+0x13c/0x9a0
>  [000000000044de4c] do_sparc64_fault+0x32c/0x7c0
>  [00000000004079a8] sparc64_realfault_common+0x10/0x20
> INFO: task cron:4377 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> cron          D 00000000004c33f8     0  4377   3244 0x210021101000080
> Call Trace: 
>  [00000000007880d4] io_schedule+0x54/0xc0
>  [00000000004c33f8] sync_page+0x58/0x80
>  [0000000000788808] __wait_on_bit_lock+0x68/0xe0
>  [00000000004c3360] __lock_page+0x40/0x60
>  [00000000004c4eac] __lock_page_or_retry+0x4c/0x60
>  [00000000004c5108] filemap_fault+0x248/0x3c0
>  [00000000004dca90] __do_fault+0x30/0x480
>  [00000000004df27c] handle_mm_fault+0x13c/0x9a0
>  [000000000044de4c] do_sparc64_fault+0x32c/0x7c0
>  [00000000004079a8] sparc64_realfault_common+0x10/0x20
> INFO: task cron:4378 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> cron          D 00000000004c33f8     0  4378   3244 0x210021101000080
> Call Trace: 
>  [00000000007880d4] io_schedule+0x54/0xc0
>  [00000000004c33f8] sync_page+0x58/0x80
>  [0000000000788808] __wait_on_bit_lock+0x68/0xe0
>  [00000000004c3360] __lock_page+0x40/0x60
>  [00000000004c4eac] __lock_page_or_retry+0x4c/0x60
>  [00000000004c5108] filemap_fault+0x248/0x3c0
>  [00000000004dca90] __do_fault+0x30/0x480
>  [00000000004df27c] handle_mm_fault+0x13c/0x9a0
>  [000000000044de4c] do_sparc64_fault+0x32c/0x7c0
>  [00000000004079a8] sparc64_realfault_common+0x10/0x20
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
