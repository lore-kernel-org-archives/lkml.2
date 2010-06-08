Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0FHDuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:50:51 -0400
Received: from mail.perches.com ([173.55.12.10]:2762 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0FHDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] drivers/gpu/drm: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:36 -0700
Message-Id: <40c6764fbc2fc04dcb8847927e4c1795610347c7.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
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
index b2ebf02..a1744bd 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2276,8 +2276,7 @@ int i915_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 	struct drm_i915_file_private *i915_file_priv;
 
 	DRM_DEBUG_DRIVER("\n");
-	i915_file_priv = (struct drm_i915_file_private *)
-	    kmalloc(sizeof(*i915_file_priv), GFP_KERNEL);
+	i915_file_priv = kmalloc(sizeof(*i915_file_priv), GFP_KERNEL);
 
 	if (!i915_file_priv)
 		return -ENOMEM;
-- 
1.7.1.244.gbdc4

