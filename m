Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1A0OqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:46:04 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36050 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1A0OqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:46:01 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.28+drm33.13
Date: Thu, 27 Jan 2011 15:45:57 +0100
Message-Id: <1296139557-14743-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.28+drm33.13 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.
* drm/kms: remove spaces from connector names (v2)
* Linux 2.6.32.28+drm33.13

 Makefile                          |    2 +-
 drivers/gpu/drm/drm_crtc.c        |   10 +++++-----
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index ba75a67..f792613 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .28+drm33.12
+EXTRAVERSION = .28+drm33.13
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index d91fb8c..81ba0e6 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -153,12 +153,12 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] =
 	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
 	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
 	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
-	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
-	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
+	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
+	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI-A", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI-B", 0 },
 	{ DRM_MODE_CONNECTOR_TV, "TV", 0 },
-	{ DRM_MODE_CONNECTOR_eDP, "Embedded DisplayPort", 0 },
+	{ DRM_MODE_CONNECTOR_eDP, "eDP", 0 },
 };

 static struct drm_prop_enum_list drm_encoder_enum_list[] =
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 5ca37a5..cf619c4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -326,6 +326,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	INIT_LIST_HEAD(&fbo->lru);
 	INIT_LIST_HEAD(&fbo->swap);
 	fbo->vm_node = NULL;
+	atomic_set(&fbo->cpu_writers, 0);

 	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	if (fbo->mem.mm_node)
