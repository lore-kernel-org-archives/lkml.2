Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1AHUQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:16:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AHUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:47 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=hPca7n7jxTsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=c_Elc5ISGXAZvqA5BP0A:9 a=W95kDJ33sygvGjEOizJRF6eHNKgA:4 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201646.033913374@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6/7] tracing: Fix TRACE_EVENT power tracepoint creation
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-TRACE_EVENT-power-tracepoint-creation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
only TRACEPOINTS=y is broken.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20101028153117.GA4051@Krystal>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile       |    1 +
 kernel/trace/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..e0f2831 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53f3381..761c510 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
-obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
-- 
1.7.2.3


