Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2FLW47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:56:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab2FLWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:54:27 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=tfcL9tyMhAQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=TsNgXkvQm6id9O5xiMMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120612225424.942411318@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Jun 2012 18:43:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 04/13 v2] ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function
 tracer
References: <20120612224327.426900129@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86_32-Push-ftrace_ops-in-as-3rd-parameter-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add support of passing the current ftrace_ops into the 3rd parameter
of the callback to the function tracer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/entry_32.S    |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 2b1c654..aefea5b 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -37,7 +37,7 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
-#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #endif
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 623f288..e3e17a0 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1111,6 +1111,7 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	leal function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
-- 
1.7.10


