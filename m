Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2BTAKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:10:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2BTAKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:10:34 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 04/30] posix_types: Introduce __kernel_[u]long_t
Date: Sun, 19 Feb 2012 16:07:42 -0800
Message-Id: <1329696488-16970-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:10:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Introduce __kernel_[u]long_t, which allows an ABI to override all
defaults of type [unsigned] long.

This enables x32 and potentially other 32-bit userspace on 64-bit
kernel ABIs.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-generic/posix_types.h |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index e294fe6..91d44bd 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -10,8 +10,13 @@
  * architectures, so that you can override them.
  */
 
+#ifndef __kernel_long_t
+typedef long		__kernel_long_t;
+typedef unsigned long	__kernel_ulong_t;
+#endif
+
 #ifndef __kernel_ino_t
-typedef unsigned long	__kernel_ino_t;
+typedef __kernel_ulong_t __kernel_ino_t;
 #endif
 
 #ifndef __kernel_mode_t
@@ -19,7 +24,7 @@ typedef unsigned int	__kernel_mode_t;
 #endif
 
 #ifndef __kernel_nlink_t
-typedef unsigned long	__kernel_nlink_t;
+typedef __kernel_ulong_t __kernel_nlink_t;
 #endif
 
 #ifndef __kernel_pid_t
@@ -36,7 +41,7 @@ typedef unsigned int	__kernel_gid_t;
 #endif
 
 #ifndef __kernel_suseconds_t
-typedef long		__kernel_suseconds_t;
+typedef __kernel_long_t		__kernel_suseconds_t;
 #endif
 
 #ifndef __kernel_daddr_t
@@ -67,9 +72,9 @@ typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
 #else
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
+typedef __kernel_ulong_t __kernel_size_t;
+typedef __kernel_long_t	__kernel_ssize_t;
+typedef __kernel_long_t	__kernel_ptrdiff_t;
 #endif
 #endif
 
@@ -82,10 +87,10 @@ typedef struct {
 /*
  * anything below here should be completely generic
  */
-typedef long		__kernel_off_t;
+typedef __kernel_long_t	__kernel_off_t;
 typedef long long	__kernel_loff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_clock_t;
+typedef __kernel_long_t	__kernel_time_t;
+typedef __kernel_long_t	__kernel_clock_t;
 typedef int		__kernel_timer_t;
 typedef int		__kernel_clockid_t;
 typedef char *		__kernel_caddr_t;
-- 
1.7.6.5

