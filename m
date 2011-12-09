Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1LIEMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:12:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36378 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1LIEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:12:11 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/4] spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device info
Date: Fri,  9 Dec 2011 13:11:42 +0900
Message-Id: <1323403905-3432-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/spi/spi-topcliff-pch.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 99ec279..fcd9462 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -920,7 +920,8 @@ static void pch_spi_request_dma(struct pch_spi_data *data, int bpw)
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Get DMA's dev information */
-	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
+	dma_dev = pci_get_bus_and_slot(data->board_dat->pdev->bus->number,
+				       PCI_DEVFN(12, 0));
 
 	/* Set Tx DMA */
 	param = &dma->param_tx;
-- 
1.7.4.4

