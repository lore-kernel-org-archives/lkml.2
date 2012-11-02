Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519Ab2KBAQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:16:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48657 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021Ab2KBAQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:16:15 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/4] arch/arm: add syscall_get_arch
Date: Thu,  1 Nov 2012 17:14:57 -0700
Message-Id: <1351815300-28627-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351815300-28627-1-git-send-email-keescook@chromium.org>
References: <1351815300-28627-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>

Provide an ARM implementation of syscall_get_arch. This is a pre-requisite
for CONFIG_HAVE_ARCH_SECCOMP_FILTER.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/syscall.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index 9fdded6..803f433 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -7,6 +7,8 @@
 #ifndef _ASM_ARM_SYSCALL_H
 #define _ASM_ARM_SYSCALL_H
 
+#include <linux/audit.h> /* for AUDIT_ARCH_* */
+#include <linux/elf.h> /* for ELF_EM */
 #include <linux/err.h>
 #include <linux/sched.h>
 
@@ -95,4 +97,15 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	/* ARM tasks don't change audit architectures on the fly. */
+#ifdef __ARMEB__
+	return AUDIT_ARCH_ARMEB;
+#else
+	return AUDIT_ARCH_ARM;
+#endif
+}
+
 #endif /* _ASM_ARM_SYSCALL_H */
-- 
1.7.9.5

