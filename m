Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1FONxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:53:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab1FONwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:41 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=fQuI1QEWHYoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=S2f2c27iCxCPuyLbmGUA:9 a=58rI8uFXwffRHvUH3E8A:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=RXKtA1qAf9OXBiWt:21 a=xxetLEF-dE7R1AN2:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135236.272606592@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 14/16 v2] x86: Swap save_stack_trace_regs parameters
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0014-x86-Swap-save_stack_trace_regs-parameters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
 
-- 
1.7.4.4


