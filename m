Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1F3Jwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:52:50 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54087 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab1F3Jvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:41 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 7/7] rtc: twl: move to threaded irq
Date: Thu, 30 Jun 2011 12:51:10 +0300
Message-Id: <1309427470-605-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple trivial conversion to threaded_irq.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/rtc/rtc-twl.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index f9a2799..eca0502 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -362,14 +362,6 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
@@ -462,7 +454,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl_rtc_interrupt,
+	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
 				IRQF_TRIGGER_RISING,
 				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
-- 
1.7.6

