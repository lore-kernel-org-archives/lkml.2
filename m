Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2HSDBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:48688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422056"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/74] lto: Change kernel_execve to asmlinkage for all architectures
Date: Sat, 18 Aug 2012 19:56:18 -0700
Message-Id: <1345345030-22211-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The x86 kernel_execve has to be asmlinkage because it's called from
assembler code. To make it consistent I have to also change
the prototype in linux/syscalls.h

This in turn requires adding asmlinkage to all architectures.

Do this here in a tree sweep.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/arm/kernel/sys_arm.c               |    1 +
 arch/avr32/kernel/sys_avr32.c           |    1 +
 arch/m32r/kernel/sys_m32r.c             |    1 +
 arch/microblaze/kernel/sys_microblaze.c |    1 +
 arch/mips/kernel/syscall.c              |    1 +
 arch/parisc/kernel/process.c            |    1 +
 arch/sh/kernel/sys_sh32.c               |    1 +
 arch/sh/kernel/sys_sh64.c               |    1 +
 arch/sparc/kernel/sys_sparc_32.c        |    1 +
 arch/sparc/kernel/sys_sparc_64.c        |    1 +
 arch/um/kernel/syscall.c                |    1 +
 arch/unicore32/kernel/sys.c             |    1 +
 arch/x86/kernel/sys_i386_32.c           |    2 +-
 include/linux/syscalls.h                |    1 +
 14 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 76cbb05..50b1bf1 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -79,6 +79,7 @@ out:
 	return error;
 }
 
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 62635a0..94d7121 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -7,6 +7,7 @@
  */
 #include <linux/unistd.h>
 
+asmlinkage
 int kernel_execve(const char *file,
 		  const char *const *argv,
 		  const char *const *envp)
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index d841fb6..b7b2581 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -93,6 +93,7 @@ asmlinkage int sys_cachectl(char *addr, int nbytes, int op)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index e5b154f..396b157 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -80,6 +80,7 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index b08220c..6282a7a 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -318,6 +318,7 @@ asmlinkage void bad_stack(void)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..82f425e 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -358,6 +358,7 @@ out:
 extern int __execve(const char *filename,
 		    const char *const argv[],
 		    const char *const envp[], struct task_struct *task);
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
index f56b6fe5..db3f53d 100644
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -71,6 +71,7 @@ asmlinkage int sys_fadvise64_64_wrapper(int fd, u32 offset0, u32 offset1,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/sh/kernel/sys_sh64.c b/arch/sh/kernel/sys_sh64.c
index c5a38c4..cad6faa 100644
--- a/arch/sh/kernel/sys_sh64.c
+++ b/arch/sh/kernel/sys_sh64.c
@@ -33,6 +33,7 @@
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 0c9b31b..37e75dd 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -263,6 +263,7 @@ out:
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 11c6c96..04e57f9 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -734,6 +734,7 @@ SYSCALL_DEFINE5(rt_sigaction, int, sig, const struct sigaction __user *, act,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index f958cb8..b78e579 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -51,6 +51,7 @@ long old_mmap(unsigned long addr, unsigned long len,
 	return err;
 }
 
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/unicore32/kernel/sys.c b/arch/unicore32/kernel/sys.c
index 3afe60a..12fc324 100644
--- a/arch/unicore32/kernel/sys.c
+++ b/arch/unicore32/kernel/sys.c
@@ -63,6 +63,7 @@ out:
 	return error;
 }
 
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 0b0cb5f..30ad2cd 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -28,7 +28,7 @@
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename,
+asmlinkage int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
 {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 19439c7..5cf40e3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -827,6 +827,7 @@ asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  const char  __user *pathname);
 asmlinkage long sys_syncfs(int fd);
 
+asmlinkage
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
 
-- 
1.7.7.6

