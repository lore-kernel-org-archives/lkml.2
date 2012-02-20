Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2BTVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:01:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2BTVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:00:59 -0500
Date: Mon, 20 Feb 2012 13:00:13 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-e7ca2e1d9bea753dca96e3c693f0608035ea20ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rmk+kernel@arm.linux.org.uk, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <1328677745-20121-5-git-send-email-hpa@zytor.com>
References: <1328677745-20121-5-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] arm: Use generic posix_types.h
Git-Commit-ID: e7ca2e1d9bea753dca96e3c693f0608035ea20ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:00:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7ca2e1d9bea753dca96e3c693f0608035ea20ed
Gitweb:     http://git.kernel.org/tip/e7ca2e1d9bea753dca96e3c693f0608035ea20ed
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:48 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:28 -0800

arm: Use generic posix_types.h

Change the arm architecture to use <asm-generic/posix_types.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/1328677745-20121-5-git-send-email-hpa@zytor.com
---
 arch/arm/include/asm/posix_types.h |   55 ++++++------------------------------
 1 files changed, 9 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/posix_types.h b/arch/arm/include/asm/posix_types.h
index 2446d23..efdf990 100644
--- a/arch/arm/include/asm/posix_types.h
+++ b/arch/arm/include/asm/posix_types.h
@@ -19,59 +19,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long		__kernel_ino_t;
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short		__kernel_uid_t;
 typedef unsigned short		__kernel_gid_t;
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-typedef long			__kernel_time_t;
-typedef long			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-typedef char *			__kernel_caddr_t;
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
-typedef unsigned int		__kernel_uid32_t;
-typedef unsigned int		__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short		__kernel_old_uid_t;
-typedef unsigned short		__kernel_old_gid_t;
 typedef unsigned short		__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] |= (1<<((fd) & 31)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] &= ~(1<<((fd) & 31)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd, fdsetp) \
-		((((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] & (1<<((fd) & 31))) != 0)
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) \
-		(memset (fdsetp, 0, sizeof (*(fd_set *)(fdsetp))))
-
-#endif
+#include <asm-generic/posix_types.h>
 
 #endif
