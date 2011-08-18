Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HRTCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:02:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1HRTCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:02:50 -0400
Date: Thu, 18 Aug 2011 20:02:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 23/91] um: get rid of unused macros in
 ptrace_user.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7rd-0007az-BQ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-i386/shared/sysdep/ptrace_user.h   |   24 --------------
 arch/um/sys-x86_64/shared/sysdep/ptrace_user.h |   39 ------------------------
 2 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/arch/um/sys-i386/shared/sysdep/ptrace_user.h b/arch/um/sys-i386/shared/sysdep/ptrace_user.h
index e4398a3..9d88a79 100644
--- a/arch/um/sys-i386/shared/sysdep/ptrace_user.h
+++ b/arch/um/sys-i386/shared/sysdep/ptrace_user.h
@@ -16,35 +16,11 @@
 #define PT_SYSCALL_NR(regs) ((regs)[ORIG_EAX])
 #define PT_SYSCALL_NR_OFFSET PT_OFFSET(ORIG_EAX)
 
-#define PT_SYSCALL_ARG1_OFFSET PT_OFFSET(EBX)
-#define PT_SYSCALL_ARG2_OFFSET PT_OFFSET(ECX)
-#define PT_SYSCALL_ARG3_OFFSET PT_OFFSET(EDX)
-#define PT_SYSCALL_ARG4_OFFSET PT_OFFSET(ESI)
-#define PT_SYSCALL_ARG5_OFFSET PT_OFFSET(EDI)
-#define PT_SYSCALL_ARG6_OFFSET PT_OFFSET(EBP)
-
 #define PT_SYSCALL_RET_OFFSET PT_OFFSET(EAX)
 
-#define REGS_SYSCALL_NR EAX /* This is used before a system call */
-#define REGS_SYSCALL_ARG1 EBX
-#define REGS_SYSCALL_ARG2 ECX
-#define REGS_SYSCALL_ARG3 EDX
-#define REGS_SYSCALL_ARG4 ESI
-#define REGS_SYSCALL_ARG5 EDI
-#define REGS_SYSCALL_ARG6 EBP
-
 #define REGS_IP_INDEX EIP
 #define REGS_SP_INDEX UESP
 
-#define PT_IP_OFFSET PT_OFFSET(EIP)
-#define PT_IP(regs) ((regs)[EIP])
-#define PT_SP_OFFSET PT_OFFSET(UESP)
-#define PT_SP(regs) ((regs)[UESP])
-
 #define FP_SIZE ((HOST_FPX_SIZE > HOST_FP_SIZE) ? HOST_FPX_SIZE : HOST_FP_SIZE)
 
-#ifndef FRAME_SIZE
-#define FRAME_SIZE (17)
-#endif
-
 #endif
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h b/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
index faf9cdd..2f1b6e3 100644
--- a/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
+++ b/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
@@ -19,35 +19,8 @@
 #define PT_SYSCALL_NR(regs) ((regs)[PT_INDEX(ORIG_RAX)])
 #define PT_SYSCALL_NR_OFFSET (ORIG_RAX)
 
-#define PT_SYSCALL_ARG1(regs) (((unsigned long *) (regs))[PT_INDEX(RDI)])
-#define PT_SYSCALL_ARG1_OFFSET (RDI)
-
-#define PT_SYSCALL_ARG2(regs) (((unsigned long *) (regs))[PT_INDEX(RSI)])
-#define PT_SYSCALL_ARG2_OFFSET (RSI)
-
-#define PT_SYSCALL_ARG3(regs) (((unsigned long *) (regs))[PT_INDEX(RDX)])
-#define PT_SYSCALL_ARG3_OFFSET (RDX)
-
-#define PT_SYSCALL_ARG4(regs) (((unsigned long *) (regs))[PT_INDEX(RCX)])
-#define PT_SYSCALL_ARG4_OFFSET (RCX)
-
-#define PT_SYSCALL_ARG5(regs) (((unsigned long *) (regs))[PT_INDEX(R8)])
-#define PT_SYSCALL_ARG5_OFFSET (R8)
-
-#define PT_SYSCALL_ARG6(regs) (((unsigned long *) (regs))[PT_INDEX(R9)])
-#define PT_SYSCALL_ARG6_OFFSET (R9)
-
 #define PT_SYSCALL_RET_OFFSET (RAX)
 
-#define PT_IP_OFFSET (RIP)
-#define PT_IP(regs) ((regs)[PT_INDEX(RIP)])
-
-#define PT_SP_OFFSET (RSP)
-#define PT_SP(regs) ((regs)[PT_INDEX(RSP)])
-
-#define PT_ORIG_RAX_OFFSET (ORIG_RAX)
-#define PT_ORIG_RAX(regs) ((regs)[PT_INDEX(ORIG_RAX)])
-
 /*
  * x86_64 FC3 doesn't define this in /usr/include/linux/ptrace.h even though
  * it's defined in the kernel's include/linux/ptrace.h. Additionally, use the
@@ -57,18 +30,6 @@
 #define PTRACE_OLDSETOPTIONS 21
 #endif
 
-/*
- * These are before the system call, so the system call number is RAX
- * rather than ORIG_RAX, and arg4 is R10 rather than RCX
- */
-#define REGS_SYSCALL_NR PT_INDEX(RAX)
-#define REGS_SYSCALL_ARG1 PT_INDEX(RDI)
-#define REGS_SYSCALL_ARG2 PT_INDEX(RSI)
-#define REGS_SYSCALL_ARG3 PT_INDEX(RDX)
-#define REGS_SYSCALL_ARG4 PT_INDEX(R10)
-#define REGS_SYSCALL_ARG5 PT_INDEX(R8)
-#define REGS_SYSCALL_ARG6 PT_INDEX(R9)
-
 #define REGS_IP_INDEX PT_INDEX(RIP)
 #define REGS_SP_INDEX PT_INDEX(RSP)
 
-- 
1.7.2.5


