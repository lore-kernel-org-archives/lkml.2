Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967819Ab2EQWPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:15:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:65435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967777Ab2EQWOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320413"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 10/10] Use __kernel_[u]long_t in x86-64 struct stat
Date: Thu, 17 May 2012 15:13:36 -0700
Message-Id: <1337292816-10839-11-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Include <linux/types.h>.  Replace unsigned long/long with
__kernel_ulong_t/__kernel_long_t in x86-64 struct stat for user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/include/asm/stat.h |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/stat.h b/arch/x86/include/asm/stat.h
index e0b1d9b..6d99f66 100644
--- a/arch/x86/include/asm/stat.h
+++ b/arch/x86/include/asm/stat.h
@@ -3,6 +3,8 @@
 
 #define STAT_HAVE_NSEC 1
 
+#include <linux/types.h>
+
 #ifdef __i386__
 struct stat {
 	unsigned long  st_dev;
@@ -66,26 +68,26 @@ struct stat64 {
 #else /* __i386__ */
 
 struct stat {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned long	st_nlink;
-
-	unsigned int	st_mode;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned int	__pad0;
-	unsigned long	st_rdev;
-	long		st_size;
-	long		st_blksize;
-	long		st_blocks;	/* Number 512-byte blocks allocated. */
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-	unsigned long	st_ctime;
-	unsigned long   st_ctime_nsec;
-	long		__unused[3];
+	__kernel_ulong_t st_dev;
+	__kernel_ulong_t st_ino;
+	__kernel_ulong_t st_nlink;
+
+	unsigned int	 st_mode;
+	unsigned int	 st_uid;
+	unsigned int	 st_gid;
+	unsigned int	 __pad0;
+	__kernel_ulong_t st_rdev;
+	__kernel_long_t  st_size;
+	__kernel_long_t  st_blksize;
+	__kernel_long_t  st_blocks;	/* Number 512-byte blocks allocated. */
+
+	__kernel_ulong_t st_atime;
+	__kernel_ulong_t st_atime_nsec;
+	__kernel_ulong_t st_mtime;
+	__kernel_ulong_t st_mtime_nsec;
+	__kernel_ulong_t st_ctime;
+	__kernel_ulong_t st_ctime_nsec;
+	__kernel_long_t  __unused[3];
 };
 #endif
 
-- 
1.7.6.5

