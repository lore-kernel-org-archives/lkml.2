Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1B1R2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:28:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:39445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1B1R2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:28:33 -0500
Date: Mon, 28 Feb 2011 17:28:12 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
References: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Add CFI annotations to lib/rwsem_64.S
Message-ID: <tip-39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c@git.kernel.org>
Git-Commit-ID: 39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 17:28:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
Gitweb:     http://git.kernel.org/tip/39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 28 Feb 2011 15:31:59 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 18:06:21 +0100

x86-64: Add CFI annotations to lib/rwsem_64.S

These weren't part of the initial commit of this code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/rwsem_64.S |   56 ++++++++++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 41fcf00..6774397 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
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
