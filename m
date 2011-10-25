Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1JYSLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:11:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38876 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab1JYSLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:11:07 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/8] clocksource: parisc: Convert to clocksource_register_hz/khz
Date: Tue, 25 Oct 2011 11:08:10 -0700
Message-Id: <1319566096-3222-2-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
x-cbid: 11102518-8974-0000-0000-00000118BA31
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

