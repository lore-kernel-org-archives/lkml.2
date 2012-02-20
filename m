Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2BTVKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:10:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2BTVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:10:39 -0500
Date: Mon, 20 Feb 2012 13:09:52 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-3b2a46902f908b1aec723201baabab4c200a72e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        linux390@de.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        linux390@de.ibm.com
In-Reply-To: <1328677745-20121-17-git-send-email-hpa@zytor.com>
References: <1328677745-20121-17-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] s390: Use generic posix_types.h
Git-Commit-ID: 3b2a46902f908b1aec723201baabab4c200a72e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:10:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b2a46902f908b1aec723201baabab4c200a72e9
Gitweb:     http://git.kernel.org/tip/3b2a46902f908b1aec723201baabab4c200a72e9
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:09:00 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:29 -0800

s390: Use generic posix_types.h

Change the s390 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Link: http://lkml.kernel.org/r/1328677745-20121-17-git-send-email-hpa@zytor.com
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
