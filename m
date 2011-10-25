Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1JYSJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:09:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53413 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1JYSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:09:21 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>
Subject: [PATCH 8/8] clocksource: hyperv: Convert to clocksource_register_khz
Date: Tue, 25 Oct 2011 11:08:16 -0700
Message-Id: <1319566096-3222-8-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
x-cbid: 11102518-1780-0000-0000-000000773700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

Convert to using clocksource_register_khz

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: K. Y. Srinivasan <ksrinivasan@novell.com>
---
 drivers/staging/hv/hv_timesource.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
index 2b0f9aa..0379b2d 100644
--- a/drivers/staging/hv/hv_timesource.c
+++ b/drivers/staging/hv/hv_timesource.c
@@ -50,14 +50,6 @@ static struct clocksource hyperv_cs = {
 	.rating         = 400, /* use this when running on Hyperv*/
 	.read           = read_hv_clock,
 	.mask           = CLOCKSOURCE_MASK(64),
-	/*
-	 * The time ref counter in HyperV is in 100ns units.
-	 * The definition of mult is:
-	 * mult/2^shift = ns/cyc = 100
-	 * mult = (100 << shift)
-	 */
-	.mult           = (100 << HV_CLOCK_SHIFT),
-	.shift          = HV_CLOCK_SHIFT,
 };
 
 static const struct dmi_system_id __initconst
@@ -92,7 +84,7 @@ static int __init init_hv_clocksource(void)
 		return -ENODEV;
 
 	pr_info("Registering HyperV clock source\n");
-	return clocksource_register(&hyperv_cs);
+	return clocksource_register_khz(&hyperv_cs, 10000);
 }
 
 module_init(init_hv_clocksource);
-- 
1.7.3.2.146.gca209

