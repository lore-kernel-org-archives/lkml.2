Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1IFISM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:18:12 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38801 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1IFISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:18:06 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/5 v2] spi-topcliff-pch: add tx-memory clear after complete transmitting
Date: Tue,  6 Sep 2011 17:16:34 +0900
Message-Id: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in case of reading date from SPI flash,
command is sent twice.
The cause is that tx-memory clear processing is missing .
This patch adds the tx-momory clear processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
v2: v1 patch series are included invalid patch file
---
 drivers/spi/spi-topcliff-pch.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 1d23f38..7a98caa 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -837,6 +837,11 @@ static void pch_spi_start_transfer(struct pch_spi_data *data)
 
 	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_rx_p, dma->nent,
 			    DMA_FROM_DEVICE);
+
+	dma_sync_sg_for_cpu(&data->master->dev, dma->sg_tx_p, dma->nent,
+			    DMA_FROM_DEVICE);
+	memset(data->dma.tx_buf_virt, 0, PAGE_SIZE);
+
 	async_tx_ack(dma->desc_rx);
 	async_tx_ack(dma->desc_tx);
 	kfree(dma->sg_tx_p);
-- 
1.7.4.4

