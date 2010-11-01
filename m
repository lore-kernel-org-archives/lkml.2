Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0KAUPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:15:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:32836 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0KAUNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:13:17 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Michal Simek <monstr@monstr.eu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/10] microblaze: convert to clocksource_register_hz/khz
Date: Mon,  1 Nov 2010 13:12:26 -0700
Message-Id: <1288642350-1599-7-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the microblaze clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Michal Simek <monstr@monstr.eu>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/microblaze/kernel/timer.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index a5aa33d..68ec7d1 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -217,16 +217,12 @@ static struct clocksource clocksource_microblaze = {
 	.rating		= 300,
 	.read		= microblaze_read,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 8, /* I can shift it */
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init microblaze_clocksource_init(void)
 {
-	clocksource_microblaze.mult =
-			clocksource_hz2mult(timer_clock_freq,
-						clocksource_microblaze.shift);
-	if (clocksource_register(&clocksource_microblaze))
+	if (clocksource_register_hz(&clocksource_microblaze, timer_clock_freq))
 		panic("failed to register clocksource");
 
 	/* stop timer1 */
-- 
1.7.3.2.146.gca209

