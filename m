Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2ASGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:16:26 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:35289
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab2ASGPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:36 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 08/10] MXS-MMC : use the new DMA flags
Date: Thu, 19 Jan 2012 14:16:05 +0800
Message-ID: <1326953767-24155-9-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new DMA flags while do not change any logic.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mmc/host/mxs-mmc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 1e18970..be8fbbc 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -305,7 +305,7 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void *dev_id)
 }
 
 static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
-	struct mxs_mmc_host *host, unsigned int append)
+	struct mxs_mmc_host *host, unsigned long flags)
 {
 	struct dma_async_tx_descriptor *desc;
 	struct mmc_data *data = host->data;
@@ -325,7 +325,7 @@ static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
 	}
 
 	desc = host->dmach->device->device_prep_slave_sg(host->dmach,
-				sgl, sg_len, host->slave_dirn, append);
+				sgl, sg_len, host->slave_dirn, flags);
 	if (desc) {
 		desc->callback = mxs_mmc_dma_irq_callback;
 		desc->callback_param = host;
@@ -358,7 +358,7 @@ static void mxs_mmc_bc(struct mxs_mmc_host *host)
 	host->ssp_pio_words[2] = cmd1;
 	host->dma_dir = DMA_NONE;
 	host->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, 0);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_F_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -398,7 +398,7 @@ static void mxs_mmc_ac(struct mxs_mmc_host *host)
 	host->ssp_pio_words[2] = cmd1;
 	host->dma_dir = DMA_NONE;
 	host->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, 0);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_F_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -526,7 +526,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 	host->data = data;
 	host->dma_dir = dma_data_dir;
 	host->slave_dirn = slave_dirn;
-	desc = mxs_mmc_prep_dma(host, 1);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_F_LASTONE);
 	if (!desc)
 		goto out;
 
-- 
1.7.0.4


