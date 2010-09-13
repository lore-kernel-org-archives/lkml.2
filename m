Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0IMIYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:24:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36959 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753903Ab0IMIYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:24:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mmc: Add architecture dependency for Marvell SoC controller
Date: Mon, 13 Sep 2010 09:24:39 +0100
Message-Id: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the driver is for controllers integrated into Marvells SoCs only
offer MMC_SDHCI_MV if we're building for one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mmc/host/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ce099c4..5fa4e2b 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -133,6 +133,7 @@ config MMC_SDHCI_CNS3XXX
 config MMC_SDHCI_MV
 	tristate "SDHCI support on Marvell's SoC"
 	depends on MMC_SDHCI
+	depends on (PLAT_PXA || PLAT_ORION)
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Secure Digital Host Controller Interface in
-- 
1.7.1

