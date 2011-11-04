Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1KDMKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:10:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1KDMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:56 -0400
X-AuditID: cbfee61b-b7b7fae000005864-07-4eb3d611319a
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 08/10] drm/exynos: removed meaningless parameter from fbdev
 update
Date: Fri, 04 Nov 2011 21:09:57 +0900
Message-id: <1320408599-7475-9-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0200 (UTC)
 FILETIME=[9FDD3180:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_framebuffer already has width and height so they are meaningless as
parameters when updating fb_info.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 74092a8..0effd77 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -85,15 +85,13 @@ static struct fb_ops exynos_drm_fb_ops = {
 };
 
 static int exynos_drm_fbdev_update(struct drm_fb_helper *helper,
-				     struct drm_framebuffer *fb,
-				     unsigned int fb_width,
-				     unsigned int fb_height)
+				     struct drm_framebuffer *fb)
 {
 	struct fb_info *fbi = helper->fbdev;
 	struct drm_device *dev = helper->dev;
 	struct exynos_drm_fbdev *exynos_fb = to_exynos_fbdev(helper);
 	struct exynos_drm_buf_entry *entry;
-	unsigned int size = fb_width * fb_height * (fb->bits_per_pixel >> 3);
+	unsigned int size = fb->width * fb->height * (fb->bits_per_pixel >> 3);
 	unsigned long offset;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
@@ -101,7 +99,7 @@ static int exynos_drm_fbdev_update(struct drm_fb_helper *helper,
 	exynos_fb->fb = fb;
 
 	drm_fb_helper_fill_fix(fbi, fb->pitch, fb->depth);
-	drm_fb_helper_fill_var(fbi, helper, fb_width, fb_height);
+	drm_fb_helper_fill_var(fbi, helper, fb->width, fb->height);
 
 	entry = exynos_drm_fb_get_buf(fb);
 	if (!entry) {
@@ -171,8 +169,7 @@ static int exynos_drm_fbdev_create(struct drm_fb_helper *helper,
 		goto out;
 	}
 
-	ret = exynos_drm_fbdev_update(helper, helper->fb, sizes->fb_width,
-			sizes->fb_height);
+	ret = exynos_drm_fbdev_update(helper, helper->fb);
 	if (ret < 0)
 		fb_dealloc_cmap(&fbi->cmap);
 
@@ -235,8 +232,7 @@ static int exynos_drm_fbdev_recreate(struct drm_fb_helper *helper,
 	}
 
 	helper->fb = exynos_fbdev->fb;
-	return exynos_drm_fbdev_update(helper, helper->fb, sizes->fb_width,
-			sizes->fb_height);
+	return exynos_drm_fbdev_update(helper, helper->fb);
 }
 
 static int exynos_drm_fbdev_probe(struct drm_fb_helper *helper,
-- 
1.7.4.1

