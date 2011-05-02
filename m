Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab1EBWEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab1EBWEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:12 -0400
Message-Id: <20110502213212.016163484@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 05/32] trace event irq remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-irq-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:12 +0000
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
 

