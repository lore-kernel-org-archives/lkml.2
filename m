Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1LAHUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:20:54 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56603 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1LAHUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:20:53 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 2/3] clocksource: dbx500: convert to clocksource_register_hz()
Date: Thu,  1 Dec 2011 15:20:15 +0800
Message-Id: <1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert clocksource_dbx500_prcmu to use clocksource_register_hz.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 59feefe..74e8901 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -52,7 +52,6 @@ static struct clocksource clocksource_dbx500_prcmu = {
 	.name		= "dbx500-prcmu-timer",
 	.rating		= 300,
 	.read		= clksrc_dbx500_prcmu_read,
-	.shift		= 10,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -100,7 +99,5 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 	init_sched_clock(&cd, clksrc_dbx500_prcmu_update_sched_clock,
 			 32, RATE_32K);
 #endif
-	clocksource_calc_mult_shift(&clocksource_dbx500_prcmu,
-				    RATE_32K, SCHED_CLOCK_MIN_WRAP);
-	clocksource_register(&clocksource_dbx500_prcmu);
+	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
 }
-- 
1.7.5.4

