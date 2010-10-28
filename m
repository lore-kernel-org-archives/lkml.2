Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab0J1CQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:16:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37917 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932457Ab0J1CQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:16:34 -0400
Date: Wed, 27 Oct 2010 22:16:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
Message-ID: <20101028021632.GA18117@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:15:27 up 35 days,  6:17,  4 users,  load average: 0.53, 0.23,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
only TRACEPOINTS=y is broken.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/Makefile             |    1 +
 kernel/trace/Makefile       |    2 +-
 kernel/trace/power-traces.c |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile
+++ linux-2.6-lttng/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o t
 obj-$(USE_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
+obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
Index: linux-2.6-lttng/kernel/trace/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/Makefile
+++ linux-2.6-lttng/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_eve
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
-obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
Index: linux-2.6-lttng/kernel/trace/power-traces.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/power-traces.c
+++ linux-2.6-lttng/kernel/trace/power-traces.c
@@ -10,8 +10,14 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
+#ifdef CONFIG_EVENT_TRACING
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
+#else
+DEFINE_TRACE(power_start);
+DEFINE_TRACE(power_end);
+DEFINE_TRACE(power_frequency);
+#endif
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
