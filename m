Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1B1PcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:32:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:42018 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1B1PcE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 28 Feb 2011 10:32:04 -0500
Message-Id: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 28 Feb 2011 15:31:59 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <heukelum@fastmail.fm>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: add CFI annotations to lib/rwsem_64.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These weren't part of the initial commit of this code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/lib/rwsem_64.S |   56 +++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

--- 2.6.38-rc6/arch/x86/lib/rwsem_64.S
+++ 2.6.38-rc6-x86_64-cfi-annotate-rwsem/arch/x86/lib/rwsem_64.S
@@ -23,43 +23,50 @@
 #include <asm/dwarf2.h>
 
 #define save_common_regs \
-	pushq %rdi; \
-	pushq %rsi; \
-	pushq %rcx; \
-	pushq %r8; \
-	pushq %r9; \
-	pushq %r10; \
-	pushq %r11
+	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
+	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
+	pushq_cfi %rcx; CFI_REL_OFFSET rcx, 0; \
+	pushq_cfi %r8;  CFI_REL_OFFSET r8,  0; \
+	pushq_cfi %r9;  CFI_REL_OFFSET r9,  0; \
+	pushq_cfi %r10; CFI_REL_OFFSET r10, 0; \
+	pushq_cfi %r11; CFI_REL_OFFSET r11, 0
 
 #define restore_common_regs \
-	popq %r11; \
-	popq %r10; \
-	popq %r9; \
-	popq %r8; \
-	popq %rcx; \
-	popq %rsi; \
-	popq %rdi
+	popq_cfi %r11; CFI_RESTORE r11; \
+	popq_cfi %r10; CFI_RESTORE r10; \
+	popq_cfi %r9;  CFI_RESTORE r9; \
+	popq_cfi %r8;  CFI_RESTORE r8; \
+	popq_cfi %rcx; CFI_RESTORE rcx; \
+	popq_cfi %rsi; CFI_RESTORE rsi; \
+	popq_cfi %rdi; CFI_RESTORE rdi
 
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
+	CFI_STARTPROC
 	save_common_regs
-	pushq %rdx
+	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 	movq %rax,%rdi
 	call rwsem_down_read_failed
-	popq %rdx
+	popq_cfi %rdx
+	CFI_RESTORE rdx
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_down_read_failed)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_read_failed)
 
 ENTRY(call_rwsem_down_write_failed)
+	CFI_STARTPROC
 	save_common_regs
 	movq %rax,%rdi
 	call rwsem_down_write_failed
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_down_write_failed)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
+	CFI_STARTPROC
 	decl %edx	/* do nothing if still outstanding active readers */
 	jnz 1f
 	save_common_regs
@@ -67,15 +74,20 @@ ENTRY(call_rwsem_wake)
 	call rwsem_wake
 	restore_common_regs
 1:	ret
-	ENDPROC(call_rwsem_wake)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_wake)
 
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
+	CFI_STARTPROC
 	save_common_regs
-	pushq %rdx
+	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 	movq %rax,%rdi
 	call rwsem_downgrade_wake
-	popq %rdx
+	popq_cfi %rdx
+	CFI_RESTORE rdx
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_downgrade_wake)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_downgrade_wake)



