Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2AMBx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:53:58 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:39748 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab2AMBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:53:55 -0500
From: Andrew Ayer <agwa@andrewayer.name>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Hook up new fchmodat4 syscall
Date: Thu, 12 Jan 2012 17:53:46 -0800
Message-Id: <1326419626-22568-3-git-send-email-agwa@andrewayer.name>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
References: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Ayer <agwa@andrewayer.name>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 3e27456..f026e9f 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -847,4 +847,5 @@ ia32_sys_call_table:
 	.quad sys_setns
 	.quad compat_sys_process_vm_readv
 	.quad compat_sys_process_vm_writev
+	.quad sys_fchmodat4
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 599c77d..112b299 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -354,10 +354,11 @@
 #define __NR_setns		346
 #define __NR_process_vm_readv	347
 #define __NR_process_vm_writev	348
+#define __NR_fchmodat4		349
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 349
+#define NR_syscalls 350
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 0431f19..21564f9 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -686,6 +686,8 @@ __SYSCALL(__NR_getcpu, sys_getcpu)
 __SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev			311
 __SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
+#define __NR_fchmodat4				312
+__SYSCALL(__NR_fchmodat4, sys_fchmodat4)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 9a0e312..bff82a6 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -348,3 +348,4 @@ ENTRY(sys_call_table)
 	.long sys_setns
 	.long sys_process_vm_readv
 	.long sys_process_vm_writev
+	.long sys_fchmodat4
-- 
1.7.1

