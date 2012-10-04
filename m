Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2JDUXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:23:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54694 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab2JDUX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:23:27 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 3/4] ARM: add finit_module syscall to ARM
Date: Thu,  4 Oct 2012 13:22:33 -0700
Message-Id: <1349382154-9804-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349382154-9804-1-git-send-email-keescook@chromium.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add finit_module syscall to the ARM syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/include/asm/unistd.h |    2 ++
 arch/arm/kernel/calls.S       |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 0cab47d..7959ac2 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -404,6 +404,8 @@
 #define __NR_setns			(__NR_SYSCALL_BASE+375)
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
+					/* 378 for kcmp */
+#define __NR_finit_module		(__NR_SYSCALL_BASE+379)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 463ff4a..afce06a 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -387,6 +387,8 @@
 /* 375 */	CALL(sys_setns)
 		CALL(sys_process_vm_readv)
 		CALL(sys_process_vm_writev)
+		CALL(sys_ni_syscall)	/* reserved for sys_kcmp */
+		CALL(sys_finit_module)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.9.5

