Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2J1IIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:08:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43039 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755329Ab2J1IIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] gpu: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:45 -0700
Message-Id: <8a5cd2f8951f01f08e4a8d420a0b64f395d04bc7.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce multiline formats for easier grep.
Coalesce unnecessarily segmented formats on a single line too.
Remove trailing space after newline in a format.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/gma500/cdv_intel_crt.c  |    3 +--
 drivers/gpu/drm/gma500/cdv_intel_lvds.c |    7 +++----
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    7 +++----
 drivers/gpu/drm/i915/intel_opregion.c   |    8 ++++----
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_crt.c b/drivers/gpu/drm/gma500/cdv_intel_crt.c
index 8c17534..33ee3f4 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_crt.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_crt.c
@@ -296,8 +296,7 @@ void cdv_intel_crt_init(struct drm_device *dev,
 	psb_intel_encoder->ddc_bus = psb_intel_i2c_create(dev,
 							  i2c_reg, "CRTDDC_A");
 	if (!psb_intel_encoder->ddc_bus) {
-		dev_printk(KERN_ERR, &dev->pdev->dev, "DDC bus registration "
-			   "failed.\n");
+		dev_err(&dev->pdev->dev, "DDC bus registration failed\n");
 		goto failed_ddc;
 	}
 
diff --git a/drivers/gpu/drm/gma500/cdv_intel_lvds.c b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
index b362dd3..38184f6 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -686,8 +686,7 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 							 GPIOB,
 							 "LVDSBLC_B");
 	if (!psb_intel_encoder->i2c_bus) {
-		dev_printk(KERN_ERR,
-			&dev->pdev->dev, "I2C bus registration failed.\n");
+		dev_err(&dev->pdev->dev, "I2C bus registration failed\n");
 		goto failed_blc_i2c;
 	}
 	psb_intel_encoder->i2c_bus->slave_addr = 0x2C;
@@ -708,8 +707,8 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 							 GPIOC,
 							 "LVDSDDC_C");
 	if (!psb_intel_encoder->ddc_bus) {
-		dev_printk(KERN_ERR, &dev->pdev->dev,
-			   "DDC bus registration " "failed.\n");
+		dev_err(&dev->pdev->dev,
+			"DDC bus registration failed\n");
 		goto failed_ddc;
 	}
 
diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c b/drivers/gpu/drm/gma500/psb_intel_lvds.c
index 2a4c3a9..d1931cf 100644
--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -759,8 +759,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	 */
 	lvds_priv->i2c_bus = psb_intel_i2c_create(dev, GPIOB, "LVDSBLC_B");
 	if (!lvds_priv->i2c_bus) {
-		dev_printk(KERN_ERR,
-			&dev->pdev->dev, "I2C bus registration failed.\n");
+		dev_err(&dev->pdev->dev, "I2C bus registration failed\n");
 		goto failed_blc_i2c;
 	}
 	lvds_priv->i2c_bus->slave_addr = 0x2C;
@@ -779,8 +778,8 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	/* Set up the DDC bus. */
 	lvds_priv->ddc_bus = psb_intel_i2c_create(dev, GPIOC, "LVDSDDC_C");
 	if (!lvds_priv->ddc_bus) {
-		dev_printk(KERN_ERR, &dev->pdev->dev,
-			   "DDC bus registration " "failed.\n");
+		dev_err(&dev->pdev->dev,
+			"DDC bus registration failed\n");
 		goto failed_ddc;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 5530413..fe31b23 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -366,8 +366,8 @@ static void intel_didl_outputs(struct drm_device *dev)
 
 	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
 		if (i >= 8) {
-			dev_printk(KERN_ERR, &dev->pdev->dev,
-				    "More than 8 outputs detected\n");
+			dev_err(&dev->pdev->dev,
+				"More than 8 outputs detected\n");
 			return;
 		}
 		status =
@@ -393,8 +393,8 @@ blind_set:
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		int output_type = ACPI_OTHER_OUTPUT;
 		if (i >= 8) {
-			dev_printk(KERN_ERR, &dev->pdev->dev,
-				    "More than 8 outputs detected\n");
+			dev_err(&dev->pdev->dev,
+				"More than 8 outputs detected\n");
 			return;
 		}
 		switch (connector->connector_type) {
-- 
1.7.8.112.g3fd21

