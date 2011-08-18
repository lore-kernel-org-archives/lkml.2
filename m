Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1HRTGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1HRTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:50 -0400
Date: Thu, 18 Aug 2011 20:06:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 47/91] um: bury unused macros around ptrace.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vV-0007nR-MI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/ptrace-generic.h  |    4 ----
 arch/x86/um/shared/sysdep/ptrace_32.h |    3 ---
 arch/x86/um/shared/sysdep/ptrace_64.h |    3 ---
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index d7c94e4..97c35f8 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -23,14 +23,10 @@ struct pt_regs {
 #define PT_REGS_IP(r) UPT_IP(&(r)->regs)
 #define PT_REGS_SP(r) UPT_SP(&(r)->regs)
 
-#define PT_REGS_SET_SYSCALL_RETURN(r, res) \
-	UPT_SET_SYSCALL_RETURN(&(r)->regs, res)
 #define PT_REGS_RESTART_SYSCALL(r) UPT_RESTART_SYSCALL(&(r)->regs)
 
 #define PT_REGS_SYSCALL_NR(r) UPT_SYSCALL_NR(&(r)->regs)
 
-#define PT_REGS_SC(r) UPT_SC(&(r)->regs)
-
 #define instruction_pointer(regs) PT_REGS_IP(regs)
 
 struct task_struct;
diff --git a/arch/x86/um/shared/sysdep/ptrace_32.h b/arch/x86/um/shared/sysdep/ptrace_32.h
index 487aaae..967b512 100644
--- a/arch/x86/um/shared/sysdep/ptrace_32.h
+++ b/arch/x86/um/shared/sysdep/ptrace_32.h
@@ -100,9 +100,6 @@ struct syscall_args {
 				     UPT_SYSCALL_ARG5(r),	\
 				     UPT_SYSCALL_ARG6(r) } } )
 
-#define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
-
 #define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
 #define UPT_ORIG_SYSCALL(r) UPT_EAX(r)
diff --git a/arch/x86/um/shared/sysdep/ptrace_64.h b/arch/x86/um/shared/sysdep/ptrace_64.h
index 787d834..bd7b026 100644
--- a/arch/x86/um/shared/sysdep/ptrace_64.h
+++ b/arch/x86/um/shared/sysdep/ptrace_64.h
@@ -145,9 +145,6 @@ struct syscall_args {
 				     UPT_SYSCALL_ARG5(r),	 \
 				     UPT_SYSCALL_ARG6(r) } } )
 
-#define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
-
 #define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
 #define UPT_FAULTINFO(r) (&(r)->faultinfo)
-- 
1.7.2.5


