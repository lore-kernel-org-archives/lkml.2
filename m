Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0GNA4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:56:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40193 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0GNA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/11] Make xtime and wall_to_monotonic static
Date: Tue, 13 Jul 2010 17:56:26 -0700
Message-Id: <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes xtime and wall_to_monotonic static, as planned in
Documentation/feature-removal-schedule.txt. This will allow for
further cleanups to the timekeeping core.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>

---
 Documentation/feature-removal-schedule.txt |   10 ----------
 include/linux/time.h                       |    2 --
 kernel/time/timekeeping.c                  |    4 ++--
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c268783..0d91c6b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -549,16 +549,6 @@ Who:	Avi Kivity <avi@redhat.com>
 
 ----------------------------
 
-What:	xtime, wall_to_monotonic
-When:	2.6.36+
-Files:	kernel/time/timekeeping.c include/linux/time.h
-Why:	Cleaning up timekeeping internal values. Please use
-	existing timekeeping accessor functions to access
-	the equivalent functionality.
-Who:	John Stultz <johnstul@us.ibm.com>
-
-----------------------------
-
 What:	KVM kernel-allocated memory slots
 When:	July 2010
 Why:	Since 2.6.25, kvm supports user-allocated memory slots, which are
diff --git a/include/linux/time.h b/include/linux/time.h
index 3a9c0bf..50b3cb0 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -113,8 +113,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern struct timespec xtime;
-extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb61c2e..e14c839 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -153,8 +153,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  * - wall_to_monotonic is no longer the boot time, getboottime must be
  * used instead.
  */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+static struct timespec xtime __attribute__ ((aligned (16)));
+static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static struct timespec total_sleep_time;
 
 /*
-- 
1.6.0.4

