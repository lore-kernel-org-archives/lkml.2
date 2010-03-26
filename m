Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0CZMcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0CZMcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:32:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv3 2/2] tracing: graph output support for preemptirqsoff/preemptoff tracers
Date: Fri, 26 Mar 2010 13:32:03 +0100
Message-Id: <1269606723-12439-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
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
index 2b67e35..d036b8d 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -605,9 +605,17 @@ static struct tracer preemptoff_tracer __read_mostly =
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
@@ -633,9 +641,17 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
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

