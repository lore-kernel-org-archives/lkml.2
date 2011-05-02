Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab1EBWER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532Ab1EBWEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:15 -0400
Message-Id: <20110502213214.374715173@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Stone <jistone@redhat.com>
Subject: [RFC patch 19/32] trace event syscalls remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-syscalls-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:14 +0000
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
CC: Josh Stone <jistone@redhat.com>
---
 include/trace/events/syscalls.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/trace/events/syscalls.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/syscalls.h
+++ linux-2.6-lttng/include/trace/events/syscalls.h
@@ -13,9 +13,14 @@
 
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
+#ifndef _TRACE_SYSCALLS_DEF_
+#define _TRACE_SYSCALLS_DEF_
+
 extern void syscall_regfunc(void);
 extern void syscall_unregfunc(void);
 
+#endif /* _TRACE_SYSCALLS_DEF_ */
+
 TRACE_EVENT_FN(sys_enter,
 
 	TP_PROTO(struct pt_regs *regs, long id),
@@ -38,7 +43,7 @@ TRACE_EVENT_FN(sys_enter,
 		  __entry->args[3], __entry->args[4], __entry->args[5]),
 
 	syscall_regfunc, syscall_unregfunc
-);
+)
 
 TRACE_EVENT_FLAGS(sys_enter, TRACE_EVENT_FL_CAP_ANY)
 
@@ -62,7 +67,7 @@ TRACE_EVENT_FN(sys_exit,
 		  __entry->id, __entry->ret),
 
 	syscall_regfunc, syscall_unregfunc
-);
+)
 
 TRACE_EVENT_FLAGS(sys_exit, TRACE_EVENT_FL_CAP_ANY)
 

