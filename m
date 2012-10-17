Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2JQDt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab2JQDtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:49:24 -0400
Date: Tue, 16 Oct 2012 23:49:18 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: lots of suspicious RCU traces
Message-ID: <20121017034918.GA13295@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just triggered this while fuzz testing. All traces happened
in quick succession.

	Dave

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
2 locks on stack by trinity-main/9791:
 #0: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff8801435dce20, at: [<ffffffff8108afd3>] ptrace_notify+0x53/0x90
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81097e75>] __task_pid_nr_ns+0x5/0x1a0

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81097fd5>] __task_pid_nr_ns+0x165/0x1a0
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff8108924f>] ptrace_do_notify+0x5f/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
2 locks on stack by trinity-main/9791:
 #0: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff8801435dce20, at: [<ffffffff8108afd3>] ptrace_notify+0x53/0x90
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81097e75>] __task_pid_nr_ns+0x5/0x1a0

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81097fa1>] __task_pid_nr_ns+0x131/0x1a0
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff8108924f>] ptrace_do_notify+0x5f/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ba5dc>] active_load_balance_cpu_stop+0x3ac/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff816c1030>] ? _raw_spin_unlock_irq+0x30/0x80
 [<ffffffff810b0de1>] ? get_parent_ip+0x11/0x50
 [<ffffffff810b0de1>] ? get_parent_ip+0x11/0x50
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/sched/fair.c:4538 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ba665>] active_load_balance_cpu_stop+0x435/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff816c1030>] ? _raw_spin_unlock_irq+0x30/0x80
 [<ffffffff810b0de1>] ? get_parent_ip+0x11/0x50
 [<ffffffff810b0de1>] ? get_parent_ip+0x11/0x50
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
4 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490
 #3: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810b6a53>] cpuacct_charge+0x13/0x230

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810b6c0c>] cpuacct_charge+0x1cc/0x230
 [<ffffffff810b6a53>] ? cpuacct_charge+0x13/0x230
 [<ffffffff810bafa4>] update_curr+0x104/0x270
 [<ffffffff810bc244>] enqueue_entity+0x44/0x720
 [<ffffffff810bc962>] enqueue_task_fair+0x42/0xf0
 [<ffffffff810af326>] enqueue_task+0x66/0x80
 [<ffffffff810b01c3>] activate_task+0x23/0x30
 [<ffffffff810b8aec>] move_task+0x3c/0x50
 [<ffffffff810ba4b2>] active_load_balance_cpu_stop+0x282/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
4 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490
 #3: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810b6a53>] cpuacct_charge+0x13/0x230

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810b6bd5>] cpuacct_charge+0x195/0x230
 [<ffffffff810b6a53>] ? cpuacct_charge+0x13/0x230
 [<ffffffff810bafa4>] update_curr+0x104/0x270
 [<ffffffff810bc244>] enqueue_entity+0x44/0x720
 [<ffffffff810bc962>] enqueue_task_fair+0x42/0xf0
 [<ffffffff810af326>] enqueue_task+0x66/0x80
 [<ffffffff810b01c3>] activate_task+0x23/0x30
 [<ffffffff810b8aec>] move_task+0x3c/0x50
 [<ffffffff810ba4b2>] active_load_balance_cpu_stop+0x282/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
4 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490
 #3: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810b6a53>] cpuacct_charge+0x13/0x230

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810b6b70>] cpuacct_charge+0x130/0x230
 [<ffffffff810b6a53>] ? cpuacct_charge+0x13/0x230
 [<ffffffff810bafa4>] update_curr+0x104/0x270
 [<ffffffff810bc244>] enqueue_entity+0x44/0x720
 [<ffffffff810bc962>] enqueue_task_fair+0x42/0xf0
 [<ffffffff810af326>] enqueue_task+0x66/0x80
 [<ffffffff810b01c3>] activate_task+0x23/0x30
 [<ffffffff810b8aec>] move_task+0x3c/0x50
 [<ffffffff810ba4b2>] active_load_balance_cpu_stop+0x282/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by migration/2/24:
 #0: held:     (&rq->lock){-.-.-.}, instance: ffff8801481d4a98, at: [<ffffffff810ba558>] active_load_balance_cpu_stop+0x328/0x490
 #1: held:     (&rq->lock/1){..-.-.}, instance: ffff8801483d4a98, at: [<ffffffff810ba569>] active_load_balance_cpu_stop+0x339/0x490
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ba324>] active_load_balance_cpu_stop+0xf4/0x490

stack backtrace:
Pid: 24, comm: migration/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ba615>] active_load_balance_cpu_stop+0x3e5/0x490
 [<ffffffff810ba324>] ? active_load_balance_cpu_stop+0xf4/0x490
 [<ffffffff81107923>] ? cpu_stopper_thread+0xb3/0x1d0
 [<ffffffff810ba230>] ? select_task_rq_fair+0xad0/0xad0
 [<ffffffff8110794b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816bef69>] ? __schedule+0x499/0xa40
 [<ffffffff81107870>] ? cpu_stop_queue_work+0x80/0x80
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160


===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/rcutree.c:360 Illegal idle entry in RCU read-side critical section.!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
1 lock on stack by rcuc/2/22:
 #0: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff816c5855>] __atomic_notifier_call_chain+0x5/0x140

stack backtrace:
Pid: 22, comm: rcuc/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 <IRQ>  [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff8112a2d3>] rcu_eqs_enter_common.isra.41+0x1b3/0x1f0
 [<ffffffff8112d1dd>] rcu_irq_exit+0xbd/0x100
 [<ffffffff8107ba2b>] irq_exit+0x8b/0xe0
 [<ffffffff816cbc0b>] smp_apic_timer_interrupt+0x6b/0x98
 [<ffffffff816cab32>] apic_timer_interrupt+0x72/0x80
 <EOI>  [<ffffffff810e4472>] ? mark_held_locks+0xb2/0x130
 [<ffffffff810736d5>] ? vprintk_emit+0x1b5/0x600
 [<ffffffff816b3b1b>] printk+0x61/0x63
 [<ffffffff810dfa6f>] lockdep_rcu_suspicious+0x2f/0x130
 [<ffffffff816c597c>] __atomic_notifier_call_chain+0x12c/0x140
 [<ffffffff816c5855>] ? __atomic_notifier_call_chain+0x5/0x140
 [<ffffffff816c59a6>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff810d34da>] profile_handoff_task+0x1a/0x30
 [<ffffffff8106dc18>] __put_task_struct+0x88/0x140
 [<ffffffff81075c28>] delayed_put_task_struct+0x48/0x170
 [<ffffffff8112acda>] rcu_do_batch.isra.22+0x15a/0x440
 [<ffffffff8112c963>] rcu_cpu_kthread+0x143/0x670
 [<ffffffff810a8464>] smpboot_thread_fn+0x1d4/0x300
 [<ffffffff810a8290>] ? __smpboot_create_thread.part.2+0xc0/0xc0
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff816be985>] ? wait_for_common+0x135/0x180
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
1 lock on stack by rcuc/2/22:
 #0: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff816c5855>] __atomic_notifier_call_chain+0x5/0x140

stack backtrace:
Pid: 22, comm: rcuc/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff816c597c>] __atomic_notifier_call_chain+0x12c/0x140
 [<ffffffff816c5855>] ? __atomic_notifier_call_chain+0x5/0x140
 [<ffffffff816c59a6>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff810d34da>] profile_handoff_task+0x1a/0x30
 [<ffffffff8106dc18>] __put_task_struct+0x88/0x140
 [<ffffffff81075c28>] delayed_put_task_struct+0x48/0x170
 [<ffffffff8112acda>] rcu_do_batch.isra.22+0x15a/0x440
 [<ffffffff8112c963>] rcu_cpu_kthread+0x143/0x670
 [<ffffffff810a8464>] smpboot_thread_fn+0x1d4/0x300
 [<ffffffff810a8290>] ? __smpboot_create_thread.part.2+0xc0/0xc0
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff816be985>] ? wait_for_common+0x135/0x180
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
1 lock on stack by rcuc/2/22:
 #0: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff816c5855>] __atomic_notifier_call_chain+0x5/0x140

stack backtrace:
Pid: 22, comm: rcuc/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff816c5948>] __atomic_notifier_call_chain+0xf8/0x140
 [<ffffffff816c5855>] ? __atomic_notifier_call_chain+0x5/0x140
 [<ffffffff816c59a6>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff810d34da>] profile_handoff_task+0x1a/0x30
 [<ffffffff8106dc18>] __put_task_struct+0x88/0x140
 [<ffffffff81075c28>] delayed_put_task_struct+0x48/0x170
 [<ffffffff8112acda>] rcu_do_batch.isra.22+0x15a/0x440
 [<ffffffff8112c963>] rcu_cpu_kthread+0x143/0x670
 [<ffffffff810a8464>] smpboot_thread_fn+0x1d4/0x300
 [<ffffffff810a8290>] ? __smpboot_create_thread.part.2+0xc0/0xc0
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff816be985>] ? wait_for_common+0x135/0x180
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/sched/fair.c:4723 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
1 lock on stack by rcuc/2/22:
 #0: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810bea25>] rebalance_domains+0x5/0x310

stack backtrace:
Pid: 22, comm: rcuc/2 Not tainted 3.7.0-rc1+ #31
Call Trace:
 <IRQ>  [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810bed05>] rebalance_domains+0x2e5/0x310
 [<ffffffff810bea25>] ? rebalance_domains+0x5/0x310
 [<ffffffff810e4576>] ? trace_hardirqs_on_caller+0x86/0x1e0
 [<ffffffff810bed7d>] run_rebalance_domains+0x4d/0x1c0
 [<ffffffffa030d310>] ? dn_neigh_elist+0x40/0x160 [decnet]
 [<ffffffff8107b520>] __do_softirq+0xf0/0x440
 [<ffffffff816cb27c>] call_softirq+0x1c/0x30
 <EOI>  [<ffffffff8101f175>] do_softirq+0xd5/0x110
 [<ffffffff8112c968>] ? rcu_cpu_kthread+0x148/0x670
 [<ffffffff8107b3eb>] local_bh_enable+0x11b/0x160
 [<ffffffff8112c968>] rcu_cpu_kthread+0x148/0x670
 [<ffffffff810a8464>] smpboot_thread_fn+0x1d4/0x300
 [<ffffffff810a8290>] ? __smpboot_create_thread.part.2+0xc0/0xc0
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff816be985>] ? wait_for_common+0x135/0x180
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/sched/fair.c:2715 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
5 locks on stack by kworker/2:0/9822:
 #0: blocked:  (events){.+.+.+}, instance: ffff880147814fd8, at: [<ffffffff810959c7>] process_one_work+0x197/0x780
 #1: blocked:  ((&barr->work)){+.+...}, instance: ffff880083ad5d38, at: [<ffffffff810959c7>] process_one_work+0x197/0x780
 #2: held:     (&x->wait#8){......}, instance: ffff88005a183e90, at: [<ffffffff810ab2b8>] complete+0x28/0x60
 #3: held:     (&p->pi_lock){-.-.-.}, instance: ffff88003606cf78, at: [<ffffffff810b37f1>] try_to_wake_up+0x31/0x320
 #4: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810b97c1>] select_task_rq_fair+0x61/0xad0

stack backtrace:
Pid: 9822, comm: kworker/2:0 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810b9b10>] select_task_rq_fair+0x3b0/0xad0
 [<ffffffff810b97c1>] ? select_task_rq_fair+0x61/0xad0
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff810b37f1>] ? try_to_wake_up+0x31/0x320
 [<ffffffff810b387e>] try_to_wake_up+0xbe/0x320
 [<ffffffff810b3af2>] default_wake_function+0x12/0x20
 [<ffffffff810a8b75>] __wake_up_common+0x55/0x90
 [<ffffffff810ab2b8>] ? complete+0x28/0x60
 [<ffffffff810ab2d7>] complete+0x47/0x60
 [<ffffffff81092422>] wq_barrier_func+0x12/0x20
 [<ffffffff81095a37>] process_one_work+0x207/0x780
 [<ffffffff810959c7>] ? process_one_work+0x197/0x780
 [<ffffffff81092410>] ? destroy_work_on_stack+0x20/0x20
 [<ffffffff81095fdc>] process_scheduled_works+0x2c/0x40
 [<ffffffff8109652a>] worker_thread+0x2fa/0x440
 [<ffffffff81096230>] ? rescuer_thread+0x240/0x240
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/sched/core.c:1216 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
5 locks on stack by kworker/2:0/9822:
 #0: blocked:  (events){.+.+.+}, instance: ffff880147814fd8, at: [<ffffffff810959c7>] process_one_work+0x197/0x780
 #1: blocked:  ((&barr->work)){+.+...}, instance: ffff880083ad5d38, at: [<ffffffff810959c7>] process_one_work+0x197/0x780
 #2: held:     (&x->wait#8){......}, instance: ffff88005a183e90, at: [<ffffffff810ab2b8>] complete+0x28/0x60
 #3: held:     (&p->pi_lock){-.-.-.}, instance: ffff88003606cf78, at: [<ffffffff810b37f1>] try_to_wake_up+0x31/0x320
 #4: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810ae169>] ttwu_stat+0x49/0x280

stack backtrace:
Pid: 9822, comm: kworker/2:0 Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ae21c>] ttwu_stat+0xfc/0x280
 [<ffffffff810ae169>] ? ttwu_stat+0x49/0x280
 [<ffffffff810b3950>] try_to_wake_up+0x190/0x320
 [<ffffffff810b3af2>] default_wake_function+0x12/0x20
 [<ffffffff810a8b75>] __wake_up_common+0x55/0x90
 [<ffffffff810ab2b8>] ? complete+0x28/0x60
 [<ffffffff810ab2d7>] complete+0x47/0x60
 [<ffffffff81092422>] wq_barrier_func+0x12/0x20
 [<ffffffff81095a37>] process_one_work+0x207/0x780
 [<ffffffff810959c7>] ? process_one_work+0x197/0x780
 [<ffffffff81092410>] ? destroy_work_on_stack+0x20/0x20
 [<ffffffff81095fdc>] process_scheduled_works+0x2c/0x40
 [<ffffffff8109652a>] worker_thread+0x2fa/0x440
 [<ffffffff81096230>] ? rescuer_thread+0x240/0x240
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
2 locks on stack by trinity-main/9791:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81089031>] ptrace_stop+0xc1/0x280
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088a4e>] do_notify_parent_cldstop+0x2e/0x550

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81088de5>] do_notify_parent_cldstop+0x3c5/0x550
 [<ffffffff81088a4e>] ? do_notify_parent_cldstop+0x2e/0x550
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8108906a>] ptrace_stop+0xfa/0x280
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff81089287>] ptrace_do_notify+0x97/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/signal.c:1756 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by trinity-main/9791:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81089031>] ptrace_stop+0xc1/0x280
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088a4e>] do_notify_parent_cldstop+0x2e/0x550
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088aa3>] do_notify_parent_cldstop+0x83/0x550

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81088ed8>] do_notify_parent_cldstop+0x4b8/0x550
 [<ffffffff81088aa3>] ? do_notify_parent_cldstop+0x83/0x550
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8108906a>] ptrace_stop+0xfa/0x280
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff81089287>] ptrace_do_notify+0x97/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by trinity-main/9791:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81089031>] ptrace_stop+0xc1/0x280
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088a4e>] do_notify_parent_cldstop+0x2e/0x550
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088aa3>] do_notify_parent_cldstop+0x83/0x550

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81088d75>] do_notify_parent_cldstop+0x355/0x550
 [<ffffffff81088aa3>] ? do_notify_parent_cldstop+0x83/0x550
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8108906a>] ptrace_stop+0xfa/0x280
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff81089287>] ptrace_do_notify+0x97/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/signal.c:1756 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by trinity-main/9791:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81089031>] ptrace_stop+0xc1/0x280
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088a4e>] do_notify_parent_cldstop+0x2e/0x550
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff81088b37>] do_notify_parent_cldstop+0x117/0x550

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff81088f18>] do_notify_parent_cldstop+0x4f8/0x550
 [<ffffffff81088b37>] ? do_notify_parent_cldstop+0x117/0x550
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8108906a>] ptrace_stop+0xfa/0x280
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff81089287>] ptrace_do_notify+0x97/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/sched/fair.c:2660 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
5 locks on stack by trinity-main/9791:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81089031>] ptrace_stop+0xc1/0x280
 #1: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff880107520820, at: [<ffffffff81088e16>] do_notify_parent_cldstop+0x3f6/0x550
 #2: held:     (&sig->wait_chldexit){......}, instance: ffff880035679528, at: [<ffffffff810ab327>] __wake_up_sync_key+0x37/0x80
 #3: held:     (&p->pi_lock){-.-.-.}, instance: ffff880035738658, at: [<ffffffff810b37f1>] try_to_wake_up+0x31/0x320
 #4: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff810b97c1>] select_task_rq_fair+0x61/0xad0

stack backtrace:
Pid: 9791, comm: trinity-main Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810ba10c>] select_task_rq_fair+0x9ac/0xad0
 [<ffffffff810b97c1>] ? select_task_rq_fair+0x61/0xad0
 [<ffffffff810de049>] ? put_lock_stats.isra.25+0x29/0x40
 [<ffffffff810b37f1>] ? try_to_wake_up+0x31/0x320
 [<ffffffff810b387e>] try_to_wake_up+0xbe/0x320
 [<ffffffff810b3af2>] default_wake_function+0x12/0x20
 [<ffffffff8107586a>] child_wait_callback+0x5a/0x60
 [<ffffffff810a8b75>] __wake_up_common+0x55/0x90
 [<ffffffff810ab327>] ? __wake_up_sync_key+0x37/0x80
 [<ffffffff810ab343>] __wake_up_sync_key+0x53/0x80
 [<ffffffff81078b36>] __wake_up_parent+0x26/0x30
 [<ffffffff81088e4e>] do_notify_parent_cldstop+0x42e/0x550
 [<ffffffff81088b37>] ? do_notify_parent_cldstop+0x117/0x550
 [<ffffffff8108906a>] ptrace_stop+0xfa/0x280
 [<ffffffff81097e75>] ? __task_pid_nr_ns+0x5/0x1a0
 [<ffffffff81089287>] ptrace_do_notify+0x97/0xb0
 [<ffffffff8108afe4>] ptrace_notify+0x64/0x90
 [<ffffffff8102be46>] tracehook_report_syscall_exit+0x36/0xb0
 [<ffffffff810ab02c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff816ca143>] ? int_very_careful+0x5/0xd
 [<ffffffff8102c269>] syscall_trace_leave+0x79/0x150
 [<ffffffff816ca17f>] int_check_syscall_exit_work+0x34/0x3d

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by strace/1365:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81077402>] do_wait+0xb2/0x370
 #1: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff8801435dce20, at: [<ffffffff8107652d>] wait_consider_task+0x11d/0xf40
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff8107655a>] wait_consider_task+0x14a/0xf40

stack backtrace:
Pid: 1365, comm: strace Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff8107696c>] wait_consider_task+0x55c/0xf40
 [<ffffffff8107655a>] ? wait_consider_task+0x14a/0xf40
 [<ffffffff810774d3>] do_wait+0x183/0x370
 [<ffffffff81078d75>] sys_wait4+0x75/0xf0
 [<ffffffff81075810>] ? task_stopped_code+0x60/0x60
 [<ffffffff816ca088>] tracesys+0xe1/0xe6

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
kernel/exit.c:1350 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by strace/1365:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81077402>] do_wait+0xb2/0x370
 #1: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff8801435dce20, at: [<ffffffff8107652d>] wait_consider_task+0x11d/0xf40
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff8107655a>] wait_consider_task+0x14a/0xf40

stack backtrace:
Pid: 1365, comm: strace Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810765ec>] wait_consider_task+0x1dc/0xf40
 [<ffffffff8107655a>] ? wait_consider_task+0x14a/0xf40
 [<ffffffff810774d3>] do_wait+0x183/0x370
 [<ffffffff81078d75>] sys_wait4+0x75/0xf0
 [<ffffffff81075810>] ? task_stopped_code+0x60/0x60
 [<ffffffff816ca088>] tracesys+0xe1/0xe6

===============================
[ INFO: suspicious RCU usage. ]
3.7.0-rc1+ #31 Not tainted
-------------------------------
include/linux/rcupdate.h:759 rcu_read_unlock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
3 locks on stack by strace/1365:
 #0: held:     (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff81077402>] do_wait+0xb2/0x370
 #1: held:     (&(&sighand->siglock)->rlock){-.-.-.}, instance: ffff8801435dce20, at: [<ffffffff8107652d>] wait_consider_task+0x11d/0xf40
 #2: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c34e80, at: [<ffffffff8107655a>] wait_consider_task+0x14a/0xf40

stack backtrace:
Pid: 1365, comm: strace Not tainted 3.7.0-rc1+ #31
Call Trace:
 [<ffffffff810dfb22>] lockdep_rcu_suspicious+0xe2/0x130
 [<ffffffff810769a5>] wait_consider_task+0x595/0xf40
 [<ffffffff8107655a>] ? wait_consider_task+0x14a/0xf40
 [<ffffffff810774d3>] do_wait+0x183/0x370
 [<ffffffff81078d75>] sys_wait4+0x75/0xf0
 [<ffffffff81075810>] ? task_stopped_code+0x60/0x60
 [<ffffffff816ca088>] tracesys+0xe1/0xe6

