Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1GEOyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:54:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1GEOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:54:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 45/49] gma500: Add the HDMI bits
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:44:20 +0100
Message-ID: <20110705144417.23872.83419.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This adds the basic HDMI support for Cedarview.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile        |    3 ++-
 drivers/staging/gma500/cdv_device.c    |    4 ++--
 drivers/staging/gma500/psb_intel_drv.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 507aaaf..e515edf 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -25,8 +25,9 @@ psb_gfx-y += gem_glue.o \
 	  mid_bios.o
 
 psb_gfx-$(CONFIG_DRM_PSB_CDV) +=  cdv_device.o \
-	  cdv_intel_display.o \
 	  cdv_intel_crt.o \
+	  cdv_intel_display.o \
+	  cdv_intel_hdmi.o \
 	  cdv_intel_lvds.o
 
 psb_gfx-$(CONFIG_DRM_PSB_MRST) += mrst_device.o \
diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index 622c955..680f1bb 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -58,9 +58,9 @@ static int cdv_output_init(struct drm_device *dev)
 	/* These bits indicate HDMI not SDVO on CDV, but we don't yet support
 	   the HDMI interface */
 	if (REG_READ(SDVOB) & SDVO_DETECTED)
-		DRM_ERROR("HDMI not supported yet\n");
+		cdv_hdmi_init(dev, &dev_priv->mode_dev, SDVOB);
 	if (REG_READ(SDVOC) & SDVO_DETECTED)
-		DRM_ERROR("HDMI not supported yet\n");
+		cdv_hdmi_init(dev, &dev_priv->mode_dev, SDVOC);
 	return 0;
 }
 
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 9d7151a..36b554b 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -105,7 +105,7 @@ struct psb_intel_output {
 	void *dev_priv;
 
 	struct psb_intel_mode_device *mode_dev;
-
+	struct i2c_adapter *hdmi_i2c_adapter;	/* for control functions */
 };
 
 struct psb_intel_crtc_state {

