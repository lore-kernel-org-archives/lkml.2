Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1AIWFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:52 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:54231 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1AIWFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:50 -0500
Message-Id: <20110109220512.676811555@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>, Jeremy Kerr <jk@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC patch 28/28] trace event powerpc remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-powerpc-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:13 +0000
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
CC: Anton Blanchard <anton@samba.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Jeremy Kerr <jk@ozlabs.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/trace.h             |   23 +++++++++++++++++------
 arch/powerpc/platforms/cell/spufs/sputrace.h |    2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/include/asm/trace.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/include/asm/trace.h
+++ linux-2.6-lttng/arch/powerpc/include/asm/trace.h
@@ -6,8 +6,13 @@
 
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_POWERPC_DEF_
+#define _TRACE_POWERPC_DEF_
+
 struct pt_regs;
 
+#endif /* _TRACE_POWERPC_DEF_ */
+
 TRACE_EVENT(irq_entry,
 
 	TP_PROTO(struct pt_regs *regs),
@@ -23,7 +28,7 @@ TRACE_EVENT(irq_entry,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(irq_exit,
 
@@ -40,7 +45,7 @@ TRACE_EVENT(irq_exit,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(timer_interrupt_entry,
 
@@ -57,7 +62,7 @@ TRACE_EVENT(timer_interrupt_entry,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(timer_interrupt_exit,
 
@@ -74,12 +79,18 @@ TRACE_EVENT(timer_interrupt_exit,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 #ifdef CONFIG_PPC_PSERIES
+
+#ifndef _TRACE_PPC_PSERIES_DEF_
+#define _TRACE_PPC_PSERIES_DEF_
+
 extern void hcall_tracepoint_regfunc(void);
 extern void hcall_tracepoint_unregfunc(void);
 
+#endif /* _TRACE_PPC_PSERIES_DEF_ */
+
 TRACE_EVENT_FN(hcall_entry,
 
 	TP_PROTO(unsigned long opcode, unsigned long *args),
@@ -97,7 +108,7 @@ TRACE_EVENT_FN(hcall_entry,
 	TP_printk("opcode=%lu", __entry->opcode),
 
 	hcall_tracepoint_regfunc, hcall_tracepoint_unregfunc
-);
+)
 
 TRACE_EVENT_FN(hcall_exit,
 
@@ -119,7 +130,7 @@ TRACE_EVENT_FN(hcall_exit,
 	TP_printk("opcode=%lu retval=%lu", __entry->opcode, __entry->retval),
 
 	hcall_tracepoint_regfunc, hcall_tracepoint_unregfunc
-);
+)
 #endif
 
 #endif /* _TRACE_POWERPC_H */
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sputrace.h
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(spufs_context,
 
 	TP_printk("%s (ctxthread = %d, spu = %d)",
 		__entry->name, __entry->owner_tid, __entry->number)
-);
+)
 
 #define spu_context_trace(name, ctx, spu) \
 	trace_spufs_context(ctx, spu, __stringify(name))

