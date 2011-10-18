Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1JRQKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:10:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41213 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab1JRQKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:10:24 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 22/26] staging: et131x: Remove call to find pci pm capability
Date: Tue, 18 Oct 2011 17:07:55 +0100
Message-Id: <1318954079-16666-23-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_find_capability is called, but not used and is now redundant as
power management is handled elsewhere. Removed.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f521e33..9383c5c 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4356,7 +4356,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 			       const struct pci_device_id *ent)
 {
 	int result;
-	int pm_cap;
 	struct net_device *netdev;
 	struct et131x_adapter *adapter;
 	int ii;
@@ -4380,19 +4379,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	/* Query PCI for Power Mgmt Capabilities
-	 *
-	 * NOTE: Now reading PowerMgmt in another location; is this still
-	 * needed?
-	 */
-	pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
-	if (!pm_cap) {
-		dev_err(&pdev->dev,
-			  "Cannot find Power Management capabilities\n");
-		result = -EIO;
-		goto err_release_res;
-	}
-
 	/* Check the DMA addressing support of this device */
 	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-- 
1.7.6.4

