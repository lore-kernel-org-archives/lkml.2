Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0FECxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:53:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43030 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0FECxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 6/6] Make xtime and wall_to_monotonic static
Date: Fri,  4 Jun 2010 19:53:26 -0700
Message-Id: <1275706406-8111-7-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-3-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-4-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-5-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
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
index d18edd8..3d03d79 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -97,8 +97,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern struct timespec xtime;
-extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8600218..a68297a 100644
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

