Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0J1PbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:31:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:59192 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752730Ab0J1PbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:31:20 -0400
Date: Thu, 28 Oct 2010 11:31:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arjan van de Ven <arjan@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation (v2)
Message-ID: <20101028153117.GA4051@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:27:06 up 35 days, 19:29,  3 users,  load average: 0.13, 0.13,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
only TRACEPOINTS=y is broken.

Changelog since v1:
- Only change the makefiles, as required.
- Patch based on 2.6.36 mainline kernel.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile       |    1 +
 kernel/trace/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile
+++ linux-2.6-lttng/kernel/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
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
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
