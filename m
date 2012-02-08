Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2BHFKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab2BHFJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:41 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 06/21] cris: Use generic posix_types.h
Date: Tue,  7 Feb 2012 21:08:50 -0800
Message-Id: <1328677745-20121-7-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Change the cris architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/asm/posix_types.h |   50 +++++++----------------------------
 1 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
index ce3fb25..72b3cd6 100644
--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -12,55 +12,25 @@
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
 typedef unsigned short  __kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
+#define __kernel_uid_t __kernel_uid_t
+
 typedef __SIZE_TYPE__	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short  __kernel_uid16_t;
-typedef unsigned short  __kernel_gid16_t;
-typedef unsigned int    __kernel_uid32_t;
-typedef unsigned int    __kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
-typedef unsigned short  __kernel_old_uid_t;
-typedef unsigned short  __kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifdef __KERNEL__
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp) clear_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp) test_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) memset((void *)(fdsetp), 0, __FDSET_LONGS << 2)
-
-#endif /* __KERNEL__ */
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #endif /* __ARCH_CRIS_POSIX_TYPES_H */
-- 
1.7.6.5

