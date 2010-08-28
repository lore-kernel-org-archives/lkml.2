Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0H1QaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:30:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35280 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0H1QaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h1BhIJ0LQKrr8gpKjWDEuu5MxCr8DC0rPBOUCEzv2otQiRjtn5QbfO3un/wlOAe7mM
         aZhDKq2dKEcpmF0miUx8P3H6qsC8rIiioajqa/j65JoOeK2ok5T71GNZtKRxNv4RRHy/
         pI4vu6RFB+gaMfYbN3ZYeevcM7MqoZCXNFRMQ=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pshah.mumbai@gmail.com, bcollins@bluecherry.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: solo6x10: fixed assignments in if conditions in solo6010-core.c
Date: Sat, 28 Aug 2010 21:59:46 +0530
Message-Id: <1283012986-3708-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the solo6010-core.c file that fixes the assignments
in if condition style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/solo6x10/solo6010-core.c |   40 +++++++++++++++++++----------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/solo6x10/solo6010-core.c b/drivers/staging/solo6x10/solo6010-core.c
index 98c6739..4a051cd 100644
--- a/drivers/staging/solo6x10/solo6010-core.c
+++ b/drivers/staging/solo6x10/solo6010-core.c
@@ -136,23 +136,26 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 	int ret;
 	int sdram;
 	u8 chip_id;
-
-	if ((solo_dev = kzalloc(sizeof(*solo_dev), GFP_KERNEL)) == NULL)
+	solo_dev = kzalloc(sizeof(*solo_dev), GFP_KERNEL);
+	if (solo_dev == NULL)
 		return -ENOMEM;
 
 	solo_dev->pdev = pdev;
 	spin_lock_init(&solo_dev->reg_io_lock);
 	pci_set_drvdata(pdev, solo_dev);
 
-	if ((ret = pci_enable_device(pdev)))
+	ret = pci_enable_device(pdev);
+	if (ret)
 		goto fail_probe;
 
 	pci_set_master(pdev);
 
-	if ((ret = pci_request_regions(pdev, SOLO6010_NAME)))
+	ret = pci_request_regions(pdev, SOLO6010_NAME);
+	if (ret)
 		goto fail_probe;
 
-	if ((solo_dev->reg_base = pci_ioremap_bar(pdev, 0)) == NULL) {
+	solo_dev->reg_base = pci_ioremap_bar(pdev, 0);
+	if (solo_dev->reg_base == NULL) {
 		ret = -ENOMEM;
 		goto fail_probe;
 	}
@@ -198,7 +201,8 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 	/* Handle this from the start */
 	solo6010_irq_on(solo_dev, SOLO_IRQ_PCI_ERR);
 
-	if ((ret = solo_i2c_init(solo_dev)))
+	ret = solo_i2c_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
 	/* Setup the DMA engine */
@@ -210,28 +214,36 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 		       SOLO_DMA_CTRL_READ_CLK_SELECT |
 		       SOLO_DMA_CTRL_LATENCY(1));
 
-	if ((ret = solo_p2m_init(solo_dev)))
+	ret = solo_p2m_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_disp_init(solo_dev)))
+	ret = solo_disp_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_gpio_init(solo_dev)))
+	ret = solo_gpio_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_tw28_init(solo_dev)))
+	ret = solo_tw28_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_v4l2_init(solo_dev)))
+	ret = solo_v4l2_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_enc_init(solo_dev)))
+	ret = solo_enc_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_enc_v4l2_init(solo_dev)))
+	ret = solo_enc_v4l2_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
-	if ((ret = solo_g723_init(solo_dev)))
+	ret = solo_g723_init(solo_dev);
+	if (ret)
 		goto fail_probe;
 
 	return 0;
-- 
1.6.0.4

