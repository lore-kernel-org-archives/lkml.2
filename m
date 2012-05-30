Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2E3Esw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:48:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2E3Esr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:48:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/22] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when requesting a threaded IRQ
Date: Wed, 30 May 2012 12:47:34 +0800
Message-Id: <1338353260-10097-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index c39fc71..358d502 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -599,7 +599,8 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 	/* Register interrupt  - SwAdcComplete */
 	ret = request_threaded_irq(gpadc->irq, NULL,
 		ab8500_bm_gpswadcconvend_handler,
-		IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc", gpadc);
+		IRQF_ONESHOT | IRQF_NO_SUSPEND | IRQF_SHARED,
+				"ab8500-gpadc", gpadc);
 	if (ret < 0) {
 		dev_err(gpadc->dev, "Failed to register interrupt, irq: %d\n",
 			gpadc->irq);
-- 
1.7.9.5

