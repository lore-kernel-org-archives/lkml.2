Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1FHH3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:29:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46749 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1FHH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:29:08 -0400
X-AuditID: b753bd60-a14abba0000019f4-ec-4def24c14ea3
X-AuditID: b753bd60-a14abba0000019f4-ec-4def24c14ea3
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 2/3] Add weak save_stack_trace_regs()
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
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Jun 2011 16:09:27 +0900
Message-ID: <20110608070927.17777.37895.stgit@fedora15>
In-Reply-To: <20110608070913.17777.37689.stgit@fedora15>
References: <20110608070913.17777.37689.stgit@fedora15>
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
except x86 yet.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/stacktrace.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index eb212f8..6fa38bc 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -26,12 +26,19 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
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
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
 }
+
+__weak void
+save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
+{
+	WARN_ONCE(1,
+		  KERN_INFO "save_stack_trace_regs() not implemented yet.\n");
+}

