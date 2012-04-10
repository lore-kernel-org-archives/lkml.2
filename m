Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2DJBFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:05:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:47438 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab2DJBFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128938561"
Message-ID: <4F838734.9090700@intel.com>
Date: Tue, 10 Apr 2012 09:04:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: kernel panic on NHM EX machine
References: <4F7ED569.6080103@intel.com> <20120409223100.GQ2430@linux.vnet.ibm.com>
In-Reply-To: <20120409223100.GQ2430@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 06:31 AM, Paul E. McKenney wrote:

> On Fri, Apr 06, 2012 at 07:37:13PM +0800, Alex Shi wrote:
>> The 3.4-rc1 kernel has a kernel panic in idle booting.
>>
>> Actually, from 3.3-rc1 kernel we occasionally find this issue may when
>> do busy hackbench testing. but from rc1 kernel it will happens on each
>> of rebooting.
> 
> Can't say I have seen anything like this in my own testing, though I
> did see significant instability in 3.4-rc1.  However, 3.4-rc2 works
> much better for me.  Could you please try it out?
> 
> 							Thanx, Paul
> 


Ops, saw it again on rc2 kernel booting.

 <IRQ>  [<ffffffff810a04bc>] __rcu_pending+0xbd/0x3bf
 [<ffffffff810a0a8a>] rcu_check_callbacks+0x69/0xa7
 [<ffffffff81045ffb>] update_process_times+0x3a/0x71
 [<ffffffff81078e63>] tick_sched_timer+0x6b/0x95
 [<ffffffff81056874>] __run_hrtimer+0xb8/0x141
 [<ffffffff81078df8>] ? tick_nohz_handler+0xd3/0xd3
 [<ffffffff81056f09>] hrtimer_interrupt+0xdb/0x199
 [<ffffffff810781aa>] tick_do_broadcast.constprop.3+0x44/0x88
 [<ffffffff81078320>] tick_do_periodic_broadcast+0x34/0x3e
 [<ffffffff81078339>] tick_handle_periodic_broadcast+0xf/0x40
 [<ffffffff810101b4>] timer_interrupt+0x10/0x17
 [<ffffffff8109b0c6>] handle_irq_event_percpu+0x5a/0x199
 [<ffffffff8109b23c>] handle_irq_event+0x37/0x53
 [<ffffffff81028785>] ? ack_apic_edge+0x1f/0x23
 [<ffffffff8109d937>] handle_edge_irq+0xa1/0xc8
 [<ffffffff8100fb5e>] handle_irq+0x125/0x12e
 [<ffffffff8103f9c8>] ? irq_enter+0x13/0x64
 [<ffffffff8100f76e>] do_IRQ+0x48/0xa0
 [<ffffffff8145b8aa>] common_interrupt+0x6a/0x6a
 [<ffffffff81078320>] ? tick_do_periodic_broadcast+0x34/0x3e
 [<ffffffff8103ecdb>] ? arch_local_irq_enable+0x8/0xd
 [<ffffffff8103f781>] __do_softirq+0x5e/0x182
 [<ffffffff81078ed2>] ? update_ts_time_stats+0x2c/0x62
 [<ffffffff8106258c>] ? sched_clock_idle_wakeup_event+0x12/0x16
 [<ffffffff81462d5c>] call_softirq+0x1c/0x30
 [<ffffffff8100fba8>] do_softirq+0x41/0x7d
 [<ffffffff8103fa5d>] irq_exit+0x44/0x9c
 [<ffffffff81060202>] scheduler_ipi+0x6b/0x6d
 [<ffffffff81025dba>] smp_reschedule_interrupt+0x16/0x18
 [<ffffffff8146290a>] reschedule_interrupt+0x6a/0x70
 <EOI>  [<ffffffff812878ff>] ? arch_local_irq_enable+0x8/0xd
 [<ffffffff8106258c>] ? sched_clock_idle_wakeup_event+0x12/0x16
 [<ffffffff81288557>] acpi_idle_enter_bm+0x222/0x266
 [<ffffffff8138b98b>] cpuidle_enter+0x12/0x14
 [<ffffffff8138be61>] cpuidle_idle_call+0xef/0x191
 [<ffffffff81015501>] cpu_idle+0x9e/0xe8
 [<ffffffff81439c99>] rest_init+0x6d/0x6f
 [<ffffffff81ad3b7b>] start_kernel+0x3ad/0x3ba
 [<ffffffff81ad34ff>] ? loglevel+0x31/0x31
 [<ffffffff81ad32c3>] x86_64_start_reservations+0xae/0xb2
 [<ffffffff81ad3140>] ? early_idt_handlers+0x140/0x140
 [<ffffffff81ad33c9>] x86_64_start_kernel+0x102/0x111


