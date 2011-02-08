Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1BHVUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:20:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40423 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1BHVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:20:13 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH] RTC: ARM: sa1100: Remove IRQ_RTC1Hz interrupt, UIE is now emulated with AIE.
Date: Tue,  8 Feb 2011 19:19:53 -0200
Message-Id: <1297199993-12742-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since update interrupts are now emulated using alarm interrupts, there
is no need to set up hardware update interrupts. This patch removes the
corresponding code.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 37b102c..fe4eed7 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -161,12 +161,6 @@ static int sa1100_rtc_open(struct device *dev)
 	struct platform_device *plat_dev = to_platform_device(dev);
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
-	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
-		"rtc 1Hz", dev);
-	if (ret) {
-		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
-		goto fail_ui;
-	}
 	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, IRQF_DISABLED,
 		"rtc Alrm", dev);
 	if (ret) {
@@ -179,8 +173,6 @@ static int sa1100_rtc_open(struct device *dev)
 	return 0;
 
  fail_ai:
-	free_irq(IRQ_RTC1Hz, dev);
- fail_ui:
 	return ret;
 }
 
@@ -193,10 +185,8 @@ static void sa1100_rtc_release(struct device *dev)
 	spin_unlock_irq(&sa1100_rtc_lock);
 
 	free_irq(IRQ_RTCAlrm, dev);
-	free_irq(IRQ_RTC1Hz, dev);
 }
 
-
 static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	spin_lock_irq(&sa1100_rtc_lock);
-- 
1.7.3.4

