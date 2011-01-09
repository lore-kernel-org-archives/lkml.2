Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1AIWJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:09:48 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44139 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1AIWFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:30 -0500
Message-Id: <20110109220509.104933573@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 06/28] trace event irq remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-irq-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/trace/events/irq.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/trace/events/irq.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/irq.h
+++ linux-2.6-lttng/include/trace/events/irq.h
@@ -6,6 +6,9 @@
 
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_IRQ_DEF_
+#define _TRACE_IRQ_DEF_
+
 struct irqaction;
 struct softirq_action;
 
@@ -23,6 +26,8 @@ struct softirq_action;
 			 softirq_name(HRTIMER),		\
 			 softirq_name(RCU))
 
+#endif /* _TRACE_IRQ_DEF_ */
+
 /**
  * irq_handler_entry - called immediately before the irq action handler
  * @irq: irq number
@@ -51,7 +56,7 @@ TRACE_EVENT(irq_handler_entry,
 	),
 
 	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
-);
+)
 
 /**
  * irq_handler_exit - called immediately after the irq action handler returns
@@ -82,7 +87,7 @@ TRACE_EVENT(irq_handler_exit,
 
 	TP_printk("irq=%d ret=%s",
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
-);
+)
 
 DECLARE_EVENT_CLASS(softirq,
 
@@ -100,7 +105,7 @@ DECLARE_EVENT_CLASS(softirq,
 
 	TP_printk("vec=%u [action=%s]", __entry->vec,
 		  show_softirq_name(__entry->vec))
-);
+)
 
 /**
  * softirq_entry - called immediately before the softirq handler
@@ -114,7 +119,7 @@ DEFINE_EVENT(softirq, softirq_entry,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 /**
  * softirq_exit - called immediately after the softirq handler returns
@@ -128,7 +133,7 @@ DEFINE_EVENT(softirq, softirq_exit,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 /**
  * softirq_raise - called immediately when a softirq is raised
@@ -142,7 +147,7 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 #endif /*  _TRACE_IRQ_H */
 

