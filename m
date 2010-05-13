Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0EMBXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:23:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab0EMBXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:23:06 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=hneXrhWfV3sA:10 a=UBIxAjGgU1YA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=EgHVP9fA4_CX-v-U6FkA:9 a=Sab4LJL8xrfGsYqM01gA:7 a=m9laMVuNjbiGMLuEwQbBjp004xEA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513012302.741810896@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 21:21:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] tracing: Update branch trace to new event API
References: <20100513012110.558313399@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Update-branch-trace-to-new-event-API.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The branch tracer was not updated with the updates to shrink
TRACE_EVENT(). Although the branch tracer does not use TRACE_EVENT()
some of the API changes caused it to fail to compile.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index b9bc4d4..8d3538b 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -143,7 +143,7 @@ static void branch_trace_reset(struct trace_array *tr)
 }
 
 static enum print_line_t trace_branch_print(struct trace_iterator *iter,
-					    int flags)
+					    int flags, struct trace_event *event)
 {
 	struct trace_branch *field;
 
@@ -167,9 +167,13 @@ static void branch_print_header(struct seq_file *s)
 		"    |\n");
 }
 
+static struct trace_event_functions trace_branch_funcs = {
+	.trace		= trace_branch_print,
+};
+
 static struct trace_event trace_branch_event = {
 	.type		= TRACE_BRANCH,
-	.trace		= trace_branch_print,
+	.funcs		= &trace_branch_funcs,
 };
 
 static struct tracer branch_trace __read_mostly =
-- 
1.7.0


