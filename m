Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2BTVBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:01:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2BTVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:01:51 -0500
Date: Mon, 20 Feb 2012 13:01:02 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-0967504816cfe478c5b24c07216573c6cd584184@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        hskinnemoen@gmail.com, tglx@linutronix.de, egtvedt@samfundet.no
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hskinnemoen@gmail.com, tglx@linutronix.de, egtvedt@samfundet.no
In-Reply-To: <1328677745-20121-6-git-send-email-hpa@zytor.com>
References: <1328677745-20121-6-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] avr32: Use generic posix_types.h
Git-Commit-ID: 0967504816cfe478c5b24c07216573c6cd584184
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:01:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0967504816cfe478c5b24c07216573c6cd584184
Gitweb:     http://git.kernel.org/tip/0967504816cfe478c5b24c07216573c6cd584184
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:49 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:28 -0800

avr32: Use generic posix_types.h

Change the avr32 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-6-git-send-email-hpa@zytor.com
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/include/asm/posix_types.h |  107 ++++------------------------------
 1 files changed, 11 insertions(+), 96 deletions(-)

diff --git a/arch/avr32/include/asm/posix_types.h b/arch/avr32/include/asm/posix_types.h
index fe0c0c0..74667bf 100644
--- a/arch/avr32/include/asm/posix_types.h
+++ b/arch/avr32/include/asm/posix_types.h
@@ -14,112 +14,27 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long   __kernel_ino_t;
 typedef unsigned short  __kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short  __kernel_nlink_t;
-typedef long            __kernel_off_t;
-typedef int             __kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short  __kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned long	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
-typedef long            __kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long            __kernel_clock_t;
-typedef int             __kernel_timer_t;
-typedef int             __kernel_clockid_t;
-typedef int             __kernel_daddr_t;
-typedef char *          __kernel_caddr_t;
-typedef unsigned short  __kernel_uid16_t;
-typedef unsigned short  __kernel_gid16_t;
-typedef unsigned int    __kernel_uid32_t;
-typedef unsigned int    __kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
 typedef unsigned short  __kernel_old_uid_t;
 typedef unsigned short  __kernel_old_gid_t;
-typedef unsigned short  __kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long       __kernel_loff_t;
-#endif
-
-typedef struct {
-    int     val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef  __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    __fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef  __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    __fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
+#define __kernel_old_uid_t __kernel_old_uid_t
 
+typedef unsigned short  __kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#undef  __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef  __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-    unsigned long *__tmp = __p->fds_bits;
-    int __i;
-
-    if (__builtin_constant_p(__FDSET_LONGS)) {
-        switch (__FDSET_LONGS) {
-            case 16:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                __tmp[ 4] = 0; __tmp[ 5] = 0;
-                __tmp[ 6] = 0; __tmp[ 7] = 0;
-                __tmp[ 8] = 0; __tmp[ 9] = 0;
-                __tmp[10] = 0; __tmp[11] = 0;
-                __tmp[12] = 0; __tmp[13] = 0;
-                __tmp[14] = 0; __tmp[15] = 0;
-                return;
-
-            case 8:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                __tmp[ 4] = 0; __tmp[ 5] = 0;
-                __tmp[ 6] = 0; __tmp[ 7] = 0;
-                return;
-
-            case 4:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                return;
-        }
-    }
-    __i = __FDSET_LONGS;
-    while (__i) {
-        __i--;
-        *__tmp = 0;
-        __tmp++;
-    }
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* __ASM_AVR32_POSIX_TYPES_H */
