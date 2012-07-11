Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab2GKT6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:58:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab2GKT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:57:48 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Wn-t8J6AbaUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=2yy7z9ee9AFxJZM3T4oA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120711195745.588538769@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Jul 2012 15:50:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 3/4 v4] ftrace/x86: Remove function_trace_stop check from graph caller
References: <20120711195048.885039013@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-x86-Remove-function_trace_stop-check-from-gra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The graph caller is called by the mcount callers, which already does
the check against the function_trace_stop variable. No reason to
check it again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    3 ---
 arch/x86/kernel/entry_64.S |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 8ef138f..9019806 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1232,9 +1232,6 @@ END(mcount)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 52bda2e..38308fa 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -213,9 +213,6 @@ END(mcount)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	MCOUNT_SAVE_FRAME
 
 	leaq 8(%rbp), %rdi
-- 
1.7.10


