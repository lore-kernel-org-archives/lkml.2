Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JRFxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:53:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:52965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2JRFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:53:14 -0400
Message-ID: <507F9944.50505@kernel.dk>
Date: Thu, 18 Oct 2012 07:53:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: MAX_LOCKDEP_ENTRIES too low  (called from ioc_release_fn)
References: <20121018015312.GA29865@redhat.com>
In-Reply-To: <20121018015312.GA29865@redhat.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-18 03:53, Dave Jones wrote:
> Triggered while fuzz testing..
> 
> 
> BUG: MAX_LOCKDEP_ENTRIES too low!
> turning off the locking correctness validator.
> Pid: 22788, comm: kworker/2:1 Not tainted 3.7.0-rc1+ #34
> Call Trace:
>  [<ffffffff810decdd>] add_lock_to_list.isra.29.constprop.45+0xdd/0xf0
>  [<ffffffff810e2871>] __lock_acquire+0x1121/0x1ba0
>  [<ffffffff810e3a12>] lock_acquire+0xa2/0x220
>  [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
>  [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
>  [<ffffffff816c0800>] _raw_spin_lock+0x40/0x80
>  [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
>  [<ffffffff8117bad2>] free_one_page+0x32/0x450
>  [<ffffffff8117bf41>] ? __free_pages_ok.part.58+0x51/0x110
>  [<ffffffff8117bf9c>] __free_pages_ok.part.58+0xac/0x110
>  [<ffffffff8117cd73>] __free_pages+0x73/0x90
>  [<ffffffff811cb4f3>] __free_slab+0xd3/0x1b0
>  [<ffffffff811cb609>] discard_slab+0x39/0x50
>  [<ffffffff816b77db>] __slab_free+0x378/0x3a3
>  [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
>  [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
>  [<ffffffff811cd4e2>] kmem_cache_free+0x2f2/0x320
>  [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
>  [<ffffffff81341289>] ioc_release_fn+0x99/0xe0
>  [<ffffffff81095a37>] process_one_work+0x207/0x780
>  [<ffffffff810959c7>] ? process_one_work+0x197/0x780
>  [<ffffffff813411f0>] ? get_io_context+0x20/0x20
>  [<ffffffff8109638e>] worker_thread+0x15e/0x440
>  [<ffffffff81096230>] ? rescuer_thread+0x240/0x240
>  [<ffffffff8109d0cd>] kthread+0xed/0x100
>  [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
>  [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
>  [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

Not sure why you are CC'ing a call site, rather than the maintainers of
the code. Just looks like lockdep is using too small a static value.
Though it is pretty darn large...

-- 
Jens Axboe

