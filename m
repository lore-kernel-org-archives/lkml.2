Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1AFAFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:05:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:31905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1AFAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833883"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 2/7] serial: ifx6x60: dma_alloc_coherent must use parent dev
Date: Wed,  5 Jan 2011 16:05:08 -0800
Message-Id: <1294272313-15899-3-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
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
 drivers/serial/ifx6x60.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 1eb44f9..e18ae38 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -990,7 +990,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->spi_slave_cts = 0;
 
 	/*initialize transfer and dma buffers */
-	ifx_dev->tx_buffer = dma_alloc_coherent(&ifx_dev->spi_dev->dev,
+	ifx_dev->tx_buffer = dma_alloc_coherent(ifx_dev->spi_dev->dev.parent,
 				IFX_SPI_TRANSFER_SIZE,
 				&ifx_dev->tx_bus,
 				GFP_KERNEL);
@@ -999,7 +999,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 		ret = -ENOMEM;
 		goto error_ret;
 	}
-	ifx_dev->rx_buffer = dma_alloc_coherent(&ifx_dev->spi_dev->dev,
+	ifx_dev->rx_buffer = dma_alloc_coherent(ifx_dev->spi_dev->dev.parent,
 				IFX_SPI_TRANSFER_SIZE,
 				&ifx_dev->rx_bus,
 				GFP_KERNEL);
-- 
1.7.2.3

