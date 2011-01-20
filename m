Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1ATIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:25:56 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63083 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1ATIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:25:54 -0500
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 09:25:54 +0100
Message-ID: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
Subject: [PATCH V2] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find below a new proposal for adding trace events for cpu hotplug.
The goal is to measure the latency of each part (kernel, architecture)
and also to trace the cpu hotplug activity with other power events. I
have tested these traces events on an arm platform.

Changes since previous version:
-Use cpu_hotplug for trace name
-Define traces for kernel core and arch parts only
-Use DECLARE_EVENT_CLASS and DEFINE_EVENT
-Use proper indentation

Subject: [PATCH] cpu hotplug tracepoint

this patch adds new events for cpu hotplug tracing
 * plug/unplug sequence
 * core and architecture latency measurements

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.com>
---
 include/trace/events/cpu_hotplug.h |  117 ++++++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/cpu_hotplug.h

diff --git a/include/trace/events/cpu_hotplug.h
b/include/trace/events/cpu_hotplug.h
new file mode 100644
index 0000000..efccc70
--- /dev/null
+++ b/include/trace/events/cpu_hotplug.h
@@ -0,0 +1,117 @@
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
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	cpuid	)
+	),
+
+	TP_fast_assign(
+		__entry->cpuid = cpuid;
+	),
+
+	TP_printk("cpuid=%u", __entry->cpuid)
+);
+
+/* Core function of cpu hotplug */
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+/* Architecture function for cpu hotplug */
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_disable_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_disable_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_die_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_die_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_start,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_end,
+
+	TP_PROTO(unsigned int cpuid),
+
+	TP_ARGS(cpuid)
+);
+
+#endif /* _TRACE_CPU_HOTPLUG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.1
