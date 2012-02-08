Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2BHFK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44073 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2BHFKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:10:17 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 08/21] h8300: Use generic posix_types.h
Date: Tue,  7 Feb 2012 21:08:52 -0800
Message-Id: <1328677745-20121-9-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Change the h8300 architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/include/asm/posix_types.h |   49 ++++++---------------------------
 1 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/arch/h8300/include/asm/posix_types.h b/arch/h8300/include/asm/posix_types.h
index 6f833a1..bc4c34e 100644
--- a/arch/h8300/include/asm/posix_types.h
+++ b/arch/h8300/include/asm/posix_types.h
@@ -7,54 +7,23 @@
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
 
 typedef unsigned short	__kernel_old_uid_t;
 typedef unsigned short	__kernel_old_gid_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
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
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
-- 
1.7.6.5

