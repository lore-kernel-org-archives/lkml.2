Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1HEDrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:47:02 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:60322 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab1HEDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:46:59 -0400
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] mmc: dw_mmc: Fix DDR mode support.
Date: Fri,  5 Aug 2011 12:35:03 +0900
Message-Id: <1312515303-17169-1-git-send-email-tgih.jun@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Host driver can't get a hint of DDR mode through ios->ddr flag anymore.
ios->timing is currently used to inform DDR mode as a substitute.
And capability of MMC_CAP_MMC_HIGHSPEED is added for DDR support.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/host/dw_mmc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index d65511e..b412a1d 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -699,7 +699,7 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	/* DDR mode set */
-	if (ios->ddr) {
+	if (ios->timing == MMC_TIMING_UHS_DDR50) {
 		regs = mci_readl(slot->host, UHS_REG);
 		regs |= (0x1 << slot->id) << 16;
 		mci_writel(slot->host, UHS_REG, regs);
@@ -1646,7 +1646,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	if (host->pdata->quirks & DW_MCI_QUIRK_HIGHSPEED)
-		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
 
 #ifdef CONFIG_MMC_DW_IDMAC
 	mmc->max_segs = host->ring_size;
-- 
1.7.0.4

