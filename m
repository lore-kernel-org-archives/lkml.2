Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2GMFWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:22:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57640 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2GMFW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:28 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/8] time: Explicitly use u32 instead of int for shift values
Date: Fri, 13 Jul 2012 01:21:52 -0400
Message-Id: <1342156917-25092-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-8974-0000-0000-00000B1F551D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo noted that using a u32 instead of int for shift values
would be better to make sure the compiler doesn't unnecessarily
use complex signed arithmetic.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c2f12aa..4fd83df 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,7 +28,7 @@ struct timekeeper {
 	/* NTP adjusted clock multiplier */
 	u32			mult;
 	/* The shift value of the current clocksource. */
-	int			shift;
+	u32			shift;
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t			cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
@@ -45,7 +45,7 @@ struct timekeeper {
 	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
-	int			ntp_error_shift;
+	u32			ntp_error_shift;
 
 	/* The current time */
 	struct timespec 	xtime;
@@ -960,7 +960,7 @@ static void timekeeping_adjust(s64 offset)
  *
  * Returns the unconsumed cycles.
  */
-static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
+static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
-- 
1.7.9.5

