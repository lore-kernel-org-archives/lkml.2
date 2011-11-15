Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab1KOEE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38907 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab1KOEEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 05/16] time: Cleanup global variables and move them to the top
Date: Mon, 14 Nov 2011 20:03:55 -0800
Message-Id: <1321329846-14755-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-1976-0000-0000-0000037F03C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move global xtime_lock and timekeeping_suspended values up
to the top of timekeeping.c

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 19d160a..78872ba 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -73,6 +73,18 @@ struct timekeeper {
 
 static struct timekeeper timekeeper;
 
+/*
+ * This read-write spinlock protects us from races in SMP while
+ * playing with xtime.
+ */
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+
+
+/* flag for if timekeeping is suspended */
+int __read_mostly timekeeping_suspended;
+
+
+
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
  *
@@ -157,18 +169,6 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-/*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime.
- */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-
-
-
-/* flag for if timekeeping is suspended */
-int __read_mostly timekeeping_suspended;
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
-- 
1.7.3.2.146.gca209

