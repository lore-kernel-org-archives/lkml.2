Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0LTXRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:17:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49662 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab0LTXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:17:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67624263"
From: Daniel Walker <dwalker@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 2/5] mmc: msm: convert int bools to actual bool type
Date: Mon, 20 Dec 2010 15:16:48 -0800
Message-Id: <1292887011-30006-2-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many variables in this MMC driver are used like bools but
have int types. It's better to use the actual bool type for
readability and optimization. This converts all these types
of variables to actual the bool type.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   28 ++++++++++++++--------------
 drivers/mmc/host/msm_sdcc.h |   10 +++++-----
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index d6ac82c..01bb684 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -79,7 +79,7 @@ msmsdcc_disable_clocks(struct msmsdcc_host *host, int deferr)
 		if (host->clks_on) {
 			clk_disable(host->clk);
 			clk_disable(host->pclk);
-			host->clks_on = 0;
+			host->clks_on = false;
 		}
 	}
 }
@@ -106,7 +106,7 @@ msmsdcc_enable_clocks(struct msmsdcc_host *host)
 		}
 		udelay(1 + ((3 * USEC_PER_SEC) /
 		       (host->clk_rate ? host->clk_rate : msmsdcc_fmin)));
-		host->clks_on = 1;
+		host->clks_on = true;
 	}
 	return 0;
 }
@@ -158,7 +158,7 @@ static void
 msmsdcc_stop_data(struct msmsdcc_host *host)
 {
 	host->curr.data = NULL;
-	host->curr.got_dataend = host->curr.got_datablkend = 0;
+	host->curr.got_dataend = host->curr.got_datablkend = false;
 }
 
 uint32_t msmsdcc_fifo_addr(struct msmsdcc_host *host)
@@ -188,7 +188,7 @@ msmsdcc_dma_exec_func(struct msm_dmov_cmd *cmd)
 					   (u32) host->cmd_cmd->arg,
 					   (u32) host->cmd_c);
 	}
-	host->dma.active = 1;
+	host->dma.active = true;
 }
 
 static void
@@ -203,7 +203,7 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 	struct mmc_request	*mrq;
 
 	spin_lock_irqsave(&host->lock, flags);
-	host->dma.active = 0;
+	host->dma.active = false;
 
 	mrq = host->curr.mrq;
 	BUG_ON(!mrq);
@@ -243,7 +243,7 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 	}
 
 	host->dma.sg = NULL;
-	host->dma.busy = 0;
+	host->dma.busy = false;
 
 	if ((host->curr.got_dataend && host->curr.got_datablkend)
 	     || mrq->data->error) {
@@ -452,8 +452,8 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 	host->curr.xfer_size = data->blksz * data->blocks;
 	host->curr.xfer_remain = host->curr.xfer_size;
 	host->curr.data_xfered = 0;
-	host->curr.got_dataend = 0;
-	host->curr.got_datablkend = 0;
+	host->curr.got_dataend = false;
+	host->curr.got_datablkend = false;
 
 	memset(&host->pio, 0, sizeof(host->pio));
 
@@ -490,7 +490,7 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 
 		host->dma.hdr.execute_func = msmsdcc_dma_exec_func;
 		host->dma.hdr.data = (void *)host;
-		host->dma.busy = 1;
+		host->dma.busy = true;
 
 		if (cmd) {
 			msmsdcc_start_command_deferred(host, cmd, &c);
@@ -749,10 +749,10 @@ msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
 
 	/* Check for data done */
 	if (!host->curr.got_dataend && (status & MCI_DATAEND))
-		host->curr.got_dataend = 1;
+		host->curr.got_dataend = true;
 
 	if (!host->curr.got_datablkend && (status & MCI_DATABLOCKEND))
-		host->curr.got_datablkend = 1;
+		host->curr.got_datablkend = true;
 
 	/*
 	 * If DMA is still in progress, we complete via the completion handler
@@ -789,7 +789,7 @@ msmsdcc_irq(int irq, void *dev_id)
 	void __iomem		*base = host->base;
 	u32			status;
 	int			ret = 0;
-	int			cardint = 0;
+	bool			cardint = false;
 
 	spin_lock(&host->lock);
 
@@ -808,7 +808,7 @@ msmsdcc_irq(int irq, void *dev_id)
 		msmsdcc_handle_irq_data(host, status, base);
 
 		if (status & MCI_SDIOINTOPER) {
-			cardint = 1;
+			cardint = true;
 			status &= ~MCI_SDIOINTOPER;
 		}
 		ret = 1;
@@ -1107,7 +1107,7 @@ msmsdcc_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->curr.cmd = NULL;
 
-	host->cmdpoll = 1;
+	host->cmdpoll = true;
 
 	host->base = ioremap(memres->start, PAGE_SIZE);
 	if (!host->base) {
diff --git a/drivers/mmc/host/msm_sdcc.h b/drivers/mmc/host/msm_sdcc.h
index ff2b0f7..57db07f 100644
--- a/drivers/mmc/host/msm_sdcc.h
+++ b/drivers/mmc/host/msm_sdcc.h
@@ -170,8 +170,8 @@ struct msmsdcc_dma_data {
 
 	int				channel;
 	struct msmsdcc_host		*host;
-	int				busy; /* Set if DM is busy */
-	int				active;
+	bool				busy; /* Set if DM is busy */
+	bool				active;
 };
 
 struct msmsdcc_pio_data {
@@ -187,8 +187,8 @@ struct msmsdcc_curr_req {
 	unsigned int		xfer_size;	/* Total data size */
 	unsigned int		xfer_remain;	/* Bytes remaining to send */
 	unsigned int		data_xfered;	/* Bytes acked by BLKEND irq */
-	int			got_dataend;
-	int			got_datablkend;
+	bool			got_dataend;
+	bool			got_datablkend;
 	int			user_pages;
 };
 
@@ -232,7 +232,7 @@ struct msmsdcc_host {
 
 	struct msmsdcc_dma_data	dma;
 	struct msmsdcc_pio_data	pio;
-	int			cmdpoll;
+	bool			cmdpoll;
 	struct msmsdcc_stats	stats;
 
 	/* Command parameters */
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
