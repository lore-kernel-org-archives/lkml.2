Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2JQNBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:01:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:21377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2JQNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,600,1344236400"; 
   d="scan'208";a="207143863"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        iant@google.com, Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC V2 1/2] [x86] Modify comments and clean up code.
Date: Thu, 18 Oct 2012 03:52:45 +0800
Message-Id: <1350503565-19167-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Modern CPU use fast-string instruction to accelerate copy performance,
by combining data into 128bit, so we modify comments and code style.

Signed-off-by: Ma Ling <ling.ma@intel.com>

---
In this version, update comments from Borislav Petkov
Thanks
Ling

 arch/x86/lib/copy_page_64.S |  120 +++++++++++++++++++++----------------------
 1 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6b34d04..cda2e51 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -5,91 +5,89 @@
 #include <asm/alternative-asm.h>
 
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
+ *  Don't use streaming copy unless cpu indicate X86_FEATURE_REP_GOOD
+ *  Could vary the prefetch distance based on SMP/UP
+*/
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$2*8,%rsp
+	subq	$2*8,	%rsp
 	CFI_ADJUST_CFA_OFFSET 2*8
-	movq	%rbx,(%rsp)
+	movq	%rbx,	(%rsp)
 	CFI_REL_OFFSET rbx, 0
-	movq	%r12,1*8(%rsp)
+	movq	%r12,	1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
 
-	movl	$(4096/64)-5,%ecx
+	movl	$(4096/64)-5,	%ecx
 	.p2align 4
 .Loop64:
-  	dec     %rcx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
+	dec	%rcx
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
-
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
-	addq	$2*8,%rsp
+	addq	$2*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
@@ -103,7 +101,7 @@ ENDPROC(copy_page)
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
-	.byte (copy_page_c - copy_page) - (2f - 1b)	/* offset */
+	.byte (copy_page_rep - copy_page) - (2f - 1b)	/* offset */
 2:
 	.previous
 	.section .altinstructions,"a"
-- 
1.6.5.2

