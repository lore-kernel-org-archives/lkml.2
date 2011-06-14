Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1FNIgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:36:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47714 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1FNIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:36:06 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-5c-4df71d72c226
X-AuditID: b753bd60-a0aaaba0000019f4-5c-4df71d72c226
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v3 1/3] [CLEANUP]x86: Swap save_stack_trace_regs
 parameters
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Date: Tue, 14 Jun 2011 16:02:57 +0900
Message-ID: <20110614070257.3628.9833.stgit@fedora15>
In-Reply-To: <20110614070250.3628.94917.stgit@fedora15>
References: <20110614070250.3628.94917.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap the 1st and 2nd parameters of save_stack_trace_regs()
as same as the parameters of save_stack_trace_tsk().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
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
 

