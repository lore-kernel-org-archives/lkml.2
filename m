Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194Ab2B2Ap6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:45:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781Ab2B2Ap5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:45:57 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] OpenRISC: Fix audit_syscall_exit() usage
Date: Wed, 29 Feb 2012 01:46:32 +0100
Message-Id: <1330476393-14264-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d7e7528 (Audit: push audit success and retcode into arch ptrace.h)
changed audit_syscall_exit().

Fixes:
  CC      arch/openrisc/kernel/ptrace.o
arch/openrisc/kernel/ptrace.c: In function ‘do_syscall_trace_leave’:
arch/openrisc/kernel/ptrace.c:206:21: error: macro "audit_syscall_exit" passed 2 arguments, but takes just 1
arch/openrisc/kernel/ptrace.c:205:3: error: ‘audit_syscall_exit’ undeclared (first use in this function)
arch/openrisc/kernel/ptrace.c:205:3: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/ptrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index 656b94b..fa381b2 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -202,8 +202,7 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 	int step;
 
 	if (unlikely(current->audit_context))
-		audit_syscall_exit(AUDITSC_RESULT(regs->gpr[11]),
-				   regs->gpr[11]);
+		audit_syscall_exit(regs);
 
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
-- 
1.7.6

