Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2BTVC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:02:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2BTVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:02:24 -0500
Date: Mon, 20 Feb 2012 13:01:49 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-4d6232b3f80e1307f6e6ee32cf652b32735347fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jesper.nilsson@axis.com, starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, starvik@axis.com, tglx@linutronix.de
In-Reply-To: <1328677745-20121-7-git-send-email-hpa@zytor.com>
References: <1328677745-20121-7-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] cris: Use generic posix_types.h
Git-Commit-ID: 4d6232b3f80e1307f6e6ee32cf652b32735347fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:02:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d6232b3f80e1307f6e6ee32cf652b32735347fa
Gitweb:     http://git.kernel.org/tip/4d6232b3f80e1307f6e6ee32cf652b32735347fa
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:50 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:28 -0800

cris: Use generic posix_types.h

Change the cris architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Link: http://lkml.kernel.org/r/1328677745-20121-7-git-send-email-hpa@zytor.com
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
