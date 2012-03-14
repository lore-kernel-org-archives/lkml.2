Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946Ab2CNMcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:32:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab2CNMce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:32:34 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.58+drm33.24
Date: Wed, 14 Mar 2012 13:32:31 +0100
Message-Id: <1331728351-28565-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.58+drm33.24 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/i915: no lvds quirk for AOpen MP45
* drm/radeon/kms: fix MSI re-arm on rv370+
* Linux 2.6.32.58+drm33.24

 Makefile                          |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 drivers/gpu/drm/radeon/r100.c     |    4 +---
 drivers/gpu/drm/radeon/rs600.c    |    4 +---
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 153b59a..c6e0442 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .58+drm33.23
+EXTRAVERSION = .58+drm33.24
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 7cfc814..2f6f9fa 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -852,6 +852,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+                .ident = "AOpen i45GMx-I",
+                .matches = {
+                        DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+                        DMI_MATCH(DMI_BOARD_NAME, "i45GMx-I"),
+                },
+        },
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 6021e91..f35fcdb 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -337,9 +337,7 @@ int r100_irq_process(struct radeon_device *rdev)
 			WREG32(RADEON_AIC_CNTL, msi_rearm | RS400_MSI_REARM);
 			break;
 		default:
-			msi_rearm = RREG32(RADEON_MSI_REARM_EN) & ~RV370_MSI_REARM_EN;
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm);
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm | RV370_MSI_REARM_EN);
+			WREG32(RADEON_MSI_REARM_EN, RV370_MSI_REARM_EN);
 			break;
 		}
 	}
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index d9a0187..13a09ef 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -431,9 +431,7 @@ int rs600_irq_process(struct radeon_device *rdev)
 			WREG32(RADEON_BUS_CNTL, msi_rearm | RS600_MSI_REARM);
 			break;
 		default:
-			msi_rearm = RREG32(RADEON_MSI_REARM_EN) & ~RV370_MSI_REARM_EN;
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm);
-			WREG32(RADEON_MSI_REARM_EN, msi_rearm | RV370_MSI_REARM_EN);
+			WREG32(RADEON_MSI_REARM_EN, RV370_MSI_REARM_EN);
 			break;
 		}
 	}
