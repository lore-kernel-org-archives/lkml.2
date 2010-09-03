Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0ICHMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:12:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0ICHMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:12:31 -0400
Date: Fri, 3 Sep 2010 07:12:06 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
References: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86-64: Use symbolics instead of raw numbers in entry_64.S
Message-ID: <tip-b1cccb1bb01dc1cb89f58723a58c3d4988d44d94@git.kernel.org>
Git-Commit-ID: b1cccb1bb01dc1cb89f58723a58c3d4988d44d94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:12:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1cccb1bb01dc1cb89f58723a58c3d4988d44d94
Gitweb:     http://git.kernel.org/tip/b1cccb1bb01dc1cb89f58723a58c3d4988d44d94
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 13:55:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:14:10 +0200

x86-64: Use symbolics instead of raw numbers in entry_64.S

... making the code a little less fragile.

Also use pushq_cfi instead of raw CFI annotations in two more
places, and add two missing annotations after stack pointer
adjustments which got modified here anyway.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 64dfe30..6f30583 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -795,8 +795,8 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $10*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 10*8
+	subq $ORIG_RAX-ARGOFFSET+8, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
 	call save_args
 	PARTIAL_FRAME 0
 	call \func
@@ -1035,8 +1035,8 @@ ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1051,9 +1051,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1069,9 +1069,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1088,8 +1088,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi			/* pt_regs pointer */
@@ -1106,8 +1106,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
@@ -1497,8 +1497,8 @@ ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1
-	subq $15*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
