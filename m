Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2EHWVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:21:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2EHWVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:21:48 -0400
Date: Tue, 8 May 2012 15:21:38 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-024742861124ef26dae4cfc620250f8f47ac934a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-11-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-11-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Move bits to the proper sections in trampoline_64.S
Git-Commit-ID: 024742861124ef26dae4cfc620250f8f47ac934a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:21:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  024742861124ef26dae4cfc620250f8f47ac934a
Gitweb:     http://git.kernel.org/tip/024742861124ef26dae4cfc620250f8f47ac934a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:33 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:03 -0700

x86, realmode: Move bits to the proper sections in trampoline_64.S

Move various bits to the sections they really belong in in
trampoline_64.S.  Use GLOBAL() rather than ENTRY() for data objects:
ENTRY() should only be used with code and forces alignment to 16
bytes.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-11-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/trampoline_64.S |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 063da00..66c58cf 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -80,6 +80,7 @@ no_longmode:
 	jmp no_longmode
 #include "../kernel/verify_cpu.S"
 
+	.section ".text32","ax"
 	.code32
 	.balign 4
 ENTRY(startup_32)
@@ -114,6 +115,7 @@ ENTRY(startup_32)
 	 */
 	ljmpl	*(pa_startup_64_vector)
 
+	.section ".text64","ax"
 	.code64
 	.balign 4
 ENTRY(startup_64)
@@ -123,7 +125,8 @@ ENTRY(startup_64)
 	addl	%esi, %eax
 	jmp	*%rax
 
-	# Careful these need to be in the same 64K segment as the above;
+	.section ".rodata","a"
+	.balign	16
 tidt:
 	.word	0			# idt limit = 0
 	.word	0, 0			# idt base = 0L
@@ -153,9 +156,8 @@ startup_64_vector:
 	.word	__KERNEL_CS, 0
 
 	.data
-
 	.balign 4
-ENTRY(trampoline_status)
+GLOBAL(trampoline_status)
 	.long	0
 
 trampoline_stack:
@@ -164,7 +166,7 @@ trampoline_stack_end:
 
 	.globl	level3_ident_pgt
 	.globl	level3_kernel_pgt
-ENTRY(trampoline_level4_pgt)
+GLOBAL(trampoline_level4_pgt)
 	level3_ident_pgt:	.quad	0
 	.fill 510,8,0
 	level3_kernel_pgt:	.quad	0
