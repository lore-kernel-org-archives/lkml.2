Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0GNVGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:06:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49758 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab0GNVGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:06:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Pirker <lkml.collector@gmail.com>
Subject: Re: 2.6.35-rc5 inconsistent lock state
Date: Wed, 14 Jul 2010 23:04:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
In-Reply-To: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007142304.48660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 14, 2010, Martin Pirker wrote:
> Hi list...
> 
> My shiny new kernel wants to tell me something.
> I do not understand him, but maybe you do.... see below

Hmm, kind of looks like a writeback issue (adding CCs).

Rafael

 
> [   27.026441]
> [   27.026443] =================================
> [   27.029003] [ INFO: inconsistent lock state ]
> [   27.030490] 2.6.35-rc5 #1
> [   27.031984] ---------------------------------
> [   27.033520] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [   27.035118] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [   27.035121]  (&(&bdi->wb_lock)->rlock){+.?...}, at:
> [<ffffffff8116cffe>] bdi_queue_work+0x2e/0xb0
> [   27.035133] {SOFTIRQ-ON-W} state was registered at:
> [   27.035136]   [<ffffffff81093fde>] __lock_acquire+0x5de/0x1470
> [   27.035144]   [<ffffffff81094f16>] lock_acquire+0xa6/0x160
> [   27.035149]   [<ffffffff81578ec1>] _raw_spin_lock+0x31/0x40
> [   27.035157]   [<ffffffff811132ce>] bdi_task_init+0x3e/0xa0
> [   27.035164]   [<ffffffff811136c1>] bdi_forker_task+0x31/0x390
> [   27.035169]   [<ffffffff8107dd26>] kthread+0xa6/0xb0
> [   27.035176]   [<ffffffff8100bee4>] kernel_thread_helper+0x4/0x10
> [   27.035183] irq event stamp: 114300
> [   27.035185] hardirqs last  enabled at (114300):
> [<ffffffff8113aa1d>] kmem_cache_alloc_notrace+0xcd/0x110
> [   27.035193] hardirqs last disabled at (114299):
> [<ffffffff8113a9a6>] kmem_cache_alloc_notrace+0x56/0x110
> [   27.035200] softirqs last  enabled at (114274):
> [<ffffffff81065a62>] __do_softirq+0x142/0x260
> [   27.035208] softirqs last disabled at (114287):
> [<ffffffff8100bfdc>] call_softirq+0x1c/0x30
> [   27.035213]
> [   27.035214] other info that might help us debug this:
> [   27.035217] 1 lock held by swapper/0:
> [   27.035219]  #0:
> (&q->backing_dev_info.laptop_mode_wb_timer){+.-...}, at:
> [<ffffffff8106e9f9>] run_timer_softirq+0x139/0x3f0
> [   27.035229]
> [   27.035230] stack backtrace:
> [   27.035234] Pid: 0, comm: swapper Not tainted 2.6.35-rc5 #1
> [   27.035237] Call Trace:
> [   27.035239]  <IRQ>  [<ffffffff810924aa>] print_usage_bug+0x18a/0x190
> [   27.035250]  [<ffffffff81018ccf>] ? save_stack_trace+0x2f/0x50
> [   27.035255]  [<ffffffff81092620>] ? check_usage_forwards+0x0/0xf0
> [   27.035260]  [<ffffffff810932a2>] mark_lock+0x322/0x3f0
> [   27.035265]  [<ffffffff81093f79>] __lock_acquire+0x579/0x1470
> [   27.035270]  [<ffffffff81018ccf>] ? save_stack_trace+0x2f/0x50
> [   27.035275]  [<ffffffff81090037>] ? graph_unlock+0x47/0xa0
> [   27.035280]  [<ffffffff81094f16>] lock_acquire+0xa6/0x160
> [   27.035284]  [<ffffffff8116cffe>] ? bdi_queue_work+0x2e/0xb0
> [   27.035289]  [<ffffffff810933db>] ? mark_held_locks+0x6b/0xa0
> [   27.035294]  [<ffffffff81578ec1>] _raw_spin_lock+0x31/0x40
> [   27.035298]  [<ffffffff8116cffe>] ? bdi_queue_work+0x2e/0xb0
> [   27.035303]  [<ffffffff8109373d>] ? trace_hardirqs_on+0xd/0x10
> [   27.035307]  [<ffffffff8116cffe>] bdi_queue_work+0x2e/0xb0
> [   27.035313]  [<ffffffff8116d508>] __bdi_start_writeback+0x88/0x110
> [   27.035317]  [<ffffffff8116d5d5>] bdi_start_writeback+0x15/0x20
> [   27.035324]  [<ffffffff8110345b>] laptop_mode_timer_fn+0x5b/0x70
> [   27.035329]  [<ffffffff8106ea7f>] run_timer_softirq+0x1bf/0x3f0
> [   27.035334]  [<ffffffff8106e9f9>] ? run_timer_softirq+0x139/0x3f0
> [   27.035339]  [<ffffffff81082516>] ? __run_hrtimer+0xa6/0x1b0
> [   27.035343]  [<ffffffff81103400>] ? laptop_mode_timer_fn+0x0/0x70
> [   27.035349]  [<ffffffff81065999>] ? __do_softirq+0x79/0x260
> [   27.035354]  [<ffffffff810659f2>] __do_softirq+0xd2/0x260
> [   27.035359]  [<ffffffff81082920>] ? hrtimer_interrupt+0x140/0x250
> [   27.035363]  [<ffffffff8100bfdc>] call_softirq+0x1c/0x30
> [   27.035368]  [<ffffffff8100daad>] do_softirq+0x9d/0xd0
> [   27.035373]  [<ffffffff810655b5>] irq_exit+0x95/0xa0
> [   27.035378]  [<ffffffff81580f30>] smp_apic_timer_interrupt+0x70/0x9b
> [   27.035386]  [<ffffffff8100ba93>] apic_timer_interrupt+0x13/0x20
> [   27.035389]  <EOI>  [<ffffffff812fdb8a>] ? intel_idle+0xfa/0x180
> [   27.035399]  [<ffffffff812fdb83>] ? intel_idle+0xf3/0x180
> [   27.035406]  [<ffffffff8157d6a0>] ? __atomic_notifier_call_chain+0x0/0xa0
> [   27.035412]  [<ffffffff81459a87>] cpuidle_idle_call+0xa7/0x140
> [   27.035418]  [<ffffffff81009dd8>] cpu_idle+0xb8/0x110
> [   27.035424]  [<ffffffff8157276b>] start_secondary+0x1fd/0x204
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

