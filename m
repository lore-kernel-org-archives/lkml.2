Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967803Ab2EQWOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:14:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:46382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116Ab2EQWOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320398"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 03/10] Use __kernel_[u]long_t in linux/resource.h
Date: Thu, 17 May 2012 15:13:29 -0700
Message-Id: <1337292816-10839-4-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace long with __kernel_long_t in struct rusage and replace
unsigned long with __kernel_ulong_t in struct rlimit for usr space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/linux/resource.h |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index d01c96c..38bbb6a 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -23,25 +23,25 @@
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
-	long	ru_maxrss;		/* maximum resident set size */
-	long	ru_ixrss;		/* integral shared memory size */
-	long	ru_idrss;		/* integral unshared data size */
-	long	ru_isrss;		/* integral unshared stack size */
-	long	ru_minflt;		/* page reclaims */
-	long	ru_majflt;		/* page faults */
-	long	ru_nswap;		/* swaps */
-	long	ru_inblock;		/* block input operations */
-	long	ru_oublock;		/* block output operations */
-	long	ru_msgsnd;		/* messages sent */
-	long	ru_msgrcv;		/* messages received */
-	long	ru_nsignals;		/* signals received */
-	long	ru_nvcsw;		/* voluntary context switches */
-	long	ru_nivcsw;		/* involuntary " */
+	__kernel_long_t ru_maxrss;	/* maximum resident set size */
+	__kernel_long_t ru_ixrss;	/* integral shared memory size */
+	__kernel_long_t ru_idrss;	/* integral unshared data size */
+	__kernel_long_t ru_isrss;	/* integral unshared stack size */
+	__kernel_long_t ru_minflt;	/* page reclaims */
+	__kernel_long_t ru_majflt;	/* page faults */
+	__kernel_long_t ru_nswap;	/* swaps */
+	__kernel_long_t ru_inblock;	/* block input operations */
+	__kernel_long_t ru_oublock;	/* block output operations */
+	__kernel_long_t ru_msgsnd;	/* messages sent */
+	__kernel_long_t ru_msgrcv;	/* messages received */
+	__kernel_long_t ru_nsignals;	/* signals received */
+	__kernel_long_t ru_nvcsw;	/* voluntary context switches */
+	__kernel_long_t ru_nivcsw;	/* involuntary " */
 };
 
 struct rlimit {
-	unsigned long	rlim_cur;
-	unsigned long	rlim_max;
+	__kernel_ulong_t rlim_cur;
+	__kernel_ulong_t rlim_max;
 };
 
 #define RLIM64_INFINITY		(~0ULL)
-- 
1.7.6.5

