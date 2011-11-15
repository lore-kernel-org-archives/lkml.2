Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1KOEEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:43 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56614 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab1KOEEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/16] time: Reorder so the hot data is together
Date: Mon, 14 Nov 2011 20:04:01 -0800
Message-Id: <1321329846-14755-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-3270-0000-0000-000001BEA7A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Keep all the interesting data in a single cache line.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 810b974..b632678 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -25,6 +25,8 @@
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource *clock;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
 	/* The shift value of the current clocksource. */
 	int	shift;
 
@@ -45,8 +47,6 @@ struct timekeeper {
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	int	ntp_error_shift;
-	/* NTP adjusted clock multiplier */
-	u32	mult;
 
 	/* The current time */
 	struct timespec xtime;
-- 
1.7.3.2.146.gca209

