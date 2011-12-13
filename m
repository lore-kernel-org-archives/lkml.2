Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1LMPka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:40:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57384 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1LMPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:40:26 -0500
From: Shawn Guo <shawn.guo@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/4] mmc: mxs-mmc: fix the dma_transfer_direction migration
Date: Tue, 13 Dec 2011 23:48:04 +0800
Message-Id: <1323791286-29574-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 05f5799 (mmc-host: move to dma_transfer_direction) left out
the DMA_NONE, in turn breaks the driver as below.

[    0.650000] mxs-mmc mxs-mmc.0: initialized
[    0.650000] mxs-mmc mxs-mmc.1: initialized
[    0.690000] mxs-dma mxs-dma-apbh: maximum bytes for sg entry exceeded: -55906
7475 > 65280
[    0.690000] mxs-mmc mxs-mmc.0: mxs_mmc_ac: failed to prep dma

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/mxs-mmc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 571c9ff..93c18aa 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -357,6 +357,7 @@ static void mxs_mmc_bc(struct mxs_mmc_host *host)
 	host->ssp_pio_words[1] = cmd0;
 	host->ssp_pio_words[2] = cmd1;
 	host->dma_dir = DMA_NONE;
+	host->slave_dirn = DMA_TRANS_NONE;
 	desc = mxs_mmc_prep_dma(host, 0);
 	if (!desc)
 		goto out;
@@ -396,6 +397,7 @@ static void mxs_mmc_ac(struct mxs_mmc_host *host)
 	host->ssp_pio_words[1] = cmd0;
 	host->ssp_pio_words[2] = cmd1;
 	host->dma_dir = DMA_NONE;
+	host->slave_dirn = DMA_TRANS_NONE;
 	desc = mxs_mmc_prep_dma(host, 0);
 	if (!desc)
 		goto out;
@@ -514,6 +516,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 	host->ssp_pio_words[1] = cmd0;
 	host->ssp_pio_words[2] = cmd1;
 	host->dma_dir = DMA_NONE;
+	host->slave_dirn = DMA_TRANS_NONE;
 	desc = mxs_mmc_prep_dma(host, 0);
 	if (!desc)
 		goto out;
-- 
1.7.4.1

