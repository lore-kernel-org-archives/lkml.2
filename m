Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2BTVJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:09:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2BTVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:09:39 -0500
Date: Mon, 20 Feb 2012 13:09:04 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-fae89ee8d7a9be6044aa3c657fc169c1dca0e6ac@git.kernel.org>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <1328677745-20121-16-git-send-email-hpa@zytor.com>
References: <1328677745-20121-16-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] powerpc: Use generic posix_types.h
Git-Commit-ID: fae89ee8d7a9be6044aa3c657fc169c1dca0e6ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:09:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fae89ee8d7a9be6044aa3c657fc169c1dca0e6ac
Gitweb:     http://git.kernel.org/tip/fae89ee8d7a9be6044aa3c657fc169c1dca0e6ac
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:59 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:29 -0800

powerpc: Use generic posix_types.h

Change the powerpc architecture to use <asm-generic/posix_types.h>.

[ v2: fix the definition for __kernel_ssize_t ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-16-git-send-email-hpa@zytor.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/posix_types.h |  118 +++-----------------------------
 1 files changed, 9 insertions(+), 109 deletions(-)

diff --git a/arch/powerpc/include/asm/posix_types.h b/arch/powerpc/include/asm/posix_types.h
index c4e396b..f139325 100644
--- a/arch/powerpc/include/asm/posix_types.h
+++ b/arch/powerpc/include/asm/posix_types.h
@@ -7,122 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef long		__kernel_suseconds_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef unsigned int	__kernel_old_uid_t;
-typedef unsigned int	__kernel_old_gid_t;
-
 #ifdef __powerpc64__
-typedef unsigned long  	__kernel_nlink_t;
-typedef int             __kernel_ipc_pid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
 typedef unsigned long	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 #else
-typedef unsigned short	__kernel_nlink_t;
-typedef short		__kernel_ipc_pid_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
-typedef unsigned int	__kernel_old_dev_t;
-#endif
-
-#ifdef __powerpc64__
-typedef long long	__kernel_loff_t;
-#else
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
-
-#else /* __GNUC__ */
-
-#if defined(__KERNEL__)
-/* With GNU C, use inline functions instead so args are evaluated only once: */
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, __kernel_fd_set *p)
-{ 
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = (unsigned long *)p->fds_bits;
-	int i;
+typedef long		__kernel_ptrdiff_t;
+#define __kernel_size_t __kernel_size_t
 
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		      case 16:
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
+typedef unsigned short	__kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
 
-		      case 8:
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+typedef short		__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+#endif
 
-		      case 4:
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
+#include <asm-generic/posix_types.h>
 
-#endif /* defined(__KERNEL__) */
-#endif /* __GNUC__ */
 #endif /* _ASM_POWERPC_POSIX_TYPES_H */
