Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2LRJmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:42:07 -0500
Received: from www84.your-server.de ([213.133.104.84]:50078 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2LRJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:04 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 5/6] Cleanup header files to build a proper 32 bit VDSO
Date: Tue, 18 Dec 2012 10:40:55 +0100
Message-Id: <1355823656-13902-6-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

To build a proper VDSO for 64 bit and 32 bit from the same source, some
header cleanup is necessary, otherwise a "gcc -m32" will produce a lot
of errors and warnings due the differents with LP64 and LP32.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/mm/init_32.c               | 1 +
 include/linux/clocksource.h         | 1 -
 include/linux/time.h                | 3 +--
 include/linux/timekeeper_internal.h | 1 +
 include/linux/types.h               | 2 ++
 5 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..394e563 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -52,6 +52,7 @@
 #include <asm/cacheflush.h>
 #include <asm/page_types.h>
 #include <asm/init.h>
+#include <asm/numa_32.h>
 
 unsigned long highstart_pfn, highend_pfn;
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4dceaf8..84ed093 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -19,7 +19,6 @@
 #include <asm/io.h>
 
 /* clocksource cycle base type */
-typedef u64 cycle_t;
 struct clocksource;
 
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..edfab8a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -2,9 +2,8 @@
 #define _LINUX_TIME_H
 
 # include <linux/cache.h>
-# include <linux/seqlock.h>
 # include <linux/math64.h>
-#include <uapi/linux/time.h>
+# include <uapi/linux/time.h>
 
 extern struct timezone sys_tz;
 
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index e1d558e..9a55a0c 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -9,6 +9,7 @@
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
+#include <linux/seqlock.h>
 
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
diff --git a/include/linux/types.h b/include/linux/types.h
index 1cc0e4b..3ff59cf 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -74,6 +74,8 @@ typedef __kernel_time_t		time_t;
 typedef __kernel_clock_t	clock_t;
 #endif
 
+typedef u64 cycle_t;
+
 #ifndef _CADDR_T
 #define _CADDR_T
 typedef __kernel_caddr_t	caddr_t;
-- 
1.8.0

