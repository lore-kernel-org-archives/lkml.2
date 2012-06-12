Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2FLI7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:59:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2FLI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:58:59 -0400
Message-ID: <4FD704CE.5010300@linaro.org>
Date: Tue, 12 Jun 2012 09:58:54 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Samuel Ortiz <sameo@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 03/14] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when requesting
 a threaded IRQ
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-4-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1339428307-3850-4-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

From: Lee Jones <lee.jones@linaro.org>
Date: Tue, 22 May 2012 15:13:13 +0100
Subject: [PATCH 03/14] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when requesting
 a threaded IRQ

The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index b86fd8e..b6cbc3ba 100644
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
