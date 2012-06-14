Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2FNK2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:28:52 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58544 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab2FNK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:28:51 -0400
From: Felipe Balbi <balbi@ti.com>
To: a.zummo@towertech.it
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] rtc: twl: add missing IRQF_ONESHOT
Date: Thu, 14 Jun 2012 13:26:46 +0300
Message-Id: <1339669606-9579-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets rid of the following warning:

[    2.825378] genirq: Threaded irq requested with \
	handler=NULL and !ONESHOT for irq 363

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 258abea..c5d06fe 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				   dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-- 
1.7.10.4

