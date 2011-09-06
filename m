Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1IFIA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:00:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33657 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab1IFIAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:00:19 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/5] spi-topcliff-pch: add tx-memory clear after complete transmitting
Date: Tue,  6 Sep 2011 16:58:30 +0900
Message-Id: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
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
 drivers/spi/spi-topcliff-pch.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 540c290..1b98b7e 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -839,6 +839,11 @@ static void pch_spi_start_transfer(struct pch_spi_data *data)
 
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

