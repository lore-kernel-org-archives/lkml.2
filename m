Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab2IFVAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:00:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2IFVAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:00:31 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tH-HXrYtrmAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2LRdTIhJ_zgA:10 a=kqpEUWfo1TO7OOZDWMUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346965229.1680.48.camel@gandalf.local.home>
Subject: Re: lockdep WARNING on check_critical_timing()
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Thu, 06 Sep 2012 17:00:29 -0400
In-Reply-To: <20120905015937.GA20175@localhost>
References: <20120905015937.GA20175@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 09:59 +0800, Fengguang Wu wrote:
> Greetings,
> 
> This is possibly an aged warning.
> 
>         if (!hardirq_count()) {
>                 if (softirq_count()) {
>                         /* like the above, but with softirqs */
> =>                      DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
> 
> [    3.600059] Testing tracer preemptoff: 
> [    3.760076] ------------[ cut here ]------------
> [    3.760866] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:3506 check_flags+0x125/0x154()
> [    3.762160] Modules linked in:
> [    3.762643] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc3-00013-g01f8a27 #158
> [    3.763679] Call Trace:
> [    3.764053]  [<c1020916>] warn_slowpath_common+0x4d/0x62
> [    3.764838]  [<c105c000>] ? check_flags+0x125/0x154
> [    3.765567]  [<c102093f>] warn_slowpath_null+0x14/0x18
> [    3.766317]  [<c105c000>] check_flags+0x125/0x154
> [    3.766998]  [<c105e02f>] lock_acquire+0x3b/0xef
> [    3.767689]  [<c12461ba>] _raw_spin_lock_irqsave+0x3e/0x4e
> [    3.768494]  [<c12404b8>] ? check_critical_timing+0x112/0x160
> [    3.769340]  [<c12404b8>] check_critical_timing+0x112/0x160
> [    3.770047]  [<c1027474>] ? __do_softirq+0x19b/0x1f9
> [    3.770047]  [<c1027474>] ? __do_softirq+0x19b/0x1f9
> [    3.770047]  [<c1088549>] trace_preempt_on+0x8d/0xc9
> [    3.770047]  [<c1027238>] ? __local_bh_enable+0x87/0x8a
> [    3.770047]  [<c1046c85>] sub_preempt_count+0x7f/0x9c
> [    3.770047]  [<c1027238>] __local_bh_enable+0x87/0x8a
> [    3.770047]  [<c1027474>] __do_softirq+0x19b/0x1f9
> [    3.770047]  [<c10272d9>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
> [    3.770047]  <IRQ>  [<c1027723>] ? irq_exit+0x4f/0xa9
> [    3.770047]  [<c1015e03>] ? smp_apic_timer_interrupt+0x70/0x7e
> [    3.770047]  [<c1246daf>] ? apic_timer_interrupt+0x2f/0x34
> [    3.770047]  [<c108007b>] ? ring_buffer_discard_commit+0x24c/0x24c
> [    3.770047]  [<c1139c87>] ? __const_udelay+0x1/0x1c
> [    3.770047]  [<c108566f>] ? trace_selftest_startup_preemptoff+0x74/0xed
> [    3.770047]  [<c1085b57>] ? register_tracer+0x11c/0x1f7
> [    3.770047]  [<c13c1bf3>] ? init_function_trace+0xf/0xf
> [    3.770047]  [<c13c1c00>] ? init_irqsoff_tracer+0xd/0x11
> [    3.770047]  [<c1001158>] ? do_one_initcall+0x70/0x118
> [    3.770047]  [<c13afa03>] ? kernel_init+0xec/0x169
> [    3.770047]  [<c13af917>] ? start_kernel+0x2f2/0x2f2
> [    3.770047]  [<c124773a>] ? kernel_thread_helper+0x6/0x10
> 

This is the same as a previous bug. It is caused by rcu doing the check
in the function tracer and then triggering a lockdep warning.

Paul,

Didn't we talk about having the rcu_dereference_raw() not do the check?
The function tracer is just too invasive to add work arounds to prevent
lockdep from screaming about it.

-- Steve


