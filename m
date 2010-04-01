Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0DAQUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0DAQUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:20:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv5 4/4] tracing: graph output support for preemptirqsoff/preemptoff tracers
Date: Thu,  1 Apr 2010 17:37:09 +0200
Message-Id: <1270136229-15263-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1270136229-15263-1-git-send-email-jolsa@redhat.com>
References: <1270136229-15263-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding support for graph output for preemptirqsoff/preemptoff tracers.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_irqsoff.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 1418354..fd57bd5 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -664,9 +664,17 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
+#endif
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -692,9 +700,17 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
+#endif
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
-- 
1.6.6.1

