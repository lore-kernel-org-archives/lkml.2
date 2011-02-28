Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1B1R3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:29:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:39477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1B1R3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:29:21 -0500
Date: Mon, 28 Feb 2011 17:29:02 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D6BD3A002000078000341F1@vpn.id2.novell.com>
References: <4D6BD3A002000078000341F1@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Remove unused bits from lib/thunk_*.S
Message-ID: <tip-039e13890b0615cb8c5c04b6afa84d676e24c761@git.kernel.org>
Git-Commit-ID: 039e13890b0615cb8c5c04b6afa84d676e24c761
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 17:29:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  039e13890b0615cb8c5c04b6afa84d676e24c761
Gitweb:     http://git.kernel.org/tip/039e13890b0615cb8c5c04b6afa84d676e24c761
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 28 Feb 2011 15:56:00 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 18:06:22 +0100

x86: Remove unused bits from lib/thunk_*.S

Some of the items removed were apparently never used, others
simply didn't get removed with their last user.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D6BD3A002000078000341F1@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/thunk_32.S |   18 ------------------
 arch/x86/lib/thunk_64.S |   27 ---------------------------
 2 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 650b11e..2930ae0 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -7,24 +7,6 @@
 
 	#include <linux/linkage.h>
 
-#define ARCH_TRACE_IRQS_ON			\
-	pushl %eax;				\
-	pushl %ecx;				\
-	pushl %edx;				\
-	call trace_hardirqs_on;			\
-	popl %edx;				\
-	popl %ecx;				\
-	popl %eax;
-
-#define ARCH_TRACE_IRQS_OFF			\
-	pushl %eax;				\
-	pushl %ecx;				\
-	pushl %edx;				\
-	call trace_hardirqs_off;		\
-	popl %edx;				\
-	popl %ecx;				\
-	popl %eax;
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
 	.macro thunk_ra name,func
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index bf9a7d5..782b082 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -22,26 +22,6 @@
 	CFI_ENDPROC
 	.endm
 
-	/* rdi:	arg1 ... normal C conventions. rax is passed from C. */ 	
-	.macro thunk_retrax name,func
-	.globl \name
-\name:	
-	CFI_STARTPROC
-	SAVE_ARGS
-	call \func
-	jmp  restore_norax
-	CFI_ENDPROC
-	.endm
-	
-
-	.section .sched.text, "ax"
-#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
-	thunk rwsem_down_read_failed_thunk,rwsem_down_read_failed
-	thunk rwsem_down_write_failed_thunk,rwsem_down_write_failed
-	thunk rwsem_wake_thunk,rwsem_wake
-	thunk rwsem_downgrade_thunk,rwsem_downgrade_wake
-#endif	
-	
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in rdi (arg1) */
 	.macro thunk_ra name,func
@@ -72,10 +52,3 @@ restore:
 	RESTORE_ARGS
 	ret	
 	CFI_ENDPROC
-	
-	CFI_STARTPROC
-	SAVE_ARGS
-restore_norax:	
-	RESTORE_ARGS 1
-	ret
-	CFI_ENDPROC
