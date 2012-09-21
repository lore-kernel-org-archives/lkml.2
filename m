Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2IUP6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:58:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47571 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab2IUP6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:58:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 1/2] ARM: add finit_module syscall to ARM
Date: Fri, 21 Sep 2012 08:58:00 -0700
Message-Id: <1348243081-6725-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add finit_module syscall to the ARM syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/include/asm/unistd.h |    1 +
 arch/arm/kernel/calls.S       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 0cab47d..904b579 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -404,6 +404,7 @@
 #define __NR_setns			(__NR_SYSCALL_BASE+375)
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
+#define __NR_finit_module		(__NR_SYSCALL_BASE+378)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 463ff4a..54161ac 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -387,6 +387,7 @@
 /* 375 */	CALL(sys_setns)
 		CALL(sys_process_vm_readv)
 		CALL(sys_process_vm_writev)
+		CALL(sys_finit_module)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.0.4

