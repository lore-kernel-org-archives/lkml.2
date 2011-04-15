Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1DOWxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:53:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4731 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1DOWxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:53:35 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ata: sata_via: Use dev_dbg
Date: Fri, 15 Apr 2011 15:52:01 -0700
Message-Id: <fba6babc014dc15cc02e8d1901a04ed0c5651fb2.1302907498.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302907496.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use normal debugging path for dynamic debug capability.

Convert dev_printk(KERN_DEBUG to dev_dbg(

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/sata_via.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 21007b1..f93e43b 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -548,9 +548,8 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	/* make sure SATA channels are enabled */
 	pci_read_config_byte(pdev, SATA_CHAN_ENAB, &tmp8);
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channels (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev, "enabling SATA channels (0x%x)\n",
+			(int)tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_CHAN_ENAB, tmp8);
 	}
@@ -558,9 +557,8 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	/* make sure interrupts for each channel sent to us */
 	pci_read_config_byte(pdev, SATA_INT_GATE, &tmp8);
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channel interrupts (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev, "enabling SATA channel interrupts (0x%x)\n",
+			(int) tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_INT_GATE, tmp8);
 	}
@@ -568,9 +566,9 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	/* make sure native mode is enabled */
 	pci_read_config_byte(pdev, SATA_NATIVE_MODE, &tmp8);
 	if ((tmp8 & NATIVE_MODE_ALL) != NATIVE_MODE_ALL) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channel native mode (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev,
+			"enabling SATA channel native mode (0x%x)\n",
+			(int) tmp8);
 		tmp8 |= NATIVE_MODE_ALL;
 		pci_write_config_byte(pdev, SATA_NATIVE_MODE, tmp8);
 	}
-- 
1.7.4.2.g597a6.dirty

