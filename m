Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2JSFWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:22:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2JSFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:21:59 -0400
Date: Fri, 19 Oct 2012 01:21:36 -0400
From: Dave Jones <davej@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: MAX_LOCKDEP_ENTRIES too low  (called from ioc_release_fn)
Message-ID: <20121019052136.GA30852@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <20121018015312.GA29865@redhat.com>
 <507F9944.50505@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F9944.50505@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:53:08AM +0200, Jens Axboe wrote:
 > On 2012-10-18 03:53, Dave Jones wrote:
 > > Triggered while fuzz testing..
 > > 
 > > 
 > > BUG: MAX_LOCKDEP_ENTRIES too low!
 > > turning off the locking correctness validator.
 > > Pid: 22788, comm: kworker/2:1 Not tainted 3.7.0-rc1+ #34
 > > Call Trace:
 > >  [<ffffffff810decdd>] add_lock_to_list.isra.29.constprop.45+0xdd/0xf0
 > >  [<ffffffff810e2871>] __lock_acquire+0x1121/0x1ba0
 > >  [<ffffffff810e3a12>] lock_acquire+0xa2/0x220
 > >  [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
 > >  [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 > >  [<ffffffff816c0800>] _raw_spin_lock+0x40/0x80
 > >  [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
 > >  [<ffffffff8117bad2>] free_one_page+0x32/0x450
 > >  [<ffffffff8117bf41>] ? __free_pages_ok.part.58+0x51/0x110
 > >  [<ffffffff8117bf9c>] __free_pages_ok.part.58+0xac/0x110
 > >  [<ffffffff8117cd73>] __free_pages+0x73/0x90
 > >  [<ffffffff811cb4f3>] __free_slab+0xd3/0x1b0
 > >  [<ffffffff811cb609>] discard_slab+0x39/0x50
 > >  [<ffffffff816b77db>] __slab_free+0x378/0x3a3
 > >  [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
 > >  [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
 > >  [<ffffffff811cd4e2>] kmem_cache_free+0x2f2/0x320
 > >  [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 > >  [<ffffffff81341289>] ioc_release_fn+0x99/0xe0
 > >  [<ffffffff81095a37>] process_one_work+0x207/0x780
 > >  [<ffffffff810959c7>] ? process_one_work+0x197/0x780
 > >  [<ffffffff813411f0>] ? get_io_context+0x20/0x20
 > >  [<ffffffff8109638e>] worker_thread+0x15e/0x440
 > >  [<ffffffff81096230>] ? rescuer_thread+0x240/0x240
 > >  [<ffffffff8109d0cd>] kthread+0xed/0x100
 > >  [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 > >  [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 > >  [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 > >  [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 > 
 > Not sure why you are CC'ing a call site, rather than the maintainers of
 > the code. Just looks like lockdep is using too small a static value.
 > Though it is pretty darn large...

You're right, it's a huge chunk of memory.
It looks like I can trigger this from multiple callsites..
Another different trace below.

Not sure why this suddenly got a lot worse in 3.7

Peter, Ingo ?

	Dave

BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
Pid: 22350, comm: trinity-child0 Not tainted 3.7.0-rc1+ #36
Call Trace:
 [<ffffffff810decdd>] add_lock_to_list.isra.29.constprop.45+0xdd/0xf0
 [<ffffffff810e2871>] __lock_acquire+0x1121/0x1ba0
 [<ffffffff810b6f89>] ? local_clock+0x89/0xa0
 [<ffffffff811b84a5>] ? __swap_duplicate+0xb5/0x190
 [<ffffffff810dea58>] ? trace_hardirqs_off_caller+0x28/0xd0
 [<ffffffff810e3a12>] lock_acquire+0xa2/0x220
 [<ffffffff811b663d>] ? __add_to_swap_cache+0x6d/0x180
 [<ffffffff816c0f79>] ? _raw_spin_lock_irq+0x29/0x90
 [<ffffffff816c0fa6>] _raw_spin_lock_irq+0x56/0x90
 [<ffffffff811b663d>] ? __add_to_swap_cache+0x6d/0x180
 [<ffffffff811b663d>] __add_to_swap_cache+0x6d/0x180
 [<ffffffff811b6c45>] read_swap_cache_async+0xb5/0x220
 [<ffffffff811b6e4e>] swapin_readahead+0x9e/0xf0
 [<ffffffff811a2c86>] handle_pte_fault+0x6d6/0xae0
 [<ffffffff816c5ad9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff8136d37e>] ? delay_tsc+0xae/0x120
 [<ffffffff8136d268>] ? __const_udelay+0x28/0x30
 [<ffffffff811a4919>] handle_mm_fault+0x289/0x350
 [<ffffffff816c538e>] __do_page_fault+0x18e/0x530
 [<ffffffff810b6f89>] ? local_clock+0x89/0xa0
 [<ffffffff816b77e1>] ? __slab_free+0x32e/0x3a3
 [<ffffffff8112d2e9>] ? rcu_user_exit+0xc9/0xf0
 [<ffffffffa0000020>] ? 0xffffffffa000001f
 [<ffffffffa0000020>] ? 0xffffffffa000001f
 [<ffffffff816c575b>] do_page_fault+0x2b/0x50
 [<ffffffff816c1e38>] page_fault+0x28/0x30
 [<ffffffffa0000020>] ? 0xffffffffa000001f
 [<ffffffff813885ac>] ? strncpy_from_user+0x6c/0x120
 [<ffffffffa0000020>] ? 0xffffffffa000001f
 [<ffffffff8120e94f>] setxattr+0x6f/0x1d0
 [<ffffffff816c5ad9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff8137e8b5>] ? __percpu_counter_add+0x75/0xc0
 [<ffffffff811e92d1>] ? __sb_start_write+0x101/0x1d0
 [<ffffffff81209d94>] ? mnt_want_write+0x24/0x50
 [<ffffffff81209d94>] ? mnt_want_write+0x24/0x50
 [<ffffffff810b0de1>] ? get_parent_ip+0x11/0x50
 [<ffffffff816c5ad9>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff81209d30>] ? __mnt_want_write+0x60/0xa0
 [<ffffffffa0000020>] ? 0xffffffffa000001f
 [<ffffffff8120ecd5>] sys_setxattr+0x95/0xb0
 [<ffffffff816ca108>] tracesys+0xe1/0xe6
 [<ffffffffa0000020>] ? 0xffffffffa000001f

