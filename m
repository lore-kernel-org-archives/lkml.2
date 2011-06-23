Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab1FWRlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:41:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:35829 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933924Ab1FWRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Al Viro <viro@ftp.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 247/247] MIPS: secure_computing, syscall audit: syscall number should in r2, not r0.
Date: Thu, 23 Jun 2011 13:35:15 -0400
Message-Id: <1308850515-15242-188-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e5b377a8fb7b05f27647698ac739a0504cb2bf80 upstream.

As it is, audit_syscall_entry() and secure_computing() get the
bogus value (0, in fact)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/1697/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
1.7.4.4

