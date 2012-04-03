Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2DCP1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:27:00 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:21243 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2DCP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:26:59 -0400
Message-Id: <201204031526.q33FQvFO031746@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Apr 2012 11:10:14 -0400
Subject: [PATCH] marvell sky2 driver: fix irq number assignment bug
To: Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Apr 2012 15:26:58.0222 (UTC) FILETIME=[35716CE0:01CD11AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a minor bug that will display wrong IRQ number in ifconfig output.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/marvell/sky2.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 423a1a2..879b0a4 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4978,6 +4978,13 @@ static int __devinit sky2_probe(struct pci_dev *pdev,
 			goto err_out_free_netdev;
  	}
 
+	/*
+	 * Need to set the IRQ # for the net_device here again after
+	 * setting it in sky2_init_netdev() initially, because MSI
+	 * will assign a new IRQ # to this PCI device.
+	 */
+	dev->irq = hw->pdev->irq;
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(&pdev->dev, "cannot register net device\n");
-- 
1.6.5.2

