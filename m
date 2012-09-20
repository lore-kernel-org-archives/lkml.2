Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2ITUJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:09:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41173 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab2ITUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:09:11 -0400
Date: Thu, 20 Sep 2012 13:08:05 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: add finit_module syscall to ARM
Message-ID: <20120920200805.GA18919@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add finit_module syscall to the ARM syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This depends on the finit_module patchset in Rusty's tree, based on
https://lkml.org/lkml/2012/9/7/559
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


-- 
Kees Cook
Chrome OS Security
