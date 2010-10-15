Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0JOP2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:28:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:60801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0JOP2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:28:12 -0400
Subject: Re: Proper kernel irq time accounting -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1287155513.29097.1526.camel@twins>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1287155513.29097.1526.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 17:27:31 +0200
Message-ID: <1287156451.29097.1531.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 17:11 +0200, Peter Zijlstra wrote:
> OK, I'll take this, but will frob 4 to simply add PF_KSOFTIRQD.
> 
> We can do all additional changes, possibly including what Eric
> suggested, at a later stage as increments.
> 
> Thanks!

*kablam!*

booting with noirqtime doesn't work either, same explosion.

My patch-stack can be gotten from:

  http://programming.kicks-ass.net/sekrit/patches.tar.bz2




---
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 16441220k/17825792k available (5966k kernel code, 1060600k absent, 323972k reserved, 6084k data, 1652k init)
Hierarchical RCU implementation.
NR_IRQS:4352
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
hpet clockevent registered
------------[ cut here ]------------
WARNING: at /usr/src/linux-2.6/kernel/softirq.c:159 _local_bh_enable_ip+0x49/0xc7()
Hardware name: X8DTN
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.36-rc7-tip-01685-g5131300-dirty #514
Call Trace:
 <IRQ>  [<ffffffff8106cdf8>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8107319f>] ? irq_enter+0x4e/0x7f
 [<ffffffff8106ce2a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810730af>] _local_bh_enable_ip+0x49/0xc7
 [<ffffffff8107314f>] local_bh_enable+0x12/0x14
 [<ffffffff8107319f>] irq_enter+0x4e/0x7f
 [<ffffffff815d07e6>] do_IRQ+0x36/0xc3
 [<ffffffff815ca553>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff815ca1d4>] ? _raw_spin_unlock_irqrestore+0x29/0x2d
 [<ffffffff810b42e6>] __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] x86_64_start_kernel+0xe7/0xee
---[ end trace a7919e7f17c0a725 ]---
------------[ cut here ]------------
WARNING: at /usr/src/linux-2.6/kernel/sched_clock.c:219 sched_clock_cpu+0x31/0xd4()
Hardware name: X8DTN
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc7-tip-01685-g5131300-dirty #514
Call Trace:
 <IRQ>  [<ffffffff8106cdf8>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8106ce2a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff8108ccb4>] sched_clock_cpu+0x31/0xd4
 [<ffffffff810665af>] update_rq_clock+0x28/0xa1
 [<ffffffff81068f7b>] scheduler_tick+0x4d/0x29d
 [<ffffffff8107a145>] update_process_times+0x67/0x77
 [<ffffffff810939f9>] tick_periodic+0x63/0x6f
 [<ffffffff81093a2b>] tick_handle_periodic+0x26/0x73
 [<ffffffff8102e75e>] timer_interrupt+0x1e/0x25
 [<ffffffff810b34d7>] handle_IRQ_event+0x55/0x11d
 [<ffffffff810b570a>] handle_level_irq+0x7b/0xd7
 [<ffffffff8102e0b5>] handle_irq+0x88/0x93
 [<ffffffff815d080c>] do_IRQ+0x5c/0xc3
 [<ffffffff815ca553>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff815ca1d4>] ? _raw_spin_unlock_irqrestore+0x29/0x2d
 [<ffffffff810b42e6>] __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] x86_64_start_kernel+0xe7/0xee
---[ end trace a7919e7f17c0a726 ]---
------------[ cut here ]------------
WARNING: at /usr/src/linux-2.6/kernel/perf_event.c:1656 perf_event_task_tick+0x3c/0x259()
Hardware name: X8DTN
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc7-tip-01685-g5131300-dirty #514
Call Trace:
 <IRQ>  [<ffffffff8106cdf8>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8106ce2a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810d8617>] perf_event_task_tick+0x3c/0x259
 [<ffffffff81069037>] scheduler_tick+0x109/0x29d
 [<ffffffff8107a145>] update_process_times+0x67/0x77
 [<ffffffff810939f9>] tick_periodic+0x63/0x6f
 [<ffffffff81093a2b>] tick_handle_periodic+0x26/0x73
 [<ffffffff8102e75e>] timer_interrupt+0x1e/0x25
 [<ffffffff810b34d7>] handle_IRQ_event+0x55/0x11d
 [<ffffffff810b570a>] handle_level_irq+0x7b/0xd7
 [<ffffffff8102e0b5>] handle_irq+0x88/0x93
 [<ffffffff815d080c>] do_IRQ+0x5c/0xc3
 [<ffffffff815ca553>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff815ca1d4>] ? _raw_spin_unlock_irqrestore+0x29/0x2d
 [<ffffffff810b42e6>] __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] x86_64_start_kernel+0xe7/0xee
---[ end trace a7919e7f17c0a727 ]---
BUG: scheduling while atomic: swapper/0/0x10010000
Modules linked in:
CPU 0 
Modules linked in:

Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc7-tip-01685-g5131300-dirty #514 X8DTN/X8DTN
RIP: 0010:[<ffffffff815ca1d4>]  [<ffffffff815ca1d4>] _raw_spin_unlock_irqrestore+0x29/0x2d
RSP: 0000:ffffffff81a01ea8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a01eb8 RCX: 0000000000000000
RDX: ffffffff81b1e650 RSI: 0000000000000246 RDI: ffffffff81a02284
RBP: ffffffff815ca54e R08: 000000000000001e R09: ffffffff81b22a40
R10: ffffffff81a01e18 R11: 0000000000000004 R12: ffffffff81a01e48
R13: 00000000ffffffff R14: 0000000000000021 R15: ffffffff81e29ace
FS:  0000000000000000(0000) GS:ffff8800bf000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001b13000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81b1b020)
Stack:
 ffffffff81a01eb8 ffffffff81a02200 ffffffff81a01f08 ffffffff810b42e6
<0> 0000000000000008 0000000000000246 ffffffff81a01ee8 0000000000000000
<0> ffffffff81b1e2b0 0000000000000000 ffffffffffffffff 0000000000000000
Call Trace:
 [<ffffffff810b42e6>] ? __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] ? setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] ? setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] ? hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] ? x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] ? start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] ? x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] ? x86_64_start_kernel+0xe7/0xee
Code: c9 c3 55 48 89 e5 53 48 83 ec 08 e8 c7 17 a6 ff 48 89 f3 66 ff 07 f6 c7 02 75 09 56 9d e8 6c f6 af ff eb 07 e8 ca f8 af ff 53 9d <5b> 5b c9 c3 55 48 89 e5 48 83 ec 10 e8 9b 17 a6 ff 48 89 7d f8 
Call Trace:
 [<ffffffff810b42e6>] ? __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] ? setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] ? setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] ? hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] ? x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] ? start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] ? x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] ? x86_64_start_kernel+0xe7/0xee
------------[ cut here ]------------
kernel BUG at /usr/src/linux-2.6/kernel/posix-cpu-timers.c:1312!
invalid opcode: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 0, comm: swapper Tainted: G        W   2.6.36-rc7-tip-01685-g5131300-dirty #514 X8DTN/X8DTN
RIP: 0010:[<ffffffff81089455>]  [<ffffffff81089455>] run_posix_cpu_timers+0x2c/0x61b
RSP: 0000:ffff8800bf003dd8  EFLAGS: 00010202
RAX: 0000000000000296 RBX: ffffffff81b1b020 RCX: 0000000000000000
RDX: ffff8800bf000001 RSI: 0000000000000000 RDI: ffffffff81b1b020
RBP: ffff8800bf003e58 R08: 0000000000000006 R09: 0000ffff00104c10
R10: ffff8800bf003ca4 R11: 0000000000000020 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81a02284
FS:  0000000000000000(0000) GS:ffff8800bf000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001b13000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81b1b020)
Stack:
 0000000000000000 ffffffff81b1b020 ffff8800bf003e18 ffff8800bf011ac0
<0> ffff8800bf003df8 ffff8800bf003df8 ffffffff81b1b020 ffffffff81a02284
<0> ffff8800bf003e58 ffffffff81069037 0000000000000000 ffffffff81b1b020
Call Trace:
 <IRQ> 
 [<ffffffff81069037>] ? scheduler_tick+0x109/0x29d
 [<ffffffff8107a14d>] update_process_times+0x6f/0x77
 [<ffffffff810939f9>] tick_periodic+0x63/0x6f
 [<ffffffff81093a2b>] tick_handle_periodic+0x26/0x73
 [<ffffffff8102e75e>] timer_interrupt+0x1e/0x25
 [<ffffffff810b34d7>] handle_IRQ_event+0x55/0x11d
 [<ffffffff810b570a>] handle_level_irq+0x7b/0xd7
 [<ffffffff8102e0b5>] handle_irq+0x88/0x93
 [<ffffffff815d080c>] do_IRQ+0x5c/0xc3
 [<ffffffff815ca553>] ret_from_intr+0x0/0xf
 <EOI> 
 [<ffffffff815ca1d4>] ? _raw_spin_unlock_irqrestore+0x29/0x2d
 [<ffffffff810b42e6>] __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] x86_64_start_kernel+0xe7/0xee
Code: 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 58 e8 41 25 fa ff 48 8d 45 a0 48 89 fb 48 89 45 a0 48 89 45 a8 9c 58 f6 c4 02 74 04 <0f> 0b eb fe 48 8b 87 08 03 00 00 48 85 c0 0f 85 a9 05 00 00 48 
RIP  [<ffffffff81089455>] run_posix_cpu_timers+0x2c/0x61b
 RSP <ffff8800bf003dd8>
---[ end trace a7919e7f17c0a728 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: swapper Tainted: G      D W   2.6.36-rc7-tip-01685-g5131300-dirty #514
Call Trace:
 <IRQ>  [<ffffffff815c7e4a>] panic+0x91/0x19c
 [<ffffffff8106dd6f>] ? kmsg_dump+0x13b/0x155
 [<ffffffff815cb38c>] oops_end+0xaf/0xbf
 [<ffffffff8102f13d>] die+0x5a/0x63
 [<ffffffff815cad93>] do_trap+0x121/0x130
 [<ffffffff8102d1af>] do_invalid_op+0x94/0x9d
 [<ffffffff81089455>] ? run_posix_cpu_timers+0x2c/0x61b
 [<ffffffff815c9e4d>] ? trace_hardirqs_off_thunk+0x3a/0x6c
 [<ffffffff815ca5d9>] ? irq_return+0x0/0x2
 [<ffffffff8102c895>] invalid_op+0x15/0x20
 [<ffffffff81089455>] ? run_posix_cpu_timers+0x2c/0x61b
 [<ffffffff81069037>] ? scheduler_tick+0x109/0x29d
 [<ffffffff8107a14d>] update_process_times+0x6f/0x77
 [<ffffffff810939f9>] tick_periodic+0x63/0x6f
 [<ffffffff81093a2b>] tick_handle_periodic+0x26/0x73
 [<ffffffff8102e75e>] timer_interrupt+0x1e/0x25
 [<ffffffff810b34d7>] handle_IRQ_event+0x55/0x11d
 [<ffffffff810b570a>] handle_level_irq+0x7b/0xd7
 [<ffffffff8102e0b5>] handle_irq+0x88/0x93
 [<ffffffff815d080c>] do_IRQ+0x5c/0xc3
 [<ffffffff815ca553>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff815ca1d4>] ? _raw_spin_unlock_irqrestore+0x29/0x2d
 [<ffffffff810b42e6>] __setup_irq+0x229/0x2d0
 [<ffffffff810b43b0>] setup_irq+0x23/0x28
 [<ffffffff81bdcfc9>] setup_default_timer_irq+0x12/0x14
 [<ffffffff81bdcfe2>] hpet_time_init+0x17/0x19
 [<ffffffff81bdcfb0>] x86_late_time_init+0xa/0x11
 [<ffffffff81bd9cc7>] start_kernel+0x340/0x3df
 [<ffffffff81bd92a8>] x86_64_start_reservations+0xb8/0xbc
 [<ffffffff81bd9393>] x86_64_start_kernel+0xe7/0xee


