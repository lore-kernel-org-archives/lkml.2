Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0KREJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:09:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0KREJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:09:52 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=fOfxz8kAUuMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=bi5kgkpRTlqL8kwr8_wA:9 a=0SPCMm4_Dyazc8P5ZVQA:7 a=M3N54AeWPsxjRzizxkFH1ZT282kA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101118040949.421839199@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 22:58:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 1/2] [PATCH 1/2] tracing: Rename trace_printk to ftrace_printk
References: <20101118035803.453609353@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Rename-trace_printk-to-ftrace_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In order to make a bit more generic trace_printk(), this patch
simply renames the trace_printk() macro to its original ftrace_printk()
name, since it only writes into the ftrace ring buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b6de9a6..12151e5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -318,11 +318,11 @@ do {									\
 } while (0)
 
 /**
- * trace_printk - printf formatting in the ftrace buffer
+ * ftrace_printk - printf formatting in the ftrace buffer
  * @fmt: the printf format for printing
  *
- * Note: __trace_printk is an internal function for trace_printk and
- *       the @ip is passed in via the trace_printk macro.
+ * Note: __trace_printk is an internal function for ftrace_printk and
+ *       the @ip is passed in via the ftrace_printk macro.
  *
  * This function allows a kernel developer to debug fast path sections
  * that printk is not appropriate for. By scattering in various
@@ -330,11 +330,11 @@ do {									\
  * where problems are occurring.
  *
  * This is intended as a debugging tool for the developer only.
- * Please refrain from leaving trace_printks scattered around in
+ * Please refrain from leaving ftrace_printks scattered around in
  * your code.
  */
 
-#define trace_printk(fmt, args...)					\
+#define ftrace_printk(fmt, args...)					\
 do {									\
 	__trace_printk_check_format(fmt, ##args);			\
 	if (__builtin_constant_p(fmt)) {				\
@@ -383,14 +383,14 @@ __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
 static inline int
-trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
 static inline void trace_dump_stack(void) { }
 static inline int
-trace_printk(const char *fmt, ...)
+ftrace_printk(const char *fmt, ...)
 {
 	return 0;
 }
-- 
1.7.1


