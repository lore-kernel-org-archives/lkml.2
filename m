Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2ABCuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 21:50:18 -0500
Received: from smtp12.ono.com ([62.42.230.20]:4160 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751391Ab2ABCuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 21:50:15 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jan 2012 21:50:15 EST
Date: Mon, 2 Jan 2012 03:44:19 +0100
From: Guillem Jover <guillem@hadrons.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Use __unused0 instead of __unused for user visible struct
 member names
Message-ID: <20120102024418.GA10483@gaara.hadrons.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On BSD systems __unused has traditionally been defined to mean the
equivalent of gcc's __attribute__((__unused__)), some parts of the
Linux tree use that convention too (e.g. perf). The problem comes when
defining such macro while trying to build unmodified source code with
BSD origins on systems with Linux headers.

Rename the user visible struct members from __unused to __unused0 to
not cause compilation failures due to that macro, which should not be
a problem as those members are supposed to be private anyway.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
---
 arch/alpha/include/asm/stat.h       |    2 +-
 arch/arm/include/asm/ucontext.h     |    2 +-
 arch/ia64/include/asm/stat.h        |    2 +-
 arch/mips/include/asm/compat.h      |    2 +-
 arch/powerpc/include/asm/ucontext.h |    2 +-
 arch/s390/include/asm/stat.h        |    2 +-
 arch/sparc/include/asm/compat.h     |    4 ++--
 arch/sparc/include/asm/elf_32.h     |    2 +-
 arch/sparc/include/asm/elf_64.h     |    2 +-
 arch/sparc/include/asm/fcntl.h      |    4 ++--
 arch/sparc/include/asm/stat.h       |    2 +-
 arch/tile/include/asm/compat.h      |    2 +-
 arch/x86/include/asm/stat.h         |    2 +-
 include/linux/icmp.h                |    2 +-
 include/linux/sysctl.h              |    2 +-
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/include/asm/stat.h b/arch/alpha/include/asm/stat.h
index 07ad3e6..5754865 100644
--- a/arch/alpha/include/asm/stat.h
+++ b/arch/alpha/include/asm/stat.h
@@ -42,7 +42,7 @@ struct stat64 {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long   st_ctime_nsec;
-  	long		__unused[3];
+	long		__unused0[3];
 };
 
 #endif
diff --git a/arch/arm/include/asm/ucontext.h b/arch/arm/include/asm/ucontext.h
index 14749ae..7ea9743 100644
--- a/arch/arm/include/asm/ucontext.h
+++ b/arch/arm/include/asm/ucontext.h
@@ -20,7 +20,7 @@ struct ucontext {
 	struct sigcontext uc_mcontext;
 	sigset_t	  uc_sigmask;
 	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
-	int		  __unused[32 - (sizeof (sigset_t) / sizeof (int))];
+	int		  __unused0[32 - (sizeof (sigset_t) / sizeof (int))];
 	/* Last for extensibility.  Eight byte aligned because some
 	   coprocessors require eight byte alignment.  */
  	unsigned long	  uc_regspace[128] __attribute__((__aligned__(8)));
diff --git a/arch/ia64/include/asm/stat.h b/arch/ia64/include/asm/stat.h
index 367bb90..2ec0d4c 100644
--- a/arch/ia64/include/asm/stat.h
+++ b/arch/ia64/include/asm/stat.h
@@ -24,7 +24,7 @@ struct stat {
 	unsigned long	st_ctime_nsec;
 	unsigned long	st_blksize;
 	long		st_blocks;
-	unsigned long	__unused[3];
+	unsigned long	__unused0[3];
 };
 
 #define STAT_HAVE_NSEC 1
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index b77df03..333d49f 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -84,7 +84,7 @@ struct compat_flock {
 	compat_off_t	l_len;
 	s32		l_sysid;
 	compat_pid_t	l_pid;
-	short		__unused;
+	short		__unused0;
 	s32		pad[4];
 };
 
diff --git a/arch/powerpc/include/asm/ucontext.h b/arch/powerpc/include/asm/ucontext.h
index d9a4ddf..6121f9e 100644
--- a/arch/powerpc/include/asm/ucontext.h
+++ b/arch/powerpc/include/asm/ucontext.h
@@ -28,7 +28,7 @@ struct ucontext {
 	sigset_t	uc_sigmask;
 	/* glibc has 1024-bit signal masks, ours are 64-bit */
 #ifdef __powerpc64__
-	sigset_t	__unused[15];	/* Allow for uc_sigmask growth */
+	sigset_t	__unused0[15];	/* Allow for uc_sigmask growth */
 	struct sigcontext uc_mcontext;	/* last for extensibility */
 #else
 	int		uc_maskext[30];
diff --git a/arch/s390/include/asm/stat.h b/arch/s390/include/asm/stat.h
index d92959e..9577947 100644
--- a/arch/s390/include/asm/stat.h
+++ b/arch/s390/include/asm/stat.h
@@ -95,7 +95,7 @@ struct stat {
 	unsigned long  st_ctime_nsec;
         unsigned long  st_blksize;
         long           st_blocks;
-        unsigned long  __unused[3];
+        unsigned long  __unused0[3];
 };
 
 #endif /* __s390x__ */
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index b8be20d..8f20999 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -107,7 +107,7 @@ struct compat_flock {
 	compat_off_t	l_start;
 	compat_off_t	l_len;
 	compat_pid_t	l_pid;
-	short		__unused;
+	short		__unused0;
 };
 
 #define F_GETLK64	12
@@ -120,7 +120,7 @@ struct compat_flock64 {
 	compat_loff_t	l_start;
 	compat_loff_t	l_len;
 	compat_pid_t	l_pid;
-	short		__unused;
+	short		__unused0;
 };
 
 struct compat_statfs {
diff --git a/arch/sparc/include/asm/elf_32.h b/arch/sparc/include/asm/elf_32.h
index 4269ca6..7dffbe2 100644
--- a/arch/sparc/include/asm/elf_32.h
+++ b/arch/sparc/include/asm/elf_32.h
@@ -82,7 +82,7 @@ typedef struct {
 		unsigned long	pr_regs[32];
 		double		pr_dregs[16];
 	} pr_fr;
-	unsigned long __unused;
+	unsigned long __unused0;
 	unsigned long	pr_fsr;
 	unsigned char	pr_qcnt;
 	unsigned char	pr_q_entrysize;
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 7df8b7f..1db74f5 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -133,7 +133,7 @@ typedef struct {
 		unsigned int	pr_regs[32];
 		unsigned long	pr_dregs[16];
 	} pr_fr;
-	unsigned int __unused;
+	unsigned int __unused0;
 	unsigned int	pr_fsr;
 	unsigned char	pr_qcnt;
 	unsigned char	pr_q_entrysize;
diff --git a/arch/sparc/include/asm/fcntl.h b/arch/sparc/include/asm/fcntl.h
index d0b83f6..a5e8516 100644
--- a/arch/sparc/include/asm/fcntl.h
+++ b/arch/sparc/include/asm/fcntl.h
@@ -47,8 +47,8 @@
 #define F_WRLCK		2
 #define F_UNLCK		3
 
-#define __ARCH_FLOCK_PAD	short __unused;
-#define __ARCH_FLOCK64_PAD	short __unused;
+#define __ARCH_FLOCK_PAD	short __unused0;
+#define __ARCH_FLOCK64_PAD	short __unused0;
 
 #include <asm-generic/fcntl.h>
 
diff --git a/arch/sparc/include/asm/stat.h b/arch/sparc/include/asm/stat.h
index a232e9e..7258fb4 100644
--- a/arch/sparc/include/asm/stat.h
+++ b/arch/sparc/include/asm/stat.h
@@ -43,7 +43,7 @@ struct stat64 {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long	st_ctime_nsec;
-	long		__unused[3];
+	long		__unused0[3];
 };
 
 #else
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index bf95f55..6f31f94 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -80,7 +80,7 @@ struct compat_sysctl {
 	unsigned int	oldlenp;
 	unsigned int	newval;
 	unsigned int	newlen;
-	unsigned int	__unused[4];
+	unsigned int	__unused0[4];
 };
 
 
diff --git a/arch/x86/include/asm/stat.h b/arch/x86/include/asm/stat.h
index e0b1d9b..a7fb9e5 100644
--- a/arch/x86/include/asm/stat.h
+++ b/arch/x86/include/asm/stat.h
@@ -85,7 +85,7 @@ struct stat {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long   st_ctime_nsec;
-	long		__unused[3];
+	long		__unused0[3];
 };
 #endif
 
diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 474f2a5..124e861 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -76,7 +76,7 @@ struct icmphdr {
 	} echo;
 	__be32	gateway;
 	struct {
-		__be16	__unused;
+		__be16	__unused0;
 		__be16	mtu;
 	} frag;
   } un;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 703cfa3..9911ac5 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -40,7 +40,7 @@ struct __sysctl_args {
 	size_t __user *oldlenp;
 	void __user *newval;
 	size_t newlen;
-	unsigned long __unused[4];
+	unsigned long __unused0[4];
 };
 
 /* Define sysctl names first */
-- 
1.7.7.3

