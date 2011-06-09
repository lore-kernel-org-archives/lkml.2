Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1FIRbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:31:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1FIR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:15 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=wqhFLSKigEMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=zUK80Ra-C2-9bwr2Jn0A:9 a=G1Y90kOYJqLJFLEP0aQA:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172914.028158916@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 14/15] stack_trace: Add weak save_stack_trace_regs()
References: <20110609172744.333794089@goodmis.org>
Content-Disposition: inline; filename=0014-stack_trace-Add-weak-save_stack_trace_regs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add weak symbol of save_stack_trace_regs() as same as
save_stack_trace_tsk() since that is not implemented
except x86 yet.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: yrl.pp-manager.tt@hitachi.com
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/20110608070927.17777.37895.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.7.4.4


