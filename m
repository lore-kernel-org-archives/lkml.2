Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1HZKXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:23:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HZKWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:22:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/9] gma500: Don't enable MSI on Poulsbo
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:17:57 +0100
Message-ID: <20110826101753.16760.94938.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

Chipset reports MSI capabilities for Poulsbo even though it isn't really there.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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
 

