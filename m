Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031591Ab2COQGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:06:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:14257 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030571Ab2COQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:05:58 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/6] mmc: atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA
Date: Thu, 15 Mar 2012 16:57:19 +0100
Message-Id: <c7df6b7863557d95bb8457f5c2b4002ea44c86ff.1331826095.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Kconfig option is not needed anymore, so remove it.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/Kconfig     |   10 ----------
 drivers/mmc/host/atmel-mci.c |    2 --
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 455a414..a6fc44a 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -288,16 +288,6 @@ config MMC_ATMELMCI
 
 	  If unsure, say N.
 
-config MMC_ATMELMCI_DMA
-	bool "Atmel MCI DMA support"
-	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
-	help
-	  Say Y here to have the Atmel MCI driver use a DMA engine to
-	  do data transfers and thus increase the throughput and
-	  reduce the CPU utilization.
-
-	  If unsure, say N.
-
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
 	depends on ARCH_MX1
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e4449a5..b5693fd 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2164,10 +2164,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
-- 
1.7.9

