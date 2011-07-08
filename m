Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1GHIxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:53:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40008 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab1GHIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:53:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/12] gma500: Fix symbol clash with i915
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:43:45 +0100
Message-ID: <20110708084340.19581.25124.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Randy Dunlap reports:
| when both CONFIG_DRM_I915=y and CONFIG_DRM_PSB=y:
| drivers/staging/built-in.o: In function `intel_opregion_init':
| (.text+0x47943): multiple definition of `intel_opregion_init'
| drivers/gpu/built-in.o:(.text+0x17277a): first defined here

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_device.c     |    2 +-
 drivers/staging/gma500/intel_opregion.c |    4 ++--
 drivers/staging/gma500/psb_device.c     |    2 +-
 drivers/staging/gma500/psb_drv.c        |    2 +-
 drivers/staging/gma500/psb_drv.h        |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index 680f1bb..3729a97 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -319,7 +319,7 @@ static void cdv_get_core_freq(struct drm_device *dev)
 static int cdv_chip_setup(struct drm_device *dev)
 {
 	cdv_get_core_freq(dev);
-	intel_opregion_init(dev);
+	gma_intel_opregion_init(dev);
 	psb_intel_init_bios(dev);
 	return 0;
 }
diff --git a/drivers/staging/gma500/intel_opregion.c b/drivers/staging/gma500/intel_opregion.c
index 8240965..d2e6037 100644
--- a/drivers/staging/gma500/intel_opregion.c
+++ b/drivers/staging/gma500/intel_opregion.c
@@ -47,7 +47,7 @@ struct opregion_acpi {
 	/*FIXME: add it later*/
 } __packed;
 
-int intel_opregion_init(struct drm_device *dev)
+int gma_intel_opregion_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 opregion_phy;
@@ -71,7 +71,7 @@ int intel_opregion_init(struct drm_device *dev)
 	return 0;
 }
 
-int intel_opregion_exit(struct drm_device *dev)
+int gma_intel_opregion_exit(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	if (dev_priv->lid_state)
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 0774c06..e26a176 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -322,7 +322,7 @@ static void psb_get_core_freq(struct drm_device *dev)
 static int psb_chip_setup(struct drm_device *dev)
 {
 	psb_get_core_freq(dev);
-	intel_opregion_init(dev);
+	gma_intel_opregion_init(dev);
 	psb_intel_init_bios(dev);
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 264fdf4..397b605 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -245,7 +245,7 @@ static int psb_driver_unload(struct drm_device *dev)
 
 	if (dev_priv) {
 		psb_lid_timer_takedown(dev_priv);
-		intel_opregion_exit(dev);
+		gma_intel_opregion_exit(dev);
 
 		psb_do_takedown(dev);
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index c19045f..f5ecd6d 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -728,8 +728,8 @@ extern void mdfld_disable_te(struct drm_device *dev, int pipe);
 /*
  * intel_opregion.c
  */
-extern int intel_opregion_init(struct drm_device *dev);
-extern int intel_opregion_exit(struct drm_device *dev);
+extern int gma_intel_opregion_init(struct drm_device *dev);
+extern int gma_intel_opregion_exit(struct drm_device *dev);
 
 /*
  * framebuffer.c

