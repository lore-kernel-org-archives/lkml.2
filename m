Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1GEMy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:54:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:59404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:54:58 -0400
Date: Tue, 5 Jul 2011 12:54:39 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-395810627b6a43c8d0ec948884043946fa162308@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20110608070921.17777.31103.stgit@fedora15>
References: <20110608070921.17777.31103.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Swap save_stack_trace_regs parameters
Git-Commit-ID: 395810627b6a43c8d0ec948884043946fa162308
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:54:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  395810627b6a43c8d0ec948884043946fa162308
Gitweb:     http://git.kernel.org/tip/395810627b6a43c8d0ec948884043946fa162308
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 8 Jun 2011 16:09:21 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:51 -0400

x86: Swap save_stack_trace_regs parameters

Swap the 1st and 2nd parameters of save_stack_trace_regs()
as same as the parameters of save_stack_trace_tsk().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/r/20110608070921.17777.31103.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/stacktrace.c  |    2 +-
 arch/x86/mm/kmemcheck/error.c |    2 +-
 include/linux/stacktrace.h    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 55d9bc0..fdd0c64 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -66,7 +66,7 @@ void save_stack_trace(struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
-void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
+void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 {
 	dump_trace(current, regs, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 704a37c..dab4187 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -185,7 +185,7 @@ void kmemcheck_error_save(enum kmemcheck_shadow state,
 	e->trace.entries = e->trace_entries;
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 0;
-	save_stack_trace_regs(&e->trace, regs);
+	save_stack_trace_regs(regs, &e->trace);
 
 	/* Round address down to nearest 16 bytes */
 	shadow_copy = kmemcheck_shadow_lookup(address
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 25310f1..115b570 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -14,8 +14,8 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
-extern void save_stack_trace_regs(struct stack_trace *trace,
-				  struct pt_regs *regs);
+extern void save_stack_trace_regs(struct pt_regs *regs,
+				  struct stack_trace *trace);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
