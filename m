Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031586Ab2COP6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:58:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:22776 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668Ab2COP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:58:28 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/6] dmaengine: Kconfig: fix Atmel at_hdmac entry
Date: Thu, 15 Mar 2012 16:57:17 +0100
Message-Id: <7cdf1e94a17a7d872cb1eeaef812aab25b3caf40.1331826095.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove SoC dependency and make it generic for every Atmel ARM AT91. That will
allow to select this driver for newer chips. Keep dependency on AT91 because of
the use of an header file located in include/mach directory.
Modify the comment to reflect this.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f1a2749..6d50f35 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -91,11 +91,10 @@ config DW_DMAC
 
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
-	depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
+	depends on ARCH_AT91
 	select DMA_ENGINE
 	help
-	  Support the Atmel AHB DMA controller.  This can be integrated in
-	  chips such as the Atmel AT91SAM9RL.
+	  Support the Atmel AHB DMA controller.
 
 config FSL_DMA
 	tristate "Freescale Elo and Elo Plus DMA support"
-- 
1.7.9

