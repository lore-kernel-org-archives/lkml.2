Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0IJNfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:35:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:55458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab0IJNfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:35:11 -0400
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
In-Reply-To: <1284118900.402.35.camel@laptop>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 15:34:53 +0200
Message-ID: <1284125693.402.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 13:41 +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
> > Fixes to allow unknown nmis to pass through the perf nmi handler instead
> > of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> > here for completeness.  Based on ingo/tip

> Both Ingo and I are getting Dazed and confused on our AMD machines, it
> started before yesterday (that is, after backing out all my recent
> changes it still gets dazed), so I suspect this set.
> 
> I'll look at getting a trace of the thing, but if any of you has a
> bright idea...


           <...>-2155  [000]    57.298895: perf_event_nmi_handler: NMI-handled(1): 5735 0 0
           <...>-2155  [000]    57.298896: perf_event_nmi_handler: NMI-stop: 5735 0 0
           <...>-2155  [000]    57.298898: perf_event_nmi_handler: NMI: 5736 0 0
           <...>-2155  [000]    57.298898: x86_pmu_handle_irq: OVERFLOW: 0
           <...>-2155  [000]    57.298899: x86_pmu_handle_irq: HANDLED: 1
           <...>-2155  [000]    57.298901: x86_pmu_handle_irq: OVERFLOW: 2
           <...>-2155  [000]    57.298901: x86_pmu_handle_irq: OVERFLOW: 3
           <...>-2155  [000]    57.298902: perf_event_nmi_handler: NMI-handled(1): 5736 0 0
           <...>-2155  [000]    57.298903: perf_event_nmi_handler: NMI-stop: 5736 0 0
           <...>-2155  [000]    57.298905: perf_event_nmi_handler: NMI: 5737 0 0
           <...>-2155  [000]    57.298905: x86_pmu_handle_irq: OVERFLOW: 0
           <...>-2155  [000]    57.298906: x86_pmu_handle_irq: HANDLED: 1
           <...>-2155  [000]    57.298908: x86_pmu_handle_irq: OVERFLOW: 2
           <...>-2155  [000]    57.298908: x86_pmu_handle_irq: OVERFLOW: 3
           <...>-2155  [000]    57.298909: perf_event_nmi_handler: NMI-handled(1): 5737 0 0
           <...>-2155  [000]    57.298909: perf_event_nmi_handler: NMI-stop: 5737 0 0
           <...>-2155  [000]    57.298911: perf_event_nmi_handler: NMI: 5738 0 0
           <...>-2155  [000]    57.298912: x86_pmu_handle_irq: OVERFLOW: 0
           <...>-2155  [000]    57.298913: x86_pmu_handle_irq: HANDLED: 1
           <...>-2155  [000]    57.298915: x86_pmu_handle_irq: OVERFLOW: 2
           <...>-2155  [000]    57.298916: x86_pmu_handle_irq: OVERFLOW: 3
           <...>-2155  [000]    57.298916: perf_event_nmi_handler: NMI-handled(1): 5738 0 0
           <...>-2155  [000]    57.298917: perf_event_nmi_handler: NMI-stop: 5738 0 0
           <...>-2155  [000]    57.298919: perf_event_nmi_handler: NMI: 5739 0 0
           <...>-2155  [000]    57.298920: x86_pmu_handle_irq: OVERFLOW: 0
           <...>-2155  [000]    57.298921: x86_pmu_handle_irq: OVERFLOW: 2
           <...>-2155  [000]    57.298921: x86_pmu_handle_irq: OVERFLOW: 3
           <...>-2155  [000]    57.298922: perf_event_nmi_handler: NMI-handled(0): 5739 0 0
           <...>-2155  [000]    57.298923: perf_event_nmi_handler: NMI: 5739 0 0
           <...>-2155  [000]    57.298924: x86_pmu_handle_irq: OVERFLOW: 0
           <...>-2155  [000]    57.298925: x86_pmu_handle_irq: OVERFLOW: 2
           <...>-2155  [000]    57.298925: x86_pmu_handle_irq: OVERFLOW: 3
           <...>-2155  [000]    57.298926: perf_event_nmi_handler: NMI-handled(0): 5739 0 0
           <...>-2155  [000]    57.298927: perf_event_nmi_handler: NMI: 5739 0 0
           <...>-2155  [000]    57.298928: perf_event_nmi_handler: NMI-fail


Which suggests that 5738 was a good NMI, 5739 is an unhandled NMI, we
see it twice, once through DIE_NMI once through DIE_NMIUNKNOWN.

The problem seems to be that we don't tag it because handled isn't
larger than 1.

Its easy to reproduce on my opteron, simply run: 
  pref record -fg ./hackbench 50
a few times.

I'll try and reset the PMU on init to clear some of those OVERFLOW msgs
(hmm, maybe also read the ctrl word and check EN and INT before doing
the overflow check)..

---
 arch/x86/kernel/cpu/perf_event.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index de6569c..9aff608 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1127,6 +1127,15 @@ static void x86_pmu_disable(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
+static int pmc_overflow(int idx)
+{
+	u64 val;
+
+	rdmsrl(x86_pmu.perfctr + idx, val);
+
+	return !!(val & (1ULL << (x86_pmu.cntval_bits - 1)));
+}
+
 static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
@@ -1141,6 +1150,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (pmc_overflow(idx))
+			trace_printk("OVERFLOW: %d\n", idx);
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -1154,6 +1165,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		/*
 		 * event overflow
 		 */
+		trace_printk("HANDLED: %d\n", idx);
 		handled++;
 		data.period	= event->hw.last_period;
 
@@ -1215,6 +1227,11 @@ perf_event_nmi_handler(struct notifier_block *self,
 	unsigned int this_nmi;
 	int handled;
 
+	trace_printk("NMI: %d %d %d\n",
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
 
@@ -1224,9 +1241,12 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked) {
+			trace_printk("NMI-fail\n");
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
+		}
+		trace_printk("NMI-consume\n");
 		/*
 		 * This one is a PMU back-to-back nmi. Two events
 		 * trigger 'simultaneously' raising two back-to-back
@@ -1242,6 +1262,13 @@ perf_event_nmi_handler(struct notifier_block *self,
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	handled = x86_pmu.handle_irq(args->regs);
+
+	trace_printk("NMI-handled(%d): %d %d %d\n",
+			handled,
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	if (!handled)
 		return NOTIFY_DONE;
 
@@ -1264,6 +1291,11 @@ perf_event_nmi_handler(struct notifier_block *self,
 		__get_cpu_var(pmu_nmi).handled	= handled;
 	}
 
+	trace_printk("NMI-stop: %d %d %d\n",
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	return NOTIFY_STOP;
 }
 

