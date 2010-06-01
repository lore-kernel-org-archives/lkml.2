Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0FADX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:29 -0400
Received: from mail.perches.com ([173.55.12.10]:2470 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0FADX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:27 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 05/21] drivers/gpu/drm: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:07 -0700
Message-Id: <4f58955fcf54c4af12f7ef3d63e323ed50e24fba.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_sman.c      |    4 +---
 drivers/gpu/drm/i915/i915_dma.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_sman.c b/drivers/gpu/drm/drm_sman.c
index 463aed9..3466458 100644
--- a/drivers/gpu/drm/drm_sman.c
+++ b/drivers/gpu/drm/drm_sman.c
@@ -59,9 +59,7 @@ drm_sman_init(struct drm_sman * sman, unsigned int num_managers,
 {
 	int ret = 0;
 
-	sman->mm = (struct drm_sman_mm *) kcalloc(num_managers,
-						  sizeof(*sman->mm),
-						  GFP_KERNEL);
+	sman->mm = kcalloc(num_managers, sizeof(*sman->mm), GFP_KERNEL);
 	if (!sman->mm) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 2a6b5de..f3d5d9f 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1821,8 +1821,7 @@ int i915_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 	struct drm_i915_file_private *i915_file_priv;
 
 	DRM_DEBUG_DRIVER("\n");
-	i915_file_priv = (struct drm_i915_file_private *)
-	    kmalloc(sizeof(*i915_file_priv), GFP_KERNEL);
+	i915_file_priv = kmalloc(sizeof(*i915_file_priv), GFP_KERNEL);
 
 	if (!i915_file_priv)
 		return -ENOMEM;
-- 
1.7.0.3.311.g6a6955

