Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2FFEAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:00:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:15 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=mYiBL5h4hfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=TsNgXkvQm6id9O5xiMMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040014.137561542@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 04/12] ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function
 tracer
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86_32-Push-ftrace_ops-in-as-3rd-parameter-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add support of passing the current ftrace_ops into the 3rd parameter
of the callback to the function tracer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    3 +--
 arch/x86/kernel/entry_32.S    |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 1fca3c2..aefea5b 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -37,9 +37,8 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
-#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
-#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 01ccf9b..189c93f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1104,6 +1104,7 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	leal function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
-- 
1.7.10


