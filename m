Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1EaPvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1EaPvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:51:48 -0400
Date: Tue, 31 May 2011 11:51:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155147.3512.7345.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 10/35] drivers/gpu changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu changes for SMBIOS and System Firmware

---
 drivers/gpu/drm/i915/intel_lvds.c |   72 ++++++++++++++++++------------------
 drivers/gpu/vga/vga_switcheroo.c  |    1 -
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 67cb076..77a5e12 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -28,7 +28,7 @@
  */
 
 #include <acpi/button.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include "drmP.h"
@@ -502,20 +502,20 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
 	return 1;
 }
 
-static int intel_no_modeset_on_lid_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_modeset_on_lid_callback(const struct sysfw_id *id)
 {
 	DRM_DEBUG_KMS("Skipping forced modeset for %s\n", id->ident);
 	return 1;
 }
 
 /* The GPU hangs up on these systems if modeset is performed on LID open */
-static const struct dmi_system_id intel_no_modeset_on_lid[] = {
+static const struct sysfw_id intel_no_modeset_on_lid[] = {
 	{
-		.callback = intel_no_modeset_on_lid_dmi_callback,
+		.callback = intel_no_modeset_on_lid_callback,
 		.ident = "Toshiba Tecra A11",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TECRA A11"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "TOSHIBA"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "TECRA A11"),
 		},
 	},
 
@@ -551,7 +551,7 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 							     false);
 
 	/* Don't force modeset on machines where it causes a GPU lockup */
-	if (dmi_check_system(intel_no_modeset_on_lid))
+	if (sysfw_callback(intel_no_modeset_on_lid))
 		return NOTIFY_OK;
 	if (!acpi_lid_open()) {
 		dev_priv->modeset_on_lid = 1;
@@ -648,83 +648,83 @@ static const struct drm_encoder_funcs intel_lvds_enc_funcs = {
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+static int __init intel_no_lvds_callback(const struct sysfw_id *id)
 {
 	DRM_DEBUG_KMS("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;
 }
 
 /* These systems claim to have LVDS, but really don't */
-static const struct dmi_system_id intel_no_lvds[] = {
+static const struct sysfw_id intel_no_lvds[] = {
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "Apple Mac Mini (Core series)",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Macmini1,1"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "Apple Mac Mini (Core 2 series)",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini2,1"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Apple"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Macmini2,1"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "MSI IM-945GSE-A",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MSI"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A9830IMS"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "MSI"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A9830IMS"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "Dell Studio Hybrid",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Studio Hybrid 140g"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "AOpen Mini PC",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "AOpen"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "i965GMx-IF"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "AOpen"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "i965GMx-IF"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "AOpen Mini PC MP915",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
-			DMI_MATCH(DMI_BOARD_NAME, "i915GMx-F"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "AOpen"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "i915GMx-F"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "AOpen i915GMm-HFS",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
-			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "AOpen"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "i915GMm-HFS"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "AO00001JW"),
 		},
 	},
 	{
-		.callback = intel_no_lvds_dmi_callback,
+		.callback = intel_no_lvds_callback,
 		.ident = "Clientron U800",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Clientron"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Clientron"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "U800"),
 		},
 	},
 
@@ -854,7 +854,7 @@ bool intel_lvds_init(struct drm_device *dev)
 	u8 pin;
 
 	/* Skip init on machines we know falsely report LVDS */
-	if (dmi_check_system(intel_no_lvds))
+	if (sysfw_callback(intel_no_lvds))
 		return false;
 
 	pin = GMBUS_PORT_PANEL;
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 58434e8..1a9139c 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/dmi.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
-- 
1.7.5.1

