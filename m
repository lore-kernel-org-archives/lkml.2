Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1F1P0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:26:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:45216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228Ab1F1PXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:23:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="21496463"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        ling.ma@intel.com
Subject: [PATCH RFC 1/2 ] [x86] Modify comments and clean up code.
Date: Wed, 29 Jun 2011 06:36:10 +0800
Message-Id: <1309300570-789-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Modern CPU use fast-string instruction to accelerate copy performance,
by combining data into 128bit, so we modify comments and code style.

Thanks
Ling

---
 arch/x86/lib/copy_page_64.S |  124 +++++++++++++++++++++---------------------
 1 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6fec2d1..45f7db7 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -2,97 +2,98 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
 
 	ALIGN
-copy_page_c:
+copy_page_rep:
 	CFI_STARTPROC
-	movl $4096/8,%ecx
-	rep movsq
+	movl	$4096/8, %ecx
+	rep	movsq
 	ret
 	CFI_ENDPROC
-ENDPROC(copy_page_c)
+ENDPROC(copy_page_rep)
 
-/* Don't use streaming store because it's better when the target
-   ends up in cache. */
-	    
-/* Could vary the prefetch distance based on SMP/UP */
+/*
+   Don't use streaming copy unless cpu indicate X86_FEATURE_REP_GOOD
+   Could vary the prefetch distance based on SMP/UP
+*/
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$3*8,%rsp
+	subq	$3*8, %rsp
 	CFI_ADJUST_CFA_OFFSET 3*8
-	movq	%rbx,(%rsp)
+	movq	%rbx, (%rsp)
 	CFI_REL_OFFSET rbx, 0
-	movq	%r12,1*8(%rsp)
+	movq	%r12, 1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
-	movq	%r13,2*8(%rsp)
+	movq	%r13, 2*8(%rsp)
 	CFI_REL_OFFSET r13, 2*8
 
-	movl	$(4096/64)-5,%ecx
+	movl	$(4096/64)-5, %ecx
 	.p2align 4
 .Loop64:
-  	dec     %rcx
+  	dec	%rcx
 
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
 
 	prefetcht0 5*64(%rsi)
 
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
 
-	leaq    64 (%rsi), %rsi
-	leaq    64 (%rdi), %rdi
+	leaq	64 (%rsi), %rsi
+	leaq	64 (%rdi), %rdi
 
-	jnz     .Loop64
+	jnz	.Loop64
 
-	movl	$5,%ecx
+	movl	$5, %ecx
 	.p2align 4
 .Loop2:
-	decl   %ecx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
-
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
-
-	leaq	64(%rdi),%rdi
-	leaq	64(%rsi),%rsi
+	decl	%ecx
+
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
+
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
+
+	leaq	64(%rdi), %rdi
+	leaq	64(%rsi), %rsi
 
 	jnz	.Loop2
 
-	movq	(%rsp),%rbx
+	movq	(%rsp), %rbx
 	CFI_RESTORE rbx
-	movq	1*8(%rsp),%r12
+	movq	1*8(%rsp), %r12
 	CFI_RESTORE r12
-	movq	2*8(%rsp),%r13
+	movq	2*8(%rsp), %r13
 	CFI_RESTORE r13
-	addq	$3*8,%rsp
+	addq	$3*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -3*8
 	ret
 .Lcopy_page_end:
@@ -102,11 +103,10 @@ ENDPROC(copy_page)
 	/* Some CPUs run faster using the string copy instructions.
 	   It is also a lot simpler. Use this when possible */
 
-#include <asm/cpufeature.h>
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
-	.byte (copy_page_c - copy_page) - (2f - 1b)	/* offset */
+	.byte (copy_page_rep - copy_page) - (2f - 1b)	/* offset */
 2:
 	.previous
 	.section .altinstructions,"a"
-- 
1.6.5.2

