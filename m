Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1B1P4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:56:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57951 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1B1P4H convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 28 Feb 2011 10:56:07 -0500
Message-Id: <4D6BD3A002000078000341F1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 28 Feb 2011 15:56:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove unused bits from lib/thunk_*.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the items removed were apparently never used, others simply
didn't get removed with their last user.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/lib/thunk_32.S |   18 ------------------
 arch/x86/lib/thunk_64.S |   27 ---------------------------
 2 files changed, 45 deletions(-)

--- 2.6.38-rc6/arch/x86/lib/thunk_32.S
+++ 2.6.38-rc6-x86-thunk-cleanup/arch/x86/lib/thunk_32.S
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
--- 2.6.38-rc6/arch/x86/lib/thunk_64.S
+++ 2.6.38-rc6-x86-thunk-cleanup/arch/x86/lib/thunk_64.S
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



