Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1KMXVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:21:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:45142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1KMXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:50 -0500
Message-Id: <20111113231341.672817969@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 4/7] timekeeper: Reorder so the hot data is together
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=timekeeper-reorder.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep all the interesting data in a single cache line.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -27,6 +27,8 @@ struct timekeeper {
 	struct clocksource *clock;
 	/* The shift value of the current clocksource. */
 	int	shift;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
 
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t cycle_interval;
@@ -45,8 +47,6 @@ struct timekeeper {
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	int	ntp_error_shift;
-	/* NTP adjusted clock multiplier */
-	u32	mult;
 };
 
 static struct timekeeper timekeeper;


