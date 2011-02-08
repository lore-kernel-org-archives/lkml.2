Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1BHCBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:01:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1BHB7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:34 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=LEY5s7iUuTEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=qBridlowEC7i1JFuPREA:9 a=x_kXolKHhVnJJnVafGP3dLQHRD8A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015933.723698466@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 11/14] tracing/filter: Move MAX_FILTER_PRED to local tracing directory
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-filter-Move-MAX_FILTER_PRED-to-local-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The MAX_FILTER_PRED is only needed by the kernel/trace/*.c files.
Move it to kernel/trace/trace.h.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 -
 kernel/trace/trace.h         |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47e3997..1a99e79 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -208,7 +208,6 @@ struct ftrace_event_call {
 
 #define PERF_MAX_TRACE_SIZE	2048
 
-#define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
 extern void destroy_preds(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d754330..fbff872 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,8 @@ struct event_subsystem {
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
 
+#define MAX_FILTER_PRED		32
+
 struct filter_pred;
 struct regex;
 
-- 
1.7.2.3


