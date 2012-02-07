Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2BGWwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:52:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab2BGWwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:52:49 -0500
Date: Tue, 7 Feb 2012 23:52:46 +0100
From: Jan Kara <jack@suse.cz>
To: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
Cc: jack@suse.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup problem
Message-ID: <20120207225246.GA18832@quack.suse.cz>
References: <20120207215737.10744.qmail@md.dent.med.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207215737.10744.qmail@md.dent.med.uni-muenchen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 07-02-12 22:57:37, Wolfram Gloger wrote:
> I have _exactly_ the same problem as Gerard Saraber on LKML.
> 
> This has occurred twice after upgrading to 3.2.x and the second time
> _right now_.  I seem to be able to reproduce this by building
> iceweasel_10.0-2 from source.
> 
> Appended is the output of 'echo w >/proc/sysrq-trigger'.  I'm
> currently trying to reboot it with an older kernel, therefore the
> 'grub-probe's, but it does not reboot (yet).  A sync is extremely slow
> but does complete eventually.
  Hmm, then this isn't really a deadlock (at least in your case) but only a
rather unresponsive system. Looking at the backtraces you provided I don't
see anything really suspicious. Only maybe fsnotify_mark process - do you
use fsnotify?

> I use no xfs (only ext3) so filesystem issue is improbable.
> I do however use mdraid (0 and 1).
  Thanks for report.

								Honza
> SysRq : Show Blocked State
>   task                        PC stack   pid father
> fsnotify_mark   D ffff88021fc90600     0   437      2 0x00000000
>  ffff880216533000 0000000000000046 ffff8802143dc010 0000000000004000
>  ffff880216533000 0000000000010600 ffff8802143ddfd8 ffff8802143ddfd8
>  0000000000010600 ffff880217404560 0000000000000400 0000000000001000
> Call Trace:
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff812a30a7>] ? __schedule+0x7aa/0x83a
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff8106f939>] ? call_rcu_bh+0xc/0xc
>  [<ffffffff8106fd88>] ? synchronize_rcu_bh+0x1f/0x1f
>  [<ffffffff810468f8>] ? wait_rcu_gp+0x38/0x3f
>  [<ffffffff810468ff>] ? wait_rcu_gp+0x3f/0x3f
>  [<ffffffff8102fbd7>] ? try_to_wake_up+0x1de/0x1ee
>  [<ffffffff8104c26e>] ? __synchronize_srcu+0x32/0x109
>  [<ffffffff810e094f>] ? fsnotify_mark_destroy+0x87/0x143
>  [<ffffffff81048ff9>] ? wake_up_bit+0x22/0x22
>  [<ffffffff810e08c8>] ? fsnotify_duplicate_mark+0x37/0x37
>  [<ffffffff81048c31>] ? kthread+0x7e/0x86
>  [<ffffffff812a6e74>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff81048bb3>] ? kthread_worker_fn+0x141/0x141
>  [<ffffffff812a6e70>] ? gs_change+0xb/0xb
> Xorg            D ffff88021fc50600     0  3939   3914 0x00400004
>  ffff8802142ea400 0000000000000082 ffff880214034010 0000000000004000
>  ffff8802142ea400 0000000000010600 ffff880214035fd8 ffff880214035fd8
>  0000000000010600 0000000000000028 ffff880213a37f00 ffffffff8107e7f7
> Call Trace:
>  [<ffffffff8107e7f7>] ? filemap_fault+0x62/0x319
>  [<ffffffff81093816>] ? __do_fault+0x3f6/0x435
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff8106f939>] ? call_rcu_bh+0xc/0xc
>  [<ffffffff810468f8>] ? wait_rcu_gp+0x38/0x3f
>  [<ffffffff810468ff>] ? wait_rcu_gp+0x3f/0x3f
>  [<ffffffff811f5dc8>] ? mousedev_release+0x40/0x63
>  [<ffffffff810b508d>] ? fput+0xf0/0x1b5
>  [<ffffffff810b23d9>] ? filp_close+0x61/0x68
>  [<ffffffff810b2473>] ? sys_close+0x93/0xcb
>  [<ffffffff812a507b>] ? system_call_fastpath+0x16/0x1b
> grub-probe      D ffff88021fc50600     0  1065      1 0x00000004
>  ffff8800ac1c1e00 0000000000000086 ffff880083142010 0000000000004000
>  ffff8800ac1c1e00 0000000000010600 ffff880083143fd8 ffff880083143fd8
>  0000000000010600 0000000000000000 ffff88021fffcc08 0000000000000000
> Call Trace:
>  [<ffffffff8107de40>] ? find_get_pages_tag+0x46/0xe1
>  [<ffffffff810866ba>] ? pagevec_lookup_tag+0x1a/0x21
>  [<ffffffff8102a093>] ? select_task_rq_fair+0x608/0x934
>  [<ffffffff81084747>] ? bdi_position_ratio+0x12b/0x12b
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff81028a9b>] ? check_preempt_wakeup+0x10c/0x15c
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff81087140>] ? lru_add_drain+0xb8/0xb8
>  [<ffffffff81044f5c>] ? flush_work+0x22/0x2c
>  [<ffffffff8104347f>] ? do_work_for_cpu+0x1b/0x1b
>  [<ffffffff8104566e>] ? schedule_on_each_cpu+0xa6/0xdb
>  [<ffffffff810d64ae>] ? invalidate_bdev+0x28/0x39
>  [<ffffffff8113fdd9>] ? blkdev_ioctl+0x1c2/0x7c5
>  [<ffffffff810c0391>] ? path_openat+0x342/0x362
>  [<ffffffff810c0484>] ? do_filp_open+0x2c/0x74
>  [<ffffffff810d9e2e>] ? block_ioctl+0x38/0x3c
>  [<ffffffff810c160b>] ? do_vfs_ioctl+0x3f1/0x432
>  [<ffffffff810b22ef>] ? fd_install+0x2e/0x59
>  [<ffffffff810ae1e0>] ? kmem_cache_free+0x14/0x8f
>  [<ffffffff810c169d>] ? sys_ioctl+0x51/0x70
>  [<ffffffff812a507b>] ? system_call_fastpath+0x16/0x1b
> grub-probe      D ffff88021fc90600     0  1137      1 0x00000004
>  ffff8800ac1ea400 0000000000000082 ffff8800831f4010 0000000000004000
>  ffff8800ac1ea400 0000000000010600 ffff8800831f5fd8 ffff8800831f5fd8
>  0000000000010600 ffff88001703e538 00000000ffffffff 0000000000000000
> Call Trace:
>  [<ffffffff8107de40>] ? find_get_pages_tag+0x46/0xe1
>  [<ffffffff810866ba>] ? pagevec_lookup_tag+0x1a/0x21
>  [<ffffffff8102a093>] ? select_task_rq_fair+0x608/0x934
>  [<ffffffff81084747>] ? bdi_position_ratio+0x12b/0x12b
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff81028a9b>] ? check_preempt_wakeup+0x10c/0x15c
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff81087140>] ? lru_add_drain+0xb8/0xb8
>  [<ffffffff81044f5c>] ? flush_work+0x22/0x2c
>  [<ffffffff8104347f>] ? do_work_for_cpu+0x1b/0x1b
>  [<ffffffff8104566e>] ? schedule_on_each_cpu+0xa6/0xdb
>  [<ffffffff810d64ae>] ? invalidate_bdev+0x28/0x39
>  [<ffffffff8113fdd9>] ? blkdev_ioctl+0x1c2/0x7c5
>  [<ffffffff810c0391>] ? path_openat+0x342/0x362
>  [<ffffffff810c0484>] ? do_filp_open+0x2c/0x74
>  [<ffffffff810d9e2e>] ? block_ioctl+0x38/0x3c
>  [<ffffffff810c160b>] ? do_vfs_ioctl+0x3f1/0x432
>  [<ffffffff810b22ef>] ? fd_install+0x2e/0x59
>  [<ffffffff810ae1e0>] ? kmem_cache_free+0x14/0x8f
>  [<ffffffff810c169d>] ? sys_ioctl+0x51/0x70
>  [<ffffffff812a507b>] ? system_call_fastpath+0x16/0x1b
> grub-probe      D ffff88021fc90600     0  1285      1 0x00000004
>  ffff8801b7a46c00 0000000000000082 ffff8801b93e4010 0000000000004000
>  ffff8801b7a46c00 0000000000010600 ffff8801b93e5fd8 ffff8801b93e5fd8
>  0000000000010600 0000000000000246 ffff8801b93e4000 0000000000000000
> Call Trace:
>  [<ffffffff8107de40>] ? find_get_pages_tag+0x46/0xe1
>  [<ffffffff810866ba>] ? pagevec_lookup_tag+0x1a/0x21
>  [<ffffffff8102a093>] ? select_task_rq_fair+0x608/0x934
>  [<ffffffff81084747>] ? bdi_position_ratio+0x12b/0x12b
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff81028a9b>] ? check_preempt_wakeup+0x10c/0x15c
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff81087140>] ? lru_add_drain+0xb8/0xb8
>  [<ffffffff81044f5c>] ? flush_work+0x22/0x2c
>  [<ffffffff8104347f>] ? do_work_for_cpu+0x1b/0x1b
>  [<ffffffff8104566e>] ? schedule_on_each_cpu+0xa6/0xdb
>  [<ffffffff810d64ae>] ? invalidate_bdev+0x28/0x39
>  [<ffffffff8113fdd9>] ? blkdev_ioctl+0x1c2/0x7c5
>  [<ffffffff810c0391>] ? path_openat+0x342/0x362
>  [<ffffffff810c0484>] ? do_filp_open+0x2c/0x74
>  [<ffffffff810d9e2e>] ? block_ioctl+0x38/0x3c
>  [<ffffffff810c160b>] ? do_vfs_ioctl+0x3f1/0x432
>  [<ffffffff810b22ef>] ? fd_install+0x2e/0x59
>  [<ffffffff810ae1e0>] ? kmem_cache_free+0x14/0x8f
>  [<ffffffff810c169d>] ? sys_ioctl+0x51/0x70
>  [<ffffffff812a507b>] ? system_call_fastpath+0x16/0x1b
> killall5        D ffff88021fc10600     0  1831   1827 0x00000000
>  ffff880100278000 0000000000000082 ffff88020edfc010 0000000000004000
>  ffff880100278000 0000000000010600 ffff88020edfdfd8 ffff88020edfdfd8
>  0000000000010600 00000000000000cc ffff88020edfdf58 ffffffff00000000
> Call Trace:
>  [<ffffffff8102a093>] ? select_task_rq_fair+0x608/0x934
>  [<ffffffff812a3427>] ? schedule_timeout+0x1f/0x193
>  [<ffffffff81028a9b>] ? check_preempt_wakeup+0x10c/0x15c
>  [<ffffffff812a2724>] ? wait_for_common+0xcc/0x142
>  [<ffffffff8102fbe7>] ? try_to_wake_up+0x1ee/0x1ee
>  [<ffffffff81087140>] ? lru_add_drain+0xb8/0xb8
>  [<ffffffff81044f5c>] ? flush_work+0x22/0x2c
>  [<ffffffff8104347f>] ? do_work_for_cpu+0x1b/0x1b
>  [<ffffffff8104566e>] ? schedule_on_each_cpu+0xa6/0xdb
>  [<ffffffff810986a5>] ? sys_mlockall+0x38/0x111
>  [<ffffffff812a507b>] ? system_call_fastpath+0x16/0x1b
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
