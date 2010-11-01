Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0KAUPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:15:03 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45211 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab0KAUNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:13:17 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/10] tile: convert to use clocksource_register_hz
Date: Mon,  1 Nov 2010 13:12:24 -0700
Message-Id: <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tile to use clocksource_register_hz.

Untested. Help from maintainers would be appreciated.

CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/tile/kernel/time.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 6bed820..8c06cb2 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -76,7 +76,6 @@ static struct clocksource cycle_counter_cs = {
 	.rating = 300,
 	.read = clocksource_get_cycles,
 	.mask = CLOCKSOURCE_MASK(64),
-	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -89,8 +88,6 @@ void __init setup_clock(void)
 	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
 	sched_clock_mult =
 		clocksource_hz2mult(cycles_per_sec, SCHED_CLOCK_SHIFT);
-	cycle_counter_cs.mult =
-		clocksource_hz2mult(cycles_per_sec, cycle_counter_cs.shift);
 }
 
 void __init calibrate_delay(void)
@@ -105,7 +102,7 @@ void __init calibrate_delay(void)
 void __init time_init(void)
 {
 	/* Initialize and register the clock source. */
-	clocksource_register(&cycle_counter_cs);
+	clocksource_register_hz(&cycle_counter_cs, cycles_per_sec);
 
 	/* Start up the tile-timer interrupt source on the boot cpu. */
 	setup_tile_timer();
-- 
1.7.3.2.146.gca209

