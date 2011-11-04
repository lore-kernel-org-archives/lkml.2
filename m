Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1KDMKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:10:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1KDMJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:57 -0400
X-AuditID: cbfee61b-b7b7fae000005864-08-4eb3d611d5fd
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 10/10] drm/exynos: checked for null pointer
Date: Fri, 04 Nov 2011 21:09:59 +0900
Message-id: <1320408599-7475-11-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0372 (UTC)
 FILETIME=[9FF77040:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_encoder.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_encoder.c b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
index 4092f41..2d7a03c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_encoder.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
@@ -290,7 +290,8 @@ void exynos_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data)
 	struct exynos_drm_overlay_ops *overlay_ops = manager->overlay_ops;
 	struct exynos_drm_overlay *overlay = data;
 
-	overlay_ops->mode_set(manager->dev, overlay);
+	if (overlay_ops && overlay_ops->mode_set)
+		overlay_ops->mode_set(manager->dev, overlay);
 }
 
 void exynos_drm_encoder_crtc_disable(struct drm_encoder *encoder, void *data)
@@ -301,7 +302,8 @@ void exynos_drm_encoder_crtc_disable(struct drm_encoder *encoder, void *data)
 
 	DRM_DEBUG_KMS("\n");
 
-	overlay_ops->disable(manager->dev);
+	if (overlay_ops && overlay_ops->disable)
+		overlay_ops->disable(manager->dev);
 }
 
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
-- 
1.7.4.1

