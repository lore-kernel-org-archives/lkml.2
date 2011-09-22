Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1IVWLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:11:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab1IVWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:33 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=1FVFDzT7m-8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=PY17Gt4sfXfoMNNknBEA:9 a=b_Yvu9i6qurNOh7tFbQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221029.409012300@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/21] tracing: Fix preemptirqsoff tracer to not stop at preempt off
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-Fix-preemptirqsoff-tracer-to-not-stop-at-pre.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If irqs are disabled when preemption count reaches zero, the
preemptirqsoff tracer should not flag that as the end.

When interrupts are enabled and preemption count is not zero
the preemptirqsoff correctly continues its tracing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..a1a3359 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -505,13 +505,13 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller);
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		stop_critical_timing(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */
-- 
1.7.5.4


