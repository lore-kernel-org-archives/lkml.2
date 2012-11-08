Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2KHU75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:59:57 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46834 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab2KHU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:59:54 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 1/4] arch/arm: add syscall_get_arch
Date: Thu,  8 Nov 2012 12:59:30 -0800
Message-Id: <1352408373-25047-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352408373-25047-1-git-send-email-keescook@chromium.org>
References: <1352408373-25047-1-git-send-email-keescook@chromium.org>
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
 arch/arm/include/asm/syscall.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index 9fdded6..f1d96d4 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -7,6 +7,8 @@
 #ifndef _ASM_ARM_SYSCALL_H
 #define _ASM_ARM_SYSCALL_H
 
+#include <linux/audit.h> /* for AUDIT_ARCH_* */
+#include <linux/elf.h> /* for ELF_EM */
 #include <linux/err.h>
 #include <linux/sched.h>
 
@@ -95,4 +97,11 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
 }
 
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	/* ARM tasks don't change audit architectures on the fly. */
+	return AUDIT_ARCH_ARM;
+}
+
 #endif /* _ASM_ARM_SYSCALL_H */
-- 
1.7.9.5

