Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1GEMzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:59423 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab1GEMzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:55:14 -0400
Date: Tue, 5 Jul 2011 12:55:04 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-c624d33f61cd05241e85b906311f0b712fdb0f32@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20110608070927.17777.37895.stgit@fedora15>
References: <20110608070927.17777.37895.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] stack_trace: Add weak save_stack_trace_regs()
Git-Commit-ID: c624d33f61cd05241e85b906311f0b712fdb0f32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:55:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c624d33f61cd05241e85b906311f0b712fdb0f32
Gitweb:     http://git.kernel.org/tip/c624d33f61cd05241e85b906311f0b712fdb0f32
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 8 Jun 2011 16:09:27 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:52 -0400

stack_trace: Add weak save_stack_trace_regs()

Add weak symbol of save_stack_trace_regs() as same as
save_stack_trace_tsk() since that is not implemented
except x86 yet.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/r/20110608070927.17777.37895.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/stacktrace.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index eb212f8..d20c698 100644
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
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
 }
+
+__weak void
+save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
+{
+	WARN_ONCE(1, KERN_INFO "save_stack_trace_regs() not implemented yet.\n");
+}
