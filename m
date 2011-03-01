Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1CAQGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:06:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40837 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab1CAQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:06:13 -0500
MIME-Version: 1.0
Date: Tue, 1 Mar 2011 17:06:12 +0100
Message-ID: <AANLkTi=YOqnwchU85UUz+T3z5BSuXswK67+FYNd_HONS@mail.gmail.com>
Subject: [PATCH V6 1/2] tracing, perf: cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define new events for tracing cpu hotplug
 * trace time spent in core and arch dependant code
 * trace the state of cpu

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/trace/events/cpu_hotplug.h |  103 ++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/cpu_hotplug.h

diff --git a/include/trace/events/cpu_hotplug.h
b/include/trace/events/cpu_hotplug.h
new file mode 100644
index 0000000..54a7f97
--- /dev/null
+++ b/include/trace/events/cpu_hotplug.h
@@ -0,0 +1,103 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cpu_hotplug
+
+#if !defined(_TRACE_CPU_HOTPLUG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CPU_HOTPLUG_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(cpu_hotplug,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid),
+
+       TP_STRUCT__entry(
+               __field(        unsigned int,   cpuid   )
+       ),
+
+       TP_fast_assign(
+               __entry->cpuid = cpuid;
+       ),
+
+       TP_printk("cpuid=%u", __entry->cpuid)
+);
+
+/* Core function of cpu hotplug */
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_start,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_end,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_start,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_end,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+/* Architecture function for cpu hotplug */
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_disable_start,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_disable_end,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_die_start,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_die_end,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_start,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_end,
+
+       TP_PROTO(unsigned int cpuid),
+
+       TP_ARGS(cpuid)
+);
+
+#endif /* _TRACE_CPU_HOTPLUG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.1
