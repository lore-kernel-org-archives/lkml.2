Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2BTAKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:10:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BTAKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:10:09 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 03/30] sysinfo: Move struct sysinfo to a separate header file
Date: Sun, 19 Feb 2012 16:07:41 -0800
Message-Id: <1329696488-16970-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:10:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

struct sysinfo is just about the only thing exported to userspace from
<linux/kernel.h>, so move it into a separate header file with a
residual #include in <linux/kernel.h>.

Originally-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-4pr1xnnksprt7t0h3w5fw4rv@git.kernel.org
---
 include/linux/Kbuild    |    1 +
 include/linux/kernel.h  |   21 ++-------------------
 include/linux/sysinfo.h |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/sysinfo.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c94e717..8446086 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -355,6 +355,7 @@ header-y += suspend_ioctls.h
 header-y += swab.h
 header-y += synclink.h
 header-y += sysctl.h
+header-y += sysinfo.h
 header-y += taskstats.h
 header-y += tcp.h
 header-y += telephony.h
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..dc6a50f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
+#include <linux/sysinfo.h>
+
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
@@ -745,27 +747,8 @@ extern int __build_bug_on_failed;
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
-struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
 #endif /* __KERNEL__ */
 
-#define SI_LOAD_SHIFT	16
-struct sysinfo {
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
-};
-
 #endif
diff --git a/include/linux/sysinfo.h b/include/linux/sysinfo.h
new file mode 100644
index 0000000..ec4fc22
--- /dev/null
+++ b/include/linux/sysinfo.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_SYSINFO_H
+#define _LINUX_SYSINFO_H
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	long uptime;			/* Seconds since boot */
+	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
+	unsigned long totalram;		/* Total usable main memory size */
+	unsigned long freeram;		/* Available memory size */
+	unsigned long sharedram;	/* Amount of shared memory */
+	unsigned long bufferram;	/* Memory used by buffers */
+	unsigned long totalswap;	/* Total swap space size */
+	unsigned long freeswap;		/* swap space still available */
+	unsigned short procs;		/* Number of current processes */
+	unsigned short pad;		/* explicit padding for m68k */
+	unsigned long totalhigh;	/* Total high memory size */
+	unsigned long freehigh;		/* Available high memory size */
+	unsigned int mem_unit;		/* Memory unit size in bytes */
+	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
+};
+
+#endif /* _LINUX_SYSINFO_H */
-- 
1.7.6.5

