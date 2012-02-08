Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2BHFKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44009 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2BHFJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:42 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 18/21] sparc: Use generic posix_types.h
Date: Tue,  7 Feb 2012 21:09:02 -0800
Message-Id: <1328677745-20121-19-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Change the sparc architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/include/asm/posix_types.h |  133 +++++-----------------------------
 1 files changed, 17 insertions(+), 116 deletions(-)

diff --git a/arch/sparc/include/asm/posix_types.h b/arch/sparc/include/asm/posix_types.h
index dbfc1a3..3070f25 100644
--- a/arch/sparc/include/asm/posix_types.h
+++ b/arch/sparc/include/asm/posix_types.h
@@ -9,35 +9,16 @@
 
 #if defined(__sparc__) && defined(__arch64__)
 /* sparc 64 bit */
-typedef unsigned long          __kernel_size_t;
-typedef long                   __kernel_ssize_t;
-typedef long                   __kernel_ptrdiff_t;
-typedef long                   __kernel_time_t;
-typedef long                   __kernel_clock_t;
-typedef int                    __kernel_pid_t;
-typedef int                    __kernel_ipc_pid_t;
-typedef unsigned int           __kernel_uid_t;
-typedef unsigned int           __kernel_gid_t;
-typedef unsigned long          __kernel_ino_t;
-typedef unsigned int           __kernel_mode_t;
 typedef unsigned int           __kernel_nlink_t;
-typedef int                    __kernel_daddr_t;
-typedef long                   __kernel_off_t;
-typedef char *                 __kernel_caddr_t;
-typedef unsigned short	       __kernel_uid16_t;
-typedef unsigned short	       __kernel_gid16_t;
-typedef int                    __kernel_clockid_t;
-typedef int                    __kernel_timer_t;
+#define __kernel_nlink_t __kernel_nlink_t
 
 typedef unsigned short 	       __kernel_old_uid_t;
 typedef unsigned short         __kernel_old_gid_t;
-typedef __kernel_uid_t	       __kernel_uid32_t;
-typedef __kernel_gid_t	       __kernel_gid32_t;
-
-typedef unsigned int	       __kernel_old_dev_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
 /* Note this piece of asymmetry from the v9 ABI.  */
 typedef int		       __kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
 
 #else
 /* sparc 32 bit */
@@ -45,109 +26,29 @@ typedef int		       __kernel_suseconds_t;
 typedef unsigned int           __kernel_size_t;
 typedef int                    __kernel_ssize_t;
 typedef long int               __kernel_ptrdiff_t;
-typedef long                   __kernel_time_t;
-typedef long		       __kernel_suseconds_t;
-typedef long                   __kernel_clock_t;
-typedef int                    __kernel_pid_t;
+#define __kernel_size_t __kernel_size_t
+
 typedef unsigned short         __kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short         __kernel_uid_t;
 typedef unsigned short         __kernel_gid_t;
-typedef unsigned long          __kernel_ino_t;
+#define __kernel_uid_t __kernel_uid_t
+
 typedef unsigned short         __kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef short                  __kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef long                   __kernel_daddr_t;
-typedef long                   __kernel_off_t;
-typedef char *                 __kernel_caddr_t;
-typedef unsigned short	       __kernel_uid16_t;
-typedef unsigned short	       __kernel_gid16_t;
-typedef unsigned int	       __kernel_uid32_t;
-typedef unsigned int	       __kernel_gid32_t;
-typedef unsigned short	       __kernel_old_uid_t;
-typedef unsigned short	       __kernel_old_gid_t;
+#define __kernel_daddr_t __kernel_daddr_t
+
 typedef unsigned short	       __kernel_old_dev_t;
-typedef int                    __kernel_clockid_t;
-typedef int                    __kernel_timer_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #endif /* defined(__sparc__) && defined(__arch64__) */
 
-#ifdef __GNUC__
-typedef long long              __kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
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
-			case 32:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			  tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			  tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			  tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			  return;
-			case 16:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  return;
-			case 8:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  return;
-			case 4:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  return;
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
 
-#endif /* __KERNEL__ */
 #endif /* __SPARC_POSIX_TYPES_H */
-- 
1.7.6.5

