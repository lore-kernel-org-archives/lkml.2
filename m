Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1EGTQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:16:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54474 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1EGTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:16:13 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3 10/12] omap_hsmmc: use original sg_len for dma_unmap_sg
Date: Sat,  7 May 2011 21:15:04 +0200
Message-Id: <1304795706-27308-11-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
References: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use the returned sg_len from dma_map_sg() as inparameter
to dma_unmap_sg(). Use the original sg_len for both dma_map_sg
and dma_unmap_sg.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/host/omap_hsmmc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 259ece0..ad3731a 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -959,7 +959,8 @@ static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
 	spin_unlock(&host->irq_lock);
 
 	if (host->use_dma && dma_ch != -1) {
-		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
+		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg,
+			host->data->sg_len,
 			omap_hsmmc_get_dma_dir(host, host->data));
 		omap_free_dma(dma_ch);
 	}
@@ -1343,7 +1344,7 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
 		return;
 	}
 
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 		omap_hsmmc_get_dma_dir(host, data));
 
 	req_in_progress = host->req_in_progress;
-- 
1.7.4.1

