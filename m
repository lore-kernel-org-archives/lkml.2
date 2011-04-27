Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1D0EtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:49:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58762 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1D0EtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:49:08 -0400
X-Nat-Received: from [202.181.97.72]:54244 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303879745.30548
Message-Id: <201104270449.p3R4n54n023453@www262.sakura.ne.jp>
Subject: [2.6.39-rc4, x86_32] Stall at default_idle()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 13:49:05 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 27042011 #5343089, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get stalls at default_idle(). I feel I didn't get this problem until 2.6.38.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.39-rc4 .

[  119.510327] BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
[  119.510400] Modules linked in: ipv6 ccsecurity pcnet32
[  119.510400] irq event stamp: 763400
[  119.510400] hardirqs last  enabled at (763397): [<c1009ef2>] default_idle+0x32/0x60
[  119.510400] hardirqs last disabled at (763398): [<c138a47c>] apic_timer_interrupt+0x28/0x34
[  119.510400] softirqs last  enabled at (763400): [<c104418d>] _local_bh_enable+0xd/0x10
[  119.510400] softirqs last disabled at (763399): [<c10444a5>] irq_enter+0x45/0x50
[  119.510400] Modules linked in: ipv6 ccsecurity pcnet32
[  119.510400] 
[  119.510400] Pid: 0, comm: swapper Not tainted 2.6.39-rc4-ccs #5 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[  119.510400] EIP: 0060:[<c1009ef4>] EFLAGS: 00000216 CPU: 0
[  119.510400] EIP is at default_idle+0x34/0x60
[  119.510400] EAX: 00000006 EBX: 00000000 ECX: 00000001 EDX: c148c9d8
[  119.510400] ESI: c148c9d8 EDI: c152e000 EBP: c152df8c ESP: c152df8c
[  119.510400]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  119.510400] Process swapper (pid: 0, ti=c152c000 task=c15407a0 task.ti=c152c000)
[  119.510400] Stack:
[  119.510400]  c152df9c c100170a 00000002 c148c9d8 c152dfc4 c1374641 00000002 00000001
[  119.510400]  00000000 c13745a0 00000000 c148c9d8 c152dfc4 00000000 c152dfdc c157882b
[  119.510400]  000000b5 c1578280 c152dfdc c15b25a0 c152dff8 c1578094 1fee0000 00000000
[  119.510400] Call Trace:
[  119.510400]  [<c100170a>] cpu_idle+0x5a/0xa0
[  119.510400]  [<c1374641>] rest_init+0xa1/0xb0
[  119.510400]  [<c13745a0>] ? klist_next+0xc0/0xc0
[  119.510400]  [<c157882b>] start_kernel+0x20b/0x2a0
[  119.510400]  [<c1578280>] ? loglevel+0x20/0x20
[  119.510400]  [<c1578094>] i386_start_kernel+0x64/0xb0
[  119.510400] Code: c0 75 44 80 3d e5 4e 57 c1 00 74 3b 89 e0 25 00 e0 ff ff 83 60 0c fb 0f ae f0 8d 76 00 8b 40 08 a8 08 75 15 e8 3e 39 06 00 fb f4 
[  119.510400]  e0 25 00 e0 ff ff 83 48 0c 04 90 5d c3 e8 29 39 06 00 fb eb 
[  119.510400] Call Trace:
[  119.510400]  [<c100170a>] cpu_idle+0x5a/0xa0
[  119.510400]  [<c1374641>] rest_init+0xa1/0xb0
[  119.510400]  [<c13745a0>] ? klist_next+0xc0/0xc0
[  119.510400]  [<c157882b>] start_kernel+0x20b/0x2a0
[  119.510400]  [<c1578280>] ? loglevel+0x20/0x20
[  119.510400]  [<c1578094>] i386_start_kernel+0x64/0xb0
[  119.510400] Kernel panic - not syncing: softlockup: hung tasks
[  119.510400] Pid: 0, comm: swapper Not tainted 2.6.39-rc4-ccs #5
[  119.510400] Call Trace:
[  119.510400]  [<c103e0b3>] panic+0x63/0x170
[  119.510400]  [<c108c394>] watchdog_timer_fn+0x134/0x140
[  119.510400]  [<c108c260>] ? watchdog_interrupt_count+0x10/0x10
[  119.510400]  [<c105d1eb>] __run_hrtimer+0x5b/0x110
[  119.510400]  [<c105d321>] hrtimer_run_queues+0x71/0xb0
[  119.510400]  [<c104aba8>] run_local_timers+0x8/0x20
[  119.510400]  [<c104a9cf>] update_process_times+0x2f/0x70
[  119.510400]  [<c10686d5>] tick_periodic+0x25/0x80
[  119.510400]  [<c1068749>] tick_handle_periodic+0x19/0x80
[  119.510400]  [<c101d923>] local_apic_timer_interrupt+0x53/0x60
[  119.510400]  [<c104418d>] ? _local_bh_enable+0xd/0x10
[  119.510400]  [<c101d95e>] smp_apic_timer_interrupt+0x2e/0x40
[  119.510400]  [<c138a483>] apic_timer_interrupt+0x2f/0x34
[  119.510400]  [<c1009ef4>] ? default_idle+0x34/0x60
[  119.510400]  [<c100170a>] cpu_idle+0x5a/0xa0
[  119.510400]  [<c1374641>] rest_init+0xa1/0xb0
[  119.510400]  [<c13745a0>] ? klist_next+0xc0/0xc0
[  119.510400]  [<c157882b>] start_kernel+0x20b/0x2a0
[  119.510400]  [<c1578280>] ? loglevel+0x20/0x20
[  119.510400]  [<c1578094>] i386_start_kernel+0x64/0xb0
[  119.510400] ------------[ cut here ]------------
[  119.510400] WARNING: at kernel/lockdep.c:2339 trace_hardirqs_on_caller+0x157/0x1b0()
[  119.510400] Hardware name: VMware Virtual Platform
[  119.510400] Modules linked in: ipv6 ccsecurity pcnet32
[  119.510400] Pid: 0, comm: swapper Not tainted 2.6.39-rc4-ccs #5
[  119.510400] Call Trace:
[  119.510400]  [<c106d7d7>] ? trace_hardirqs_on_caller+0x157/0x1b0
[  119.510400]  [<c103e50c>] warn_slowpath_common+0x7c/0xa0
[  119.510400]  [<c106d7d7>] ? trace_hardirqs_on_caller+0x157/0x1b0
[  119.510400]  [<c103e12d>] ? panic+0xdd/0x170
[  119.510400]  [<c103e5cd>] warn_slowpath_null+0x1d/0x40
[  119.510400]  [<c106d7d7>] trace_hardirqs_on_caller+0x157/0x1b0
[  119.510400]  [<c106d83b>] trace_hardirqs_on+0xb/0x10
[  119.510400]  [<c103e12d>] panic+0xdd/0x170
[  119.510400]  [<c108c394>] watchdog_timer_fn+0x134/0x140
[  119.510400]  [<c108c260>] ? watchdog_interrupt_count+0x10/0x10
[  119.510400]  [<c105d1eb>] __run_hrtimer+0x5b/0x110
[  119.510400]  [<c105d321>] hrtimer_run_queues+0x71/0xb0
[  119.510400]  [<c104aba8>] run_local_timers+0x8/0x20
[  119.510400]  [<c104a9cf>] update_process_times+0x2f/0x70
[  119.510400]  [<c10686d5>] tick_periodic+0x25/0x80
[  119.510400]  [<c1068749>] tick_handle_periodic+0x19/0x80
[  119.510400]  [<c101d923>] local_apic_timer_interrupt+0x53/0x60
[  119.510400]  [<c104418d>] ? _local_bh_enable+0xd/0x10
[  119.510400]  [<c101d95e>] smp_apic_timer_interrupt+0x2e/0x40
[  119.510400]  [<c138a483>] apic_timer_interrupt+0x2f/0x34
[  119.510400]  [<c1009ef4>] ? default_idle+0x34/0x60
[  119.510400]  [<c100170a>] cpu_idle+0x5a/0xa0
[  119.510400]  [<c1374641>] rest_init+0xa1/0xb0
[  119.510400]  [<c13745a0>] ? klist_next+0xc0/0xc0
[  119.510400]  [<c157882b>] start_kernel+0x20b/0x2a0
[  119.510400]  [<c1578280>] ? loglevel+0x20/0x20
[  119.510400]  [<c1578094>] i386_start_kernel+0x64/0xb0
[  119.510400] ---[ end trace f4f0fc0a864fc434 ]---

void default_idle(void)
{
	if (hlt_use_halt()) {
		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
		trace_cpu_idle(1, smp_processor_id());
		current_thread_info()->status &= ~TS_POLLING;
		/*
		 * TS_POLLING-cleared state must be visible before we
		 * test NEED_RESCHED:
		 */
		smp_mb();

		if (!need_resched())
			safe_halt();    /* enables interrupts racelessly */
		else
			local_irq_enable();
		current_thread_info()->status |= TS_POLLING;
		trace_power_end(smp_processor_id());
		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
	} else {
		local_irq_enable();
		/* loop is done by the caller */
		cpu_relax();
	}
}

default_idle+0x32/0x60 is "sti", +0x33 is "hlt", +0x34 is current_thread_info().

00000780 <default_idle>:
 780:   55                      push   %ebp
 781:   a1 3c 00 00 00          mov    0x3c,%eax
 786:   89 e5                   mov    %esp,%ebp
 788:   85 c0                   test   %eax,%eax
 78a:   75 44                   jne    7d0 <default_idle+0x50>
 78c:   80 3d 05 00 00 00 00    cmpb   $0x0,0x5
 793:   74 3b                   je     7d0 <default_idle+0x50>

/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
        return (struct thread_info *)
 795:   89 e0                   mov    %esp,%eax
 797:   25 00 e0 ff ff          and    $0xffffe000,%eax
 79c:   83 60 0c fb             andl   $0xfffffffb,0xc(%eax)
 7a0:   f0 83 44 24 00 00       lock addl $0x0,0x0(%esp)
}

static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
{
        return ((1UL << (nr % BITS_PER_LONG)) &
 7a6:   8b 40 08                mov    0x8(%eax),%eax
        return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
}

static inline int need_resched(void)
{
 7a9:   a8 08                   test   $0x8,%al
 7ab:   75 15                   jne    7c2 <default_idle+0x42>
 7ad:   e8 fc ff ff ff          call   7ae <default_idle+0x2e>
}

static inline void native_safe_halt(void)
{
        asm volatile("sti; hlt": : :"memory");
 7b2:   fb                      sti
 7b3:   f4                      hlt

/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
        return (struct thread_info *)
 7b4:   89 e0                   mov    %esp,%eax
 7b6:   25 00 e0 ff ff          and    $0xffffe000,%eax
 7bb:   83 48 0c 04             orl    $0x4,0xc(%eax)
 7bf:   90                      nop
 7c0:   5d                      pop    %ebp
 7c1:   c3                      ret
 7c2:   e8 fc ff ff ff          call   7c3 <default_idle+0x43>
}

static inline void native_irq_enable(void)
{
        asm volatile("sti": : :"memory");
 7c7:   fb                      sti
 7c8:   eb ea                   jmp    7b4 <default_idle+0x34>
 7ca:   8d b6 00 00 00 00       lea    0x0(%esi),%esi
 7d0:   e8 fc ff ff ff          call   7d1 <default_idle+0x51>
}

static inline void native_irq_enable(void)
{
        asm volatile("sti": : :"memory");
 7d5:   fb                      sti

/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
static inline void rep_nop(void)
{
        asm volatile("rep; nop" ::: "memory");
 7d6:   f3 90                   pause
 7d8:   eb e6                   jmp    7c0 <default_idle+0x40>
 7da:   8d b6 00 00 00 00       lea    0x0(%esi),%esi

000007e0 <stop_this_cpu>:
 7e0:   55                      push   %ebp
 7e1:   89 e5                   mov    %esp,%ebp
}

Something bad is happening with tsk_is_polling() == false state?

Regards.
