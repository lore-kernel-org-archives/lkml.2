Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1KIJGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:06:08 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47533 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1KIJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:06:06 -0500
Date: Wed, 9 Nov 2011 17:05:57 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: 3.2-rc1: INFO: possible recursive locking detected
Message-ID: <20111109090556.GA5949@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just get below waring when doing:
for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done

And kernel config is attached.

Thanks,
Yong

---
[  350.148020] =============================================
[  350.148020] [ INFO: possible recursive locking detected ]
[  350.148020] 3.2.0-rc1-10791-g76a4b59-dirty #2
[  350.148020] ---------------------------------------------
[  350.148020] perf/9439 is trying to acquire lock:
[  350.148020]  (&(&n->list_lock)->rlock){-.-...}, at: [<ffffffff8113847f>] get_partial_node+0x5f/0x360
[  350.148020] 
[  350.148020] but task is already holding lock:
[  350.148020]  (&(&n->list_lock)->rlock){-.-...}, at: [<ffffffff811380c9>] unfreeze_partials+0x199/0x3c0
[  350.148020] 
[  350.148020] other info that might help us debug this:
[  350.148020]  Possible unsafe locking scenario:
[  350.148020] 
[  350.148020]        CPU0
[  350.148020]        ----
[  350.148020]   lock(&(&n->list_lock)->rlock);
[  350.148020]   lock(&(&n->list_lock)->rlock);
[  350.148020] 
[  350.148020]  *** DEADLOCK ***
[  350.148020] 
[  350.148020]  May be due to missing lock nesting notation
[  350.148020] 
[  350.148020] 2 locks held by perf/9439:
[  350.148020]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff810552ee>] release_task+0x9e/0x500
[  350.148020]  #1:  (&(&n->list_lock)->rlock){-.-...}, at: [<ffffffff811380c9>] unfreeze_partials+0x199/0x3c0
[  350.148020] 
[  350.148020] stack backtrace:
[  350.148020] Pid: 9439, comm: perf Not tainted 3.2.0-rc1-10791-g76a4b59-dirty #2
[  350.148020] Call Trace:
[  350.148020]  [<ffffffff815e7278>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[  350.148020]  [<ffffffff810932ff>] validate_chain+0xddf/0x1250
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff81080c2f>] ? local_clock+0x4f/0x60
[  350.148020]  [<ffffffff8108e939>] ? trace_hardirqs_off_caller+0x29/0x130
[  350.148020]  [<ffffffff81093b3f>] __lock_acquire+0x3cf/0xc00
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff81094a3d>] lock_acquire+0x9d/0x1d0
[  350.148020]  [<ffffffff8113847f>] ? get_partial_node+0x5f/0x360
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff81080c2f>] ? local_clock+0x4f/0x60
[  350.148020]  [<ffffffff815e6570>] _raw_spin_lock+0x40/0x80
[  350.148020]  [<ffffffff8113847f>] ? get_partial_node+0x5f/0x360
[  350.148020]  [<ffffffff8113847f>] get_partial_node+0x5f/0x360
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff8113a836>] ? T.1029+0x36/0x3f0
[  350.148020]  [<ffffffff813741ba>] ? __debug_object_init+0x3ba/0x3d0
[  350.148020]  [<ffffffff8113a9b7>] T.1029+0x1b7/0x3f0
[  350.148020]  [<ffffffff813741ba>] ? __debug_object_init+0x3ba/0x3d0
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff813741ba>] ? __debug_object_init+0x3ba/0x3d0
[  350.148020]  [<ffffffff8113ace6>] kmem_cache_alloc+0xf6/0x200
[  350.148020]  [<ffffffff813741ba>] __debug_object_init+0x3ba/0x3d0
[  350.148020]  [<ffffffff815e7278>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[  350.148020]  [<ffffffff8137421f>] debug_object_init+0x1f/0x30
[  350.148020]  [<ffffffff81075f94>] rcuhead_fixup_activate+0x34/0xe0
[  350.148020]  [<ffffffff813732a3>] debug_object_fixup+0x13/0x20
[  350.148020]  [<ffffffff8137394c>] debug_object_activate+0xbc/0x160
[  350.148020]  [<ffffffff81137c20>] ? deactivate_slab+0x7c0/0x7c0
[  350.148020]  [<ffffffff810c8f52>] __call_rcu+0x42/0x1d0
[  350.148020]  [<ffffffff810c90f5>] call_rcu+0x15/0x20
[  350.148020]  [<ffffffff81137454>] discard_slab+0x44/0x50
[  350.148020]  [<ffffffff8113822f>] unfreeze_partials+0x2ff/0x3c0
[  350.148020]  [<ffffffff8100a9b9>] ? native_sched_clock+0x29/0x80
[  350.148020]  [<ffffffff811383d9>] ? put_cpu_partial+0x99/0xe0
[  350.148020]  [<ffffffff811383e1>] put_cpu_partial+0xa1/0xe0
[  350.148020]  [<ffffffff81139d22>] __slab_free+0x102/0x470
[  350.148020]  [<ffffffff8104ef17>] ? __cleanup_sighand+0x27/0x30
[  350.148020]  [<ffffffff8113a7f0>] kmem_cache_free+0x220/0x230
[  350.148020]  [<ffffffff8104ef17>] __cleanup_sighand+0x27/0x30
[  350.148020]  [<ffffffff8105548b>] release_task+0x23b/0x500
[  350.148020]  [<ffffffff8105526d>] ? release_task+0x1d/0x500
[  350.148020]  [<ffffffff81056043>] wait_consider_task+0x8f3/0xc40
[  350.148020]  [<ffffffff810564b1>] do_wait+0x121/0x340
[  350.148020]  [<ffffffff81056773>] sys_wait4+0xa3/0x100
[  350.148020]  [<ffffffff810544e0>] ? wait_noreap_copyout+0x150/0x150
[  350.148020]  [<ffffffff815e7dab>] system_call_fastpath+0x16/0x1b

