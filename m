Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1KHLSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:18:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56113 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab1KHLQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:16:47 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 13/20] Staging: comedi: fix printk issue in cb_pcimdas.c
Date: Tue,  8 Nov 2011 16:45:23 +0530
Message-Id: <1320750930-9764-13-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_version.
Removed ifdef CBPCIMDAS_DEBUG.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 321af6d..5d25e78 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -274,13 +274,11 @@ found:
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
 
-#ifdef CBPCIMDAS_DEBUG
-	printk("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-	printk("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-	printk("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-	printk("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-	printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
-#endif
+	dev_dbg(dev->hw_dev, "devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
+	dev_dbg(dev->hw_dev, "devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
+	dev_dbg(dev->hw_dev, "devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
+	dev_dbg(dev->hw_dev, "devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
+	dev_dbg(dev->hw_dev, "devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 
 /* Dont support IRQ yet */
 /*  get irq */
-- 
1.7.0.4

