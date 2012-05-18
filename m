Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757Ab2ERCwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40553 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030720Ab2ERCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:47 -0400
Message-Id: <20120518023258.712784652@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 32/53] spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device info
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit ee2ece5261a639b89f194d141444b03b4c923179 upstream.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-topcliff-pch.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 4a5fafb..4b32fd7 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -924,7 +924,8 @@ static void pch_spi_request_dma(struct pch_spi_data *data, int bpw)
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Get DMA's dev information */
-	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
+	dma_dev = pci_get_bus_and_slot(data->board_dat->pdev->bus->number,
+				       PCI_DEVFN(12, 0));
 
 	/* Set Tx DMA */
 	param = &dma->param_tx;
-- 
1.7.10



