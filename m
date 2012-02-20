Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2BTVNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:13:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2BTVNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:13:01 -0500
Date: Mon, 20 Feb 2012 13:12:16 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-07d620212d51d113fad997357a75f5e1f2ffd5a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328677745-20121-20-git-send-email-hpa@zytor.com>
References: <1328677745-20121-20-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] x86: Use generic posix_types.h
Git-Commit-ID: 07d620212d51d113fad997357a75f5e1f2ffd5a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:12:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07d620212d51d113fad997357a75f5e1f2ffd5a7
Gitweb:     http://git.kernel.org/tip/07d620212d51d113fad997357a75f5e1f2ffd5a7
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:09:03 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:30 -0800

x86: Use generic posix_types.h

Change the x86 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-20-git-send-email-hpa@zytor.com
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/posix_types_32.h |   75 +++--------------------
 arch/x86/include/asm/posix_types_64.h |  106 +--------------------------------
 2 files changed, 12 insertions(+), 169 deletions(-)

diff --git a/arch/x86/include/asm/posix_types_32.h b/arch/x86/include/asm/posix_types_32.h
index f7d9adf..99f262e 100644
--- a/arch/x86/include/asm/posix_types_32.h
+++ b/arch/x86/include/asm/posix_types_32.h
@@ -7,79 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp)					\
-	asm volatile("btsl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int)(fd)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp)					\
-	asm volatile("btrl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int) (fd)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp)					\
-	(__extension__						\
-	 ({							\
-	 unsigned char __result;				\
-	 asm volatile("btl %1,%2 ; setb %0"			\
-		      : "=q" (__result)				\
-		      : "r" ((int)(fd)),			\
-			"m" (*(__kernel_fd_set *)(fdsetp)));	\
-	 __result;						\
-}))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp)					\
-do {								\
-	int __d0, __d1;						\
-	asm volatile("cld ; rep ; stosl"			\
-		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
-		       "=&c" (__d0), "=&D" (__d1)		\
-		     : "a" (0), "1" (__FDSET_LONGS),		\
-		       "2" ((__kernel_fd_set *)(fdsetp))	\
-		     : "memory");				\
-} while (0)
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_32_H */
diff --git a/arch/x86/include/asm/posix_types_64.h b/arch/x86/include/asm/posix_types_64.h
index eb8d2d9..cba0c1e 100644
--- a/arch/x86/include/asm/posix_types_64.h
+++ b/arch/x86/include/asm/posix_types_64.h
@@ -7,113 +7,13 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 typedef unsigned short __kernel_old_uid_t;
 typedef unsigned short __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
 typedef unsigned long	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 32:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			return;
-		case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-		case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
-		case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_64_H */
