Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1FCOU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab1FCOUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:20:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/5] tracing, function_graph: Remove lock-depth from latency trace
Date: Fri,  3 Jun 2011 16:20:02 +0200
Message-Id: <1307110803-9476-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
References: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_depth was removed in commit
e6e1e25 tracing: Remove lock_depth from event entry

Removing the lock_depth info from function_graph latency header.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 44b955f..1da5b97 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1298,8 +1298,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
 	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
 	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
 	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
-	seq_printf(s, "#%.*s||| / _-=> lock-depth      \n", size, spaces);
-	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
+	seq_printf(s, "#%.*s||| /                      \n", size, spaces);
 }
 
 static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
@@ -1318,7 +1317,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
@@ -1332,7 +1331,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
-- 
1.7.1

