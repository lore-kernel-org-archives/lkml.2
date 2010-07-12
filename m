Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0GLUvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:51:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1799 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0GLUvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 29/36] kernel/trace: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:21 -0700
Message-Id: <9ba657c52c49f10023a45c178e98acf553a68385.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0d88ce9..0691e87 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1592,7 +1592,7 @@ ftrace_failures_open(struct inode *inode, struct file *file)
 
 	ret = ftrace_avail_open(inode, file);
 	if (!ret) {
-		m = (struct seq_file *)file->private_data;
+		m = file->private_data;
 		iter = (struct ftrace_iterator *)m->private;
 		iter->flags = FTRACE_ITER_FAILURES;
 	}
@@ -2349,7 +2349,7 @@ static void __init set_ftrace_early_filters(void)
 static int
 ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	struct ftrace_iterator *iter;
 	struct trace_parser *parser;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8683dec..10b82a1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2257,7 +2257,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 
 static int tracing_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	struct trace_iterator *iter;
 	int cpu;
 
-- 
1.7.1.337.g6068.dirty

