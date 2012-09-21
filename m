Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2IUQ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333Ab2IUQ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:26:59 -0400
From: Mark Salter <msalter@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 2/3] c6x: switch to generic kernel_execve
Date: Fri, 21 Sep 2012 12:26:38 -0400
Message-Id: <1348244799-16013-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1348244799-16013-1-git-send-email-msalter@redhat.com>
References: <20120917032651.GU13973@ZenIV.linux.org.uk>
 <1348244799-16013-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/unistd.h |    2 ++
 arch/c6x/kernel/entry.S       |   13 ++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
index 6d54ea4..1ce3a6f 100644
--- a/arch/c6x/include/asm/unistd.h
+++ b/arch/c6x/include/asm/unistd.h
@@ -16,6 +16,8 @@
 #if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
 #define _ASM_C6X_UNISTD_H
 
+#define __ARCH_WANT_KERNEL_EXECVE
+
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
 
diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
index 6e6bd9d..32e3683 100644
--- a/arch/c6x/kernel/entry.S
+++ b/arch/c6x/kernel/entry.S
@@ -420,6 +420,12 @@ ENTRY(ret_from_kernel_thread)
 	BNOP	.S2	B11,5	/* jump to sys_exit */
 ENDPROC(ret_from_kernel_thread)
 
+ENTRY(ret_from_kernel_execve)
+	GET_THREAD_INFO A12
+	BNOP	.S2	syscall_exit,4
+	ADD	.D2X	A4,-8,SP
+ENDPROC(ret_from_kernel_execve)
+
 	;;
 	;; These are the interrupt handlers, responsible for calling __do_IRQ()
 	;; int6 is used for syscalls (see _system_call entry)
@@ -613,13 +619,6 @@ ENTRY(sys_sigaltstack)
 	NOP	4
 ENDPROC(sys_sigaltstack)
 
-	;; kernel_execve
-ENTRY(kernel_execve)
-	MVK	.S2	__NR_execve,B0
-	SWE
-	BNOP	.S2	B3,5
-ENDPROC(kernel_execve)
-
 	;;
 	;; Special system calls
 	;; return address is in B3
-- 
1.7.9.1

