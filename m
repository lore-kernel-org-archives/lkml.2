Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0I1Ru3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:50:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36598 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0I1Ru1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:50:27 -0400
Date: Tue, 28 Sep 2010 18:50:27 +0100
To: ralf@linux-mips.org
Subject: [PATCH 2/5] mips: syscall number in in R2, not R0...
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P0eJv-0006iz-4d@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


as it is, audit_syscall_entry() and secure_computing() get the
bogus value (0, in fact)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mips/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index c51b95f..c877733 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -536,7 +536,7 @@ asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
 	/* do the secure computing check first */
 	if (!entryexit)
-		secure_computing(regs->regs[0]);
+		secure_computing(regs->regs[2]);
 
 	if (unlikely(current->audit_context) && entryexit)
 		audit_syscall_exit(AUDITSC_RESULT(regs->regs[2]),
@@ -565,7 +565,7 @@ asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 
 out:
 	if (unlikely(current->audit_context) && !entryexit)
-		audit_syscall_entry(audit_arch(), regs->regs[0],
+		audit_syscall_entry(audit_arch(), regs->regs[2],
 				    regs->regs[4], regs->regs[5],
 				    regs->regs[6], regs->regs[7]);
 }
-- 
1.5.6.5


