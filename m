Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2BHFKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44014 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2BHFJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:43 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>
Subject: [PATCH 16/21] s390: Use generic posix_types.h
Date: Tue,  7 Feb 2012 21:09:00 -0800
Message-Id: <1328677745-20121-17-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Change the s390 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <linux390@de.ibm.com>
---
 arch/s390/include/asm/posix_types.h |   70 +++++------------------------------
 1 files changed, 10 insertions(+), 60 deletions(-)

diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index 8cc113f..edf8527 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -3,7 +3,6 @@
  *
  *  S390 version
  *
- *  Derived from "include/asm-i386/posix_types.h"
  */
 
 #ifndef __ARCH_S390_POSIX_TYPES_H
@@ -15,22 +14,11 @@
  * assume GCC is being used.
  */
 
-typedef long            __kernel_off_t;
-typedef int             __kernel_pid_t;
 typedef unsigned long   __kernel_size_t;
-typedef long            __kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long            __kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int             __kernel_daddr_t;
-typedef char *          __kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
+#define __kernel_size_t __kernel_size_t
 
-#ifdef __GNUC__
-typedef long long       __kernel_loff_t;
-#endif
+typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #ifndef __s390x__
 
@@ -42,11 +30,6 @@ typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
 typedef int             __kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
 
 #else /* __s390x__ */
 
@@ -59,49 +42,16 @@ typedef unsigned int    __kernel_gid_t;
 typedef long            __kernel_ssize_t;
 typedef long            __kernel_ptrdiff_t;
 typedef unsigned long   __kernel_sigset_t;      /* at least 32 bits */
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-typedef unsigned short __kernel_old_dev_t;
 
 #endif /* __s390x__ */
 
-typedef struct {
-        int     val[2];
-} __kernel_fsid_t;
-
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
-static inline int __FD_ISSET(unsigned long fd, const __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (fdsetp->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-#undef  __FD_ZERO
-#define __FD_ZERO(fdsetp) \
-	((void) memset ((void *) (fdsetp), 0, sizeof (__kernel_fd_set)))
+#define __kernel_ino_t  __kernel_ino_t
+#define __kernel_mode_t __kernel_mode_t
+#define __kernel_nlink_t __kernel_nlink_t
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+#define __kernel_uid_t __kernel_uid_t
+#define __kernel_gid_t __kernel_gid_t
 
-#endif     /* __KERNEL__ */
+#include <asm-generic/posix_types.h>
 
 #endif
-- 
1.7.6.5

