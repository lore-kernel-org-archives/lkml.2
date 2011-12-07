Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1LGHj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:39:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57498 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1LGHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:39:57 -0500
Date: Wed, 7 Dec 2011 15:39:43 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [BUG -tip/sched] INFO: suspicious RCU usage
Message-ID: <20111207073942.GA12029@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

===============================
[ INFO: suspicious RCU usage. ]
-------------------------------
/build/linux/kernel/sched/fair.c:5091 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by swapper/0/1:
 #0:  (&sb->s_type->i_mutex_key#2){+.+.+.}, at: [<ffffffff812a0e0c>] debugfs_create_file+0x8c/0x270

stack backtrace:
Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc1-00339-gcd490c5 #14
Call Trace:
 <IRQ>  [<ffffffff815f9968>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff8109407f>] lockdep_rcu_suspicious+0xbf/0xe0
 [<ffffffff8107dd48>] trigger_load_balance+0x5b8/0x5c0
 [<ffffffff81070544>] scheduler_tick+0x104/0x160
 [<ffffffff8104a1ce>] update_process_times+0x6e/0x90
 [<ffffffff8108e32c>] tick_periodic+0x2c/0x70
 [<ffffffff8108e394>] tick_handle_periodic+0x24/0x80
 [<ffffffff812a07a7>] ? T.562+0xf7/0x170
 [<ffffffff815fce56>] smp_apic_timer_interrupt+0x66/0x98
 [<ffffffff815fb2f0>] apic_timer_interrupt+0x70/0x80
 <EOI>  [<ffffffff810984a4>] ? lock_release+0xe4/0x2b0
 [<ffffffff815f98f3>] _raw_spin_unlock+0x23/0x60
 [<ffffffff812a07a7>] T.562+0xf7/0x170
 [<ffffffff812a0e71>] debugfs_create_file+0xf1/0x270
 [<ffffffff810e96c9>] trace_create_file+0x19/0x50
 [<ffffffff81af7b3c>] tracer_init_debugfs+0x2bd/0x3c0
 [<ffffffff810e96c9>] ? trace_create_file+0x19/0x50
 [<ffffffff81af787f>] ? clear_boot_tracer+0x2d/0x2d
 [<ffffffff810001d3>] do_one_initcall+0x43/0x180
 [<ffffffff81adf637>] kernel_init+0xd0/0x156
 [<ffffffff815fc574>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106fdb8>] ? finish_task_switch+0x88/0xf0
 [<ffffffff815f99eb>] ? _raw_spin_unlock_irq+0x3b/0x70
 [<ffffffff815f9f61>] ? retint_restore_args+0xe/0xe
 [<ffffffff81adf567>] ? parse_early_options+0x20/0x20
 [<ffffffff815fc570>] ? gs_change+0xb/0xb

Seems due to commit [0b005cf5: sched, nohz: Implement sched group, domain
aware nohz idle load balancing]

Thanks,
Yong
