Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1HAVm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:42:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37585 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1HAVmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:42:50 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 1/3] gma500: Only register interrupt handler for poulsbo hardware
Date: Mon,  1 Aug 2011 23:42:08 +0200
Message-Id: <1312234930-2387-1-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step in adding proper irq handling. We'll start with poulsbo support so
make sure other chips don't touch drm_irq_install().

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
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
index 72f487a..8c6aa15 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -44,6 +44,7 @@ enum {
 	CHIP_MFLD_0130 = 3,		/* Medfield */
 };
 
+#define IS_PSB(dev) (((dev)->pci_device & 0xfffe) == 0x8108)
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
 #define IS_MFLD(dev) (((dev)->pci_device & 0xfff8) == 0x0130)
 
-- 
1.7.4.1

