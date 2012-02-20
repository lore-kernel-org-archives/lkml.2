Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2BTVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:12:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2BTVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:12:00 -0500
Date: Mon, 20 Feb 2012 13:11:28 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-8c4c7a9a0fd4217a044b33f91f1e5b2987cbfa04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <1328677745-20121-19-git-send-email-hpa@zytor.com>
References: <1328677745-20121-19-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] sparc: Use generic posix_types.h
Git-Commit-ID: 8c4c7a9a0fd4217a044b33f91f1e5b2987cbfa04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:11:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c4c7a9a0fd4217a044b33f91f1e5b2987cbfa04
Gitweb:     http://git.kernel.org/tip/8c4c7a9a0fd4217a044b33f91f1e5b2987cbfa04
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:09:02 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:30 -0800

sparc: Use generic posix_types.h

Change the sparc architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Link: http://lkml.kernel.org/r/1328677745-20121-19-git-send-email-hpa@zytor.com
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
