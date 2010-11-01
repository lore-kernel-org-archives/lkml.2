Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0KAUNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:13:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41519 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0KAUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:13:33 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/10] parisc: convert to clocksource_register_hz/khz
Date: Mon,  1 Nov 2010 13:12:25 -0700
Message-Id: <1288642350-1599-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the parisc clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/parisc/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..8bfff4a 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -201,8 +201,6 @@ static struct clocksource clocksource_cr16 = {
 	.rating			= 300,
 	.read			= read_cr16,
 	.mask			= CLOCKSOURCE_MASK(BITS_PER_LONG),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -273,7 +271,5 @@ void __init time_init(void)
 
 	/* register at clocksource framework */
 	current_cr16_khz = PAGE0->mem_10msec/10;  /* kHz */
-	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
-						clocksource_cr16.shift);
-	clocksource_register(&clocksource_cr16);
+	clocksource_register_khz(&clocksource_cr16, current_cr16_khz);
 }
-- 
1.7.3.2.146.gca209

