Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1HAVny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:43:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1HAVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:43:51 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 2/3] gma500: Don't enable MSI on Poulsbo
Date: Mon,  1 Aug 2011 23:42:09 +0200
Message-Id: <1312234930-2387-2-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312234930-2387-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1312234930-2387-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chipset reports MSI capabilities for Poulsbo even though it isn't really there.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/psb_drv.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index d91083a..10c8ecd 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -329,6 +329,11 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev_priv->dev = dev;
 	dev->dev_private = (void *) dev_priv;
 
+	if (!IS_PSB(dev)) {
+		if (pci_enable_msi(dev->pdev))
+			dev_warn(dev->dev, "Enabling MSI failed!\n");
+	}
+
 	dev_priv->num_pipe = dev_priv->ops->pipes;
 
 	resource_start = pci_resource_start(dev->pdev, PSB_MMIO_RESOURCE);
@@ -1207,9 +1212,6 @@ static struct pci_driver psb_pci_driver = {
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	/* MLD Added this from Inaky's patch */
-	if (pci_enable_msi(pdev))
-		dev_warn(&pdev->dev, "Enable MSI failed!\n");
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 
-- 
1.7.4.1

