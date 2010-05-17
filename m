Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0EQWlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:41:22 -0400
Received: from mail.df.lth.se ([194.47.250.12]:45443 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756573Ab0EQWlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:41:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/3] DMAENGINE: extend the control command to include an arg
Date: Tue, 18 May 2010 00:41:32 +0200
Message-Id: <1274136092-12375-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an argument to the DMAengine control function, so that
we can later provide control commands that need some external data
passed in through an argument akin to the ioctl() operation
prototype.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/at_hdmac.c       |    3 ++-
 drivers/dma/coh901318.c      |    3 ++-
 drivers/dma/dw_dmac.c        |    3 ++-
 drivers/dma/fsldma.c         |    2 +-
 drivers/dma/ipu/ipu_idmac.c  |    3 ++-
 drivers/dma/shdma.c          |    3 ++-
 drivers/dma/ste_dma40.c      |    3 ++-
 drivers/dma/timb_dma.c       |    3 ++-
 drivers/dma/txx9dmac.c       |    3 ++-
 drivers/mmc/host/atmel-mci.c |    2 +-
 drivers/serial/sh-sci.c      |    2 +-
 drivers/video/mx3fb.c        |    2 +-
 include/linux/dmaengine.h    |    3 ++-
 sound/soc/txx9/txx9aclc.c    |    7 ++++---
 14 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6693b13..e8ef137 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -760,7 +760,8 @@ err_desc_get:
 	return NULL;
 }
 
-static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd
+		       unsigned long arg)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 4233440..534cd76 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1176,7 +1176,8 @@ coh901318_issue_pending(struct dma_chan *chan)
 }
 
 static int
-coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		  unsigned long arg)
 {
 	unsigned long flags;
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 18fb5b4..a3991ab 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -781,7 +781,8 @@ err_desc_get:
 	return NULL;
 }
 
-static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		       unsigned long arg)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6a853e9..1fdf180 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -776,7 +776,7 @@ fail:
 }
 
 static int fsl_dma_device_control(struct dma_chan *dchan,
-				  enum dma_ctrl_cmd cmd)
+				  enum dma_ctrl_cmd cmd, unsigned long arg)
 {
 	struct fsldma_chan *chan;
 	unsigned long flags;
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 246a614..7f84075 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1472,7 +1472,8 @@ static void idmac_issue_pending(struct dma_chan *chan)
 	 */
 }
 
-static int __idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int __idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			   unsigned long arg)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac *idmac = to_idmac(chan->device);
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 4913bb8..544340d 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -581,7 +581,8 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 			       direction, flags);
 }
 
-static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			   unsigned long arg)
 {
 	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 81fec95..c426829 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2065,7 +2065,8 @@ static void d40_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
-static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		       unsigned long arg)
 {
 	unsigned long flags;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 44b346d..0172fa3 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -611,7 +611,8 @@ static struct dma_async_tx_descriptor *td_prep_slave_sg(struct dma_chan *chan,
 	return &td_desc->txd;
 }
 
-static int td_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int td_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		      unsigned long arg)
 {
 	struct timb_dma_chan *td_chan =
 		container_of(chan, struct timb_dma_chan, chan);
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index e523737..d02edb0 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -938,7 +938,8 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	return &first->txd;
 }
 
-static int txx9dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
+static int txx9dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			    unsigned long arg)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
 	struct txx9dmac_desc *desc, *_desc;
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 52f5068..c293ac4 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -579,7 +579,7 @@ static void atmci_stop_dma(struct atmel_mci *host)
 	struct dma_chan *chan = host->data_chan;
 
 	if (chan) {
-		chan->device->device_control(chan, DMA_TERMINATE_ALL);
+	  chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 		atmci_dma_cleanup(host);
 	} else {
 		/* Data transfer was stopped by the interrupt handler */
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 55484fb..8bddc70 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1084,7 +1084,7 @@ static void work_fn_rx(struct work_struct *work)
 		unsigned long flags;
 		int count;
 
-		chan->device->device_control(chan, DMA_TERMINATE_ALL);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 		dev_dbg(port->dev, "Read %u bytes with cookie %d\n",
 			sh_desc->partial, sh_desc->cookie);
 
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 3aa50bc..7cfc170 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -388,7 +388,7 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 	spin_unlock_irqrestore(&mx3fb->lock, flags);
 
 	mx3_fbi->txd->chan->device->device_control(mx3_fbi->txd->chan,
-						   DMA_TERMINATE_ALL);
+						   DMA_TERMINATE_ALL, 0);
 	mx3_fbi->txd = NULL;
 	mx3_fbi->cookie = -EINVAL;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index e03defa..58a16e4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -408,7 +408,8 @@ struct dma_device {
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
 		unsigned long flags);
-	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd);
+	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		unsigned long arg);
 
 	enum dma_status (*device_tx_status)(struct dma_chan *chan,
 					    dma_cookie_t cookie,
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 7082cb8..0e34523 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -160,7 +160,7 @@ static void txx9aclc_dma_tasklet(unsigned long data)
 		void __iomem *base = drvdata->base;
 
 		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		chan->device->device_control(chan, DMA_TERMINATE_ALL);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 		/* first time */
 		for (i = 0; i < NR_DMA_CHAIN; i++) {
 			desc = txx9aclc_dma_submit(dmadata,
@@ -268,7 +268,7 @@ static int txx9aclc_pcm_close(struct snd_pcm_substream *substream)
 	struct dma_chan *chan = dmadata->dma_chan;
 
 	dmadata->frag_count = -1;
-	chan->device->device_control(chan, DMA_TERMINATE_ALL);
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 	return 0;
 }
 
@@ -397,7 +397,8 @@ static int txx9aclc_pcm_remove(struct platform_device *pdev)
 		struct dma_chan *chan = dmadata->dma_chan;
 		if (chan) {
 			dmadata->frag_count = -1;
-			chan->device->device_control(chan, DMA_TERMINATE_ALL);
+			chan->device->device_control(chan,
+						     DMA_TERMINATE_ALL, 0);
 			dma_release_channel(chan);
 		}
 		dev->dmadata[i].dma_chan = NULL;
-- 
1.7.0.1

