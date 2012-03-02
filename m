Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275Ab2CBHNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:24 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60042 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CBHNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 9/9] time: Explicitly use u32 instead of int for shift values
Date: Thu,  1 Mar 2012 23:12:48 -0800
Message-Id: <1330672368-32290-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-5518-0000-0000-000002AC7114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted that using a u32 instead of int for shift values
would be better to make sure the compiler doesn't unnecessarily
use complex signed arithmetic.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 67983ff..60351a8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,7 +28,7 @@ struct timekeeper {
 	/* NTP adjusted clock multiplier */
 	u32			mult;
 	/* The shift value of the current clocksource. */
-	int			shift;
+	u32			shift;
 	/* cycle value at last accumulation point */
 	cycle_t			cycle_last;
 	/* Number of clock cycles in one NTP interval. */
@@ -48,7 +48,7 @@ struct timekeeper {
 	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
-	int			ntp_error_shift;
+	u32			ntp_error_shift;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -1016,7 +1016,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
  * Returns the unconsumed cycles.
  */
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
-						int shift)
+					u32 shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
 	u64 raw_nsecs;
-- 
1.7.3.2.146.gca209

