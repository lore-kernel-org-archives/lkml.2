Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2DIWbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:31:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37543 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2DIWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:31:14 -0400
Date: Mon, 9 Apr 2012 15:31:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: kernel panic on NHM EX machine
Message-ID: <20120409223100.GQ2430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F7ED569.6080103@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7ED569.6080103@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040922-7408-0000-0000-000004140757
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 07:37:13PM +0800, Alex Shi wrote:
> The 3.4-rc1 kernel has a kernel panic in idle booting.
> 
> Actually, from 3.3-rc1 kernel we occasionally find this issue may when
> do busy hackbench testing. but from rc1 kernel it will happens on each
> of rebooting.

Can't say I have seen anything like this in my own testing, though I
did see significant instability in 3.4-rc1.  However, 3.4-rc2 works
much better for me.  Could you please try it out?

							Thanx, Paul

> all Trace:^M
>  <IRQ>  [<ffffffff810a016c>] __rcu_pending+0xbd/0x3bf^M
>  [<ffffffff810a073a>] rcu_check_callbacks+0x69/0xa7^M
>  [<ffffffff81045efb>] update_process_times+0x3a/0x71^M
>  [<ffffffff81078aef>] tick_sched_timer+0x6b/0x95^M
>  [<ffffffff810565e8>] __run_hrtimer+0xb8/0x141^M
>  [<ffffffff81078a84>] ? tick_nohz_handler+0xd3/0xd3^M
>  [<ffffffff81056c7d>] hrtimer_interrupt+0xdb/0x199^M
>  [<ffffffff81077e36>] tick_do_broadcast.constprop.3+0x44/0x88^M
>  [<ffffffff81077fac>] tick_do_periodic_broadcast+0x34/0x3e^M
>  [<ffffffff81077fc5>] tick_handle_periodic_broadcast+0xf/0x40^M
>  [<ffffffff810101b4>] timer_interrupt+0x10/0x17^M
>  [<ffffffff8109ad76>] handle_irq_event_percpu+0x5a/0x199^M
>  [<ffffffff8109aeec>] handle_irq_event+0x37/0x53^M
>  [<ffffffff81028755>] ? ack_apic_edge+0x1f/0x23^M
>  [<ffffffff8109d5e7>] handle_edge_irq+0xa1/0xc8^M
>  [<ffffffff8100fb5e>] handle_irq+0x125/0x12e^M
>  [<ffffffff8103f8c8>] ? irq_enter+0x13/0x64^M
>  [<ffffffff8100f76e>] do_IRQ+0x48/0xa0^M
>  [<ffffffff8145aeea>] common_interrupt+0x6a/0x6a^M
>  [<ffffffff81077fac>] ? tick_do_periodic_broadcast+0x34/0x3e^M
>  [<ffffffff8103ebdb>] ? arch_local_irq_enable+0x8/0xd^M
>  [<ffffffff8103f681>] __do_softirq+0x5e/0x182^M
>  [<ffffffff81078b5e>] ? update_ts_time_stats+0x2c/0x62^M
>  [<ffffffff810622f8>] ? sched_clock_idle_wakeup_event+0x12/0x16^M
>  [<ffffffff8146239c>] call_softirq+0x1c/0x30^M
>  [<ffffffff8100fba8>] do_softirq+0x41/0x7d^M
>  [<ffffffff8103f95d>] irq_exit+0x44/0x9c^M
>  [<ffffffff8105ff70>] scheduler_ipi+0x6b/0x6d^M
>  [<ffffffff81025d8a>] smp_reschedule_interrupt+0x16/0x18^M
>  [<ffffffff81461f4a>] reschedule_interrupt+0x6a/0x70^M
>  <EOI>  [<ffffffff812876fa>] ? arch_local_irq_enable+0x8/0xd^M
>  [<ffffffff810622f8>] ? sched_clock_idle_wakeup_event+0x12/0x16^M
>  [<ffffffff81288356>] acpi_idle_enter_bm+0x222/0x266^M
>  [<ffffffff8138b0df>] cpuidle_enter+0x12/0x14^M
>  [<ffffffff8138b5ab>] cpuidle_idle_call+0xef/0x191^M
>  [<ffffffff81015519>] cpu_idle+0x9e/0xe8^M
>  [<ffffffff814392b9>] rest_init+0x6d/0x6f^M
>  [<ffffffff81015519>] cpu_idle+0x9e/0xe8^M
>  [<ffffffff814392b9>] rest_init+0x6d/0x6f^M
>  [<ffffffff81ad3b7b>] start_kernel+0x3ad/0x3ba^M
>  [<ffffffff81ad34ff>] ? loglevel+0x31/0x31^M
>  [<ffffffff81ad32c3>] x86_64_start_reservations+0xae/0xb2^M
>  [<ffffffff81ad3140>] ? early_idt_handlers+0x140/0x140^M
>  [<ffffffff81ad33c9>] x86_64_start_kernel+0x102/0x111^M
> INFO: task swapper/0:1 blocked for more than 120 seconds.^M
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.^M
> swapper/0       D ffff8810291383b8     0     1      0 0x00000000^M
>  ffff881029133e20 0000000000000046 ffff881029138000 ffff881029133fd8^M
>  ffff881029133fd8 00000000000132c0 ffff8810292b44d0 ffff881029138000^M
>  0000000000000246 0000000000000008 ffffffff81a2b2e0 00000000000000d0^M
> Call Trace:^M
>  [<ffffffff8145a1e4>] schedule+0x5f/0x61^M
>  [<ffffffff8105891a>] async_synchronize_cookie_domain+0xb1/0x10d^M
>  [<ffffffff81053a74>] ? remove_wait_queue+0x35/0x35^M
>  [<ffffffff81058986>] async_synchronize_cookie+0x10/0x12^M
>  [<ffffffff81058998>] async_synchronize_full+0x10/0x2c^M
>  [<ffffffff8145055a>] init_post+0x9/0xc0^M
>  [<ffffffff81ad3d4a>] kernel_init+0x1c2/0x1c2^M
>  [<ffffffff81ad34c6>] ? rdinit_setup+0x28/0x28^M
>  [<ffffffff814622a4>] kernel_thread_helper+0x4/0x10^M
>  [<ffffffff81ad3b88>] ? start_kernel+0x3ba/0x3ba^M
>  [<ffffffff814622a0>] ? gs_change+0x13/0x13^M
> INFO: task kworker/u:0:5 blocked for more than 120 seconds.^M
> 

