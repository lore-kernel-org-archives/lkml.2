Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0G0Ksp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:48:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:34782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0Ksn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:48:43 -0400
Date: Tue, 27 Jul 2010 10:48:26 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] timekeeping: Make xtime and wall_to_monotonic static
Message-ID: <tip-0fb86b06298b6cd3205cac2e68a499f269282dac@git.kernel.org>
Git-Commit-ID: 0fb86b06298b6cd3205cac2e68a499f269282dac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:48:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fb86b06298b6cd3205cac2e68a499f269282dac
Gitweb:     http://git.kernel.org/tip/0fb86b06298b6cd3205cac2e68a499f269282dac
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:26 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:55 +0200

timekeeping: Make xtime and wall_to_monotonic static

This patch makes xtime and wall_to_monotonic static, as planned in
Documentation/feature-removal-schedule.txt. This will allow for
further cleanups to the timekeeping core.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 Documentation/feature-removal-schedule.txt |   10 ----------
 include/linux/time.h                       |    2 --
 kernel/time/timekeeping.c                  |    4 ++--
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1571c0c..cd648db 100644
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
index a57e0f6..cb34e35 100644
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
