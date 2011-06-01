Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab1FAHdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:33:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60915 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161015Ab1FAHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:32:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] clocksource: parisc: convert to clocksource_register_hz/khz
Date: Wed,  1 Jun 2011 00:32:46 -0700
Message-Id: <1306913570-9445-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

This converts the parisc clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/parisc/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 45b7389..7c07743 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -198,8 +198,6 @@ static struct clocksource clocksource_cr16 = {
 	.rating			= 300,
 	.read			= read_cr16,
 	.mask			= CLOCKSOURCE_MASK(BITS_PER_LONG),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -270,7 +268,5 @@ void __init time_init(void)
 
 	/* register at clocksource framework */
 	current_cr16_khz = PAGE0->mem_10msec/10;  /* kHz */
-	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
-						clocksource_cr16.shift);
-	clocksource_register(&clocksource_cr16);
+	clocksource_register_khz(&clocksource_cr16, current_cr16_khz);
 }
-- 
1.7.3.2.146.gca209

