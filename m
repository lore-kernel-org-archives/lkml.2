Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0IEBxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:53:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1378 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0IEBxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:10 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] kernel/trace: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:51 -0700
Message-Id: <3c301ab7b883206341b34562c6101a8b310b7aa2.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7cb1f45..fc9ee37 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1599,7 +1599,7 @@ ftrace_failures_open(struct inode *inode, struct file *file)
 
 	ret = ftrace_avail_open(inode, file);
 	if (!ret) {
-		m = (struct seq_file *)file->private_data;
+		m = file->private_data;
 		iter = (struct ftrace_iterator *)m->private;
 		iter->flags = FTRACE_ITER_FAILURES;
 	}
@@ -2356,7 +2356,7 @@ static void __init set_ftrace_early_filters(void)
 static int
 ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	struct ftrace_iterator *iter;
 	struct trace_parser *parser;
 
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
1.7.2.19.g9a302

