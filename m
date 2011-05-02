Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab1EBWEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758707Ab1EBWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:20 -0400
Message-Id: <20110502213211.465572692@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 02/32] trace event sample remove semicolons, specify need for ifdef around declarations
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-sample-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Protecting declarations with ifndef _TRACE_SAMPLE_DEF_ is required if we want to
ensure that, e.g., structure forward declarations do not generate extra
semicolons. It's already needed for enumerations and static inline functions
declarations, but not documented, so document it here.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 samples/trace_events/trace-events-sample.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/samples/trace_events/trace-events-sample.h
===================================================================
--- linux-2.6-lttng.orig/samples/trace_events/trace-events-sample.h
+++ linux-2.6-lttng/samples/trace_events/trace-events-sample.h
@@ -41,6 +41,18 @@
  */
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_SAMPLE_DEF_
+#define _TRACE_SAMPLE_DEF_
+
+/*
+ * All static inline functions, enumerations, types and structures declarations,
+ * as well as structure forward declarations, should be surrounded by
+ * _TRACE_SAMPLE_DEF_ preprocessor idefs (where SAMPLE is the name of the trace
+ * system).
+ */
+
+#endif /* _TRACE_SAMPLE_DEF_ */
+
 /*
  * The TRACE_EVENT macro is broken up into 5 parts.
  *
@@ -91,7 +103,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_printk("foo %s %d", __entry->foo, __entry->bar)
-);
+)
 #endif
 
 /***** NOTICE! The #if protection ends here. *****/

