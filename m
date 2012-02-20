Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2BTVKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:10:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2BTVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:10:02 -0500
Date: Mon, 20 Feb 2012 13:08:15 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-f4f0727b75e53fde4f9b838bcb4a5d6204125522@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jejb@parisc-linux.org, tglx@linutronix.de, deller@gmx.de,
        kyle@mcmartin.ca
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jejb@parisc-linux.org, tglx@linutronix.de, deller@gmx.de,
        kyle@mcmartin.ca
In-Reply-To: <1328677745-20121-15-git-send-email-hpa@zytor.com>
References: <1328677745-20121-15-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] parisc: Use generic posix_types.h
Git-Commit-ID: f4f0727b75e53fde4f9b838bcb4a5d6204125522
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:08:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4f0727b75e53fde4f9b838bcb4a5d6204125522
Gitweb:     http://git.kernel.org/tip/f4f0727b75e53fde4f9b838bcb4a5d6204125522
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:58 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:29 -0800

parisc: Use generic posix_types.h

Change the parisc architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-15-git-send-email-hpa@zytor.com
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
---
 arch/parisc/include/asm/posix_types.h |  119 +++------------------------------
 1 files changed, 9 insertions(+), 110 deletions(-)

diff --git a/arch/parisc/include/asm/posix_types.h b/arch/parisc/include/asm/posix_types.h
index 00da29a..5212b03 100644
--- a/arch/parisc/include/asm/posix_types.h
+++ b/arch/parisc/include/asm/posix_types.h
@@ -6,123 +6,22 @@
  * be a little careful about namespace pollution etc.  Also, we cannot
  * assume GCC is being used.
  */
-typedef unsigned long		__kernel_ino_t;
+
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
-typedef unsigned int		__kernel_uid_t;
-typedef unsigned int		__kernel_gid_t;
-typedef int			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-/* Note these change from narrow to wide kernels */
-#ifdef CONFIG_64BIT
-typedef unsigned long		__kernel_size_t;
-typedef long			__kernel_ssize_t;
-typedef long			__kernel_ptrdiff_t;
-#else
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-#endif
-typedef long			__kernel_time_t;
-typedef char *			__kernel_caddr_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
 
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
-typedef unsigned int		__kernel_uid32_t;
-typedef unsigned int		__kernel_gid32_t;
+typedef int			__kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
 typedef long long		__kernel_off64_t;
 typedef unsigned long long	__kernel_ino64_t;
-#endif
-
-typedef unsigned int		__kernel_old_dev_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-/* compatibility stuff */
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-
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
 
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
