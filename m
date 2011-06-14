Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1FNIgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:36:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43674 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1FNIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:36:11 -0400
X-AuditID: b753bd60-a0ac3ba000003bac-64-4df71d78229a
X-AuditID: b753bd60-a0ac3ba000003bac-64-4df71d78229a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v3 2/3] Add weak save_stack_trace_regs()
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
Date: Tue, 14 Jun 2011 16:03:05 +0900
Message-ID: <20110614070305.3628.24629.stgit@fedora15>
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

Add weak symbol of save_stack_trace_regs() as same as
save_stack_trace_tsk() since that is not implemented
except x86 yet. This also removes useless KERN_INFO
for WARN_ONCE from save_stack_trace_tsk().

Changes in V3:
- Remvoe KERN_INFO from WARN_ONCE

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
---

 kernel/stacktrace.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index eb212f8..88af597 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -26,12 +26,18 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
 /*
- * Architectures that do not implement save_stack_trace_tsk get this
- * weak alias and a once-per-bootup warning (whenever this facility
- * is utilized - for example by procfs):
+ * Architectures that do not implement save_stack_trace_tsk or
+ * save_stack_trace_regs get this weak alias and a once-per-bootup warning
+ * (whenever this facility is utilized - for example by procfs):
  */
 __weak void
 save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
+	WARN_ONCE(1, "save_stack_trace_tsk() not implemented yet.\n");
+}
+
+__weak void
+save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
+{
+	WARN_ONCE(1, "save_stack_trace_regs() not implemented yet.\n");
 }

