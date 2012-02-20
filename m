Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2BTALm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:11:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2BTALk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:11:40 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 06/30] sysinfo: Use explicit types in <linux/sysinfo.h>
Date: Sun, 19 Feb 2012 16:07:44 -0800
Message-Id: <1329696488-16970-7-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:11:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Change <linux/sysinfo.h> to use explicitly sized types.  Replace
long/unsigned long with __kernel_[u]long_t so that a non-legacy 32-bit
ABI running on a 64-bit kernel can export those as 64-bit types.

Originally-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/sysinfo.h |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/sysinfo.h b/include/linux/sysinfo.h
index ec4fc22..934335a 100644
--- a/include/linux/sysinfo.h
+++ b/include/linux/sysinfo.h
@@ -1,22 +1,24 @@
 #ifndef _LINUX_SYSINFO_H
 #define _LINUX_SYSINFO_H
 
+#include <linux/types.h>
+
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
-	long uptime;			/* Seconds since boot */
-	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
-	unsigned long totalram;		/* Total usable main memory size */
-	unsigned long freeram;		/* Available memory size */
-	unsigned long sharedram;	/* Amount of shared memory */
-	unsigned long bufferram;	/* Memory used by buffers */
-	unsigned long totalswap;	/* Total swap space size */
-	unsigned long freeswap;		/* swap space still available */
-	unsigned short procs;		/* Number of current processes */
-	unsigned short pad;		/* explicit padding for m68k */
-	unsigned long totalhigh;	/* Total high memory size */
-	unsigned long freehigh;		/* Available high memory size */
-	unsigned int mem_unit;		/* Memory unit size in bytes */
-	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
+	__kernel_long_t uptime;		/* Seconds since boot */
+	__kernel_ulong_t loads[3];	/* 1, 5, and 15 minute load averages */
+	__kernel_ulong_t totalram;	/* Total usable main memory size */
+	__kernel_ulong_t freeram;	/* Available memory size */
+	__kernel_ulong_t sharedram;	/* Amount of shared memory */
+	__kernel_ulong_t bufferram;	/* Memory used by buffers */
+	__kernel_ulong_t totalswap;	/* Total swap space size */
+	__kernel_ulong_t freeswap;	/* swap space still available */
+	__u16 procs;		   	/* Number of current processes */
+	__u16 pad;		   	/* Explicit padding for m68k */
+	__kernel_ulong_t totalhigh;	/* Total high memory size */
+	__kernel_ulong_t freehigh;	/* Available high memory size */
+	__u32 mem_unit;			/* Memory unit size in bytes */
+	char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];	/* Padding: libc5 uses this.. */
 };
 
 #endif /* _LINUX_SYSINFO_H */
-- 
1.7.6.5

