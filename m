Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1GRWBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:01:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36488 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1GRWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:01:12 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Americo Wang <xiyou.wangcong@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch] fix a headers_check warning in include/linux/kernel.h
Date: Mon, 18 Jul 2011 18:00:57 -0400
Message-Id: <1311026457-23534-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
References: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For the sake of having a patch ready. I actually did it yesterday but did not
send it then. Cc'ed to the authors of the relevant macros; __FUNCTION__ was
actually exported since ages, but I really do not see why the kernel exports
this macros...

 - Arnaud

-- 
From: Arnaud Lacombe <lacombar@gmail.com>
Subject: linux/kernel.h: hide internal macros

Unexpose to userland the following macros
 - BUILD_BUG_ON.*
 - __FUNCTION__
 - NUMA_BUILD
 - COMPACTION_BUILD
 - REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/kernel.h |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 567a6f7..9a43ad7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -646,29 +646,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-struct sysinfo;
-extern int do_sysinfo(struct sysinfo *info);
-
-#endif /* __KERNEL__ */
-
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
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
@@ -736,4 +713,27 @@ extern int __build_bug_on_failed;
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
+struct sysinfo;
+extern int do_sysinfo(struct sysinfo *info);
+
+#endif /* __KERNEL__ */
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
 #endif
-- 
1.7.6.153.g78432

