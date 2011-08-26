Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1HZKWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:22:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49222 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HZKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:22:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/9] gma500: Only register interrupt handler for poulsbo
 hardware
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:17:42 +0100
Message-ID: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

First step in adding proper irq handling. We'll start with poulsbo support so
make sure other chips don't touch drm_irq_install().

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    2 +-
 drivers/staging/gma500/psb_drv.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b2cdce7..d91083a 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -410,7 +410,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	PSB_WVDC32(0x00000000, PSB_INT_ENABLE_R);
 	PSB_WVDC32(0xFFFFFFFF, PSB_INT_MASK_R);
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
+	if (IS_PSB(dev) && drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_irq_install(dev);
 
 	dev->vblank_disable_allowed = 1;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index fd4732d..8cd4f1a 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -43,6 +43,7 @@ enum {
 	CHIP_MFLD_0130 = 3,		/* Medfield */
 };
 
+#define IS_PSB(dev) (((dev)->pci_device & 0xfffe) == 0x8108)
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
 #define IS_MFLD(dev) (((dev)->pci_device & 0xfff8) == 0x0130)
 

