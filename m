Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2DTV6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:58:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2DTV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:58:12 -0400
Date: Fri, 20 Apr 2012 14:58:02 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-d7abc0fa997972ddb6d3c403e03a6eefda0c0881@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/kernel/entry_64.S
Git-Commit-ID: d7abc0fa997972ddb6d3c403e03a6eefda0c0881
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 14:58:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7abc0fa997972ddb6d3c403e03a6eefda0c0881
Gitweb:     http://git.kernel.org/tip/d7abc0fa997972ddb6d3c403e03a6eefda0c0881
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:50 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/kernel/entry_64.S

Remove open-coded exception table entries in arch/x86/kernel/entry_64.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/kernel/entry_64.S |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cdc79b5..320852d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -55,6 +55,7 @@
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
+#include <asm/asm.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -900,18 +901,12 @@ restore_args:
 
 irq_return:
 	INTERRUPT_RETURN
-
-	.section __ex_table, "a"
-	.quad irq_return, bad_iret
-	.previous
+	_ASM_EXTABLE(irq_return, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iretq
-
-	.section __ex_table,"a"
-	.quad native_iret, bad_iret
-	.previous
+	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
 	.section .fixup,"ax"
@@ -1181,10 +1176,7 @@ gs_change:
 	CFI_ENDPROC
 END(native_load_gs_index)
 
-	.section __ex_table,"a"
-	.align 8
-	.quad gs_change,bad_gs
-	.previous
+	_ASM_EXTABLE(gs_change,bad_gs)
 	.section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs:
