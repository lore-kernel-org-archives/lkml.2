Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0C2Le6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:34:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0C2Le4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:34:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv4 2/2] tracing: graph output support for preemptirqsoff/preemptoff tracers
Date: Mon, 29 Mar 2010 13:34:36 +0200
Message-Id: <1269862476-4368-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1269862476-4368-1-git-send-email-jolsa@redhat.com>
References: <1269862476-4368-1-git-send-email-jolsa@redhat.com>
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
index ce32a13..223fa7c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -615,9 +615,17 @@ static struct tracer preemptoff_tracer __read_mostly =
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
@@ -643,9 +651,17 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
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

