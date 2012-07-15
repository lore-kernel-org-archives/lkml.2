Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2GOI5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:57:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2GOI5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:57:18 -0400
Date: Sun, 15 Jul 2012 01:57:00 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-fee84c43e6afc42295ae8058cbbef9ea5633926c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1342156917-25092-4-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-4-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time:
  Explicitly use u32 instead of int for shift values
Git-Commit-ID: fee84c43e6afc42295ae8058cbbef9ea5633926c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 01:57:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fee84c43e6afc42295ae8058cbbef9ea5633926c
Gitweb:     http://git.kernel.org/tip/fee84c43e6afc42295ae8058cbbef9ea5633926c
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:52 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:05 +0200

time: Explicitly use u32 instead of int for shift values

Ingo noted that using a u32 instead of int for shift values
would be better to make sure the compiler doesn't unnecessarily
use complex signed arithmetic.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-4-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
