Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1BGT5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:57:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:23953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1BGT5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292946"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 2/6] serial: ifx6x60: dma_alloc_coherent must use parent dev
Date: Mon,  7 Feb 2011 12:02:28 -0800
Message-Id: <1297108952-27371-3-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is a SPI protocol driver and has no DMA ops
associated with the device so the call will fail. Furthermore,
the DMA allocation made here will be used by the SPI
controller driver (parent dev) so it makes sense to
pass that device instead.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 972c04d..bb2ff20 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -998,7 +998,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->spi_slave_cts = 0;
 
 	/*initialize transfer and dma buffers */
-	ifx_dev->tx_buffer = dma_alloc_coherent(&ifx_dev->spi_dev->dev,
+	ifx_dev->tx_buffer = dma_alloc_coherent(ifx_dev->spi_dev->dev.parent,
 				IFX_SPI_TRANSFER_SIZE,
 				&ifx_dev->tx_bus,
 				GFP_KERNEL);
@@ -1007,7 +1007,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 		ret = -ENOMEM;
 		goto error_ret;
 	}
-	ifx_dev->rx_buffer = dma_alloc_coherent(&ifx_dev->spi_dev->dev,
+	ifx_dev->rx_buffer = dma_alloc_coherent(ifx_dev->spi_dev->dev.parent,
 				IFX_SPI_TRANSFER_SIZE,
 				&ifx_dev->rx_bus,
 				GFP_KERNEL);
-- 
1.7.3.4

