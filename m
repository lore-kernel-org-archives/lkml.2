Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1IVJFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:05:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1IVJFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:05:16 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Tony Lindgren <tony@atomide.com>,
        Kishore Kadiyala <kishore.kadiyala@ti.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Balaji T K <balajitk@ti.com>,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH 37/55] mmc: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:04 +0800
Message-Id: <1316681962-8217-38-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mmc/host/omap_hsmmc.c |    5 ++---
 drivers/mmc/host/tmio_mmc.c   |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 21e4a79..75c6395 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2015,7 +2015,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	}
 
 	/* Request IRQ for MMC operations */
-	ret = request_irq(host->irq, omap_hsmmc_irq, IRQF_DISABLED,
+	ret = request_irq(host->irq, omap_hsmmc_irq, 0,
 			mmc_hostname(mmc), host);
 	if (ret) {
 		dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
@@ -2043,8 +2043,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	if ((mmc_slot(host).card_detect_irq)) {
 		ret = request_irq(mmc_slot(host).card_detect_irq,
 				  omap_hsmmc_cd_handler,
-				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
-					  | IRQF_DISABLED,
+				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				  mmc_hostname(mmc), host);
 		if (ret) {
 			dev_dbg(mmc_dev(host->mmc),
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 44a9668..a4ea102 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -88,8 +88,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
 	if (ret)
 		goto cell_disable;
 
-	ret = request_irq(irq, tmio_mmc_irq, IRQF_DISABLED |
-			  IRQF_TRIGGER_FALLING, dev_name(&pdev->dev), host);
+	ret = request_irq(irq, tmio_mmc_irq, IRQF_TRIGGER_FALLING,
+				dev_name(&pdev->dev), host);
 	if (ret)
 		goto host_remove;
 
-- 
1.7.4.1

