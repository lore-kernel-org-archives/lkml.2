Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1AaMA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:00:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53525 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab1AaMAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:53 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] dmaengine i.MX dma: check sg entries for valid addresses and lengths
Date: Mon, 31 Jan 2011 13:00:46 +0100
Message-Id: <1296475248-29095-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
References: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-dma.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index a46e1d9..a1eac99 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -243,6 +243,21 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 	else
 		dmamode = DMA_MODE_WRITE;
 
+	switch (imxdmac->word_size) {
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		if (sgl->length & 3 || sgl->dma_address & 3)
+			return NULL;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		if (sgl->length & 1 || sgl->dma_address & 1)
+			return NULL;
+		break;
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		break;
+	default:
+		return NULL;
+	}
+
 	ret = imx_dma_setup_sg(imxdmac->imxdma_channel, sgl, sg_len,
 		 dma_length, imxdmac->per_address, dmamode);
 	if (ret)
-- 
1.7.2.3

