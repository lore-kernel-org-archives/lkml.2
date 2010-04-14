Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0DNNAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:00:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab0DNNAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:00:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] tracing: adding lost-events option
Date: Wed, 14 Apr 2010 15:00:04 +0200
Message-Id: <1271250005-11434-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
References: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding option for control LOST EVENTS message output.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |    7 +++++--
 kernel/trace/trace.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 60f3b62..bf00438 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -332,7 +332,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_LOST_EVENTS;
 
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
@@ -416,6 +416,7 @@ static const char *trace_options[] = {
 	"latency-format",
 	"sleep-time",
 	"graph-time",
+	"lost-events",
 	NULL
 };
 
@@ -2040,9 +2041,11 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events)
+	if ((trace_flags & TRACE_ITER_LOST_EVENTS) &&
+	    (iter->lost_events)) {
 		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
 				 iter->cpu, iter->lost_events);
+	}
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index bec2c97..4607b43 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -606,6 +606,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x20000,
 	TRACE_ITER_SLEEP_TIME		= 0x40000,
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
+	TRACE_ITER_LOST_EVENTS		= 0x100000,
 };
 
 /*
-- 
1.6.6.1

