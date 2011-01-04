Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab1ADJuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:50:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33397 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1ADJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:50:37 -0500
MIME-Version: 1.0
Date: Tue, 4 Jan 2011 10:50:36 +0100
Message-ID: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
Subject: [PATCH] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find below a proposal for adding new trace events for cpu
hotplug.The goal is to measure the latency of each part (kernel,
architecture and platform) and also to trace the cpu hotplug activity
with other power events. I have tested these traces events on an arm
platform

Comments are welcome.

Date: Wed, 15 Dec 2010 11:22:21 +0100
Subject: [PATCH] hotplug tracepoint

this patch adds new events for cpu hotplug tracing
* plug/unplug sequence
* architecture and machine latency measurements

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
include/trace/events/hotplug.h |   71 ++++++++++++++++++++++++++++++++++++++++
1 files changed, 71 insertions(+), 0 deletions(-)
create mode 100644 include/trace/events/hotplug.h

diff --git a/include/trace/events/hotplug.h b/include/trace/events/hotplug.h
new file mode 100644
index 0000000..51c86ab
--- /dev/null
+++ b/include/trace/events/hotplug.h
@@ -0,0 +1,71 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hotplug
+
+#if !defined(_TRACE_HOTPLUG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HOTPLUG_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+#ifndef _TRACE_HOTPLUG_ENUM_
+#define _TRACE_HOTPLUG_ENUM_
+enum hotplug_type {
+ HOTPLUG_UNPLUG = 0,
+ HOTPLUG_PLUG = 1
+};
+
+enum hotplug_step {
+ HOTPLUG_KERNEL = 0,
+ HOTPLUG_ARCH = 1,
+ HOTPLUG_MACH = 2
+};
+#endif
+
+TRACE_EVENT(hotplug_start,
+
+ TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
+
+ TP_ARGS(type, step, cpuid),
+
+ TP_STRUCT__entry(
+ __field(u32, type)
+ __field(u32, step)
+ __field(u32, cpuid)
+ ),
+
+ TP_fast_assign(
+ __entry->type = type;
+ __entry->step = step;
+ __entry->cpuid = cpuid;
+ ),
+
+ TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
+ (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
+);
+
+TRACE_EVENT(hotplug_end,
+
+ TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
+
+ TP_ARGS(type, step, cpuid),
+
+ TP_STRUCT__entry(
+ __field(u32, type)
+ __field(u32, step)
+ __field(u32, cpuid)
+ ),
+
+ TP_fast_assign(
+ __entry->type = type;
+ __entry->step = step;
+ __entry->cpuid = cpuid;
+ ),
+
+ TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
+ (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
+);
+
+#endif /* _TRACE_HOTPLUG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--
1.7.0.4
