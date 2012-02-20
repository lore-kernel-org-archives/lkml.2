Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2BTVHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:07:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2BTVHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:07:17 -0500
Date: Mon, 20 Feb 2012 13:06:38 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-86fcd10e9a57bd9cab113cd6e10d814c849abccd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <1328677745-20121-13-git-send-email-hpa@zytor.com>
References: <1328677745-20121-13-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] mips: Use generic posix_types.h
Git-Commit-ID: 86fcd10e9a57bd9cab113cd6e10d814c849abccd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:07:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86fcd10e9a57bd9cab113cd6e10d814c849abccd
Gitweb:     http://git.kernel.org/tip/86fcd10e9a57bd9cab113cd6e10d814c849abccd
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:56 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:29 -0800

mips: Use generic posix_types.h

Change the mips architecture to use <asm-generic/posix_types.h>.

[ v2: remove redundant definition of __kernel_loff_t ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-13-git-send-email-hpa@zytor.com
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/posix_types.h |  121 ++---------------------------------
 1 files changed, 7 insertions(+), 114 deletions(-)

diff --git a/arch/mips/include/asm/posix_types.h b/arch/mips/include/asm/posix_types.h
index c200102..e0308dc 100644
--- a/arch/mips/include/asm/posix_types.h
+++ b/arch/mips/include/asm/posix_types.h
@@ -17,128 +17,21 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-#if (_MIPS_SZLONG == 32)
-typedef unsigned long	__kernel_nlink_t;
-#endif
 #if (_MIPS_SZLONG == 64)
 typedef unsigned int	__kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
 #endif
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-#if (_MIPS_SZLONG == 32)
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#endif
-#if (_MIPS_SZLONG == 64)
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-#endif
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef long		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
 
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef __kernel_uid_t	__kernel_old_uid_t;
-typedef __kernel_gid_t	__kernel_old_gid_t;
-typedef unsigned int	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long      __kernel_loff_t;
-#endif
+typedef long		__kernel_daddr_t;
+#define __kernel_daddr_t __kernel_daddr_t
 
-typedef struct {
 #if (_MIPS_SZLONG == 32)
+typedef struct {
 	long	val[2];
-#endif
-#if (_MIPS_SZLONG == 64)
-	int	val[2];
-#endif
 } __kernel_fsid_t;
+#define __kernel_fsid_t __kernel_fsid_t
+#endif
 
-#if defined(__KERNEL__)
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_POSIX_TYPES_H */
