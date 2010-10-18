Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab0JRUdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:33:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab0JRUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:32:50 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=yNjPgv_vG50A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=bv03cLEAAAAA:8 a=meVymXHHAAAA:8 a=2329B2ElUEvuWOprjmMA:9 a=cet0QK3fV4xtpJMdHMxRV0jRKx4A:4 a=qZ3vZ2issHgA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101018203247.348395777@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 18 Oct 2010 16:29:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        matt mooney <mfm@muteddisk.com>
Subject: [PATCH 1/7] tracing/trivial: Remove cast from void*
References: <20101018202939.828061748@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-trivial-Remove-cast-from-void.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Unnecessary cast from void* in assignment.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 65fb077..ebd80d5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1638,8 +1638,8 @@ ftrace_failures_open(struct inode *inode, struct file *file)
 
 	ret = ftrace_avail_open(inode, file);
 	if (!ret) {
-		m = (struct seq_file *)file->private_data;
-		iter = (struct ftrace_iterator *)m->private;
+		m = file->private_data;
+		iter = m->private;
 		iter->flags = FTRACE_ITER_FAILURES;
 	}
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9ec59f5..001bcd2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2196,7 +2196,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 
 static int tracing_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	struct trace_iterator *iter;
 	int cpu;
 
-- 
1.7.1


