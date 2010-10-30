Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0J3VOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:14:10 -0400
Received: from mail.perches.com ([173.55.12.10]:3737 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0J3VJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: [PATCH 13/39] drivers/gpu/drm: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:30 -0700
Message-Id: <4a8dea0a8b47d855433ee5805cc4469824113259.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_crtc_helper.c     |    2 +-
 drivers/gpu/drm/i915/i915_gem.c       |    3 +--
 drivers/gpu/drm/radeon/evergreen.c    |    2 +-
 drivers/gpu/drm/radeon/r100.c         |    4 ++--
 drivers/gpu/drm/radeon/r300.c         |    2 +-
 drivers/gpu/drm/radeon/r600.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_fence.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c   |    3 ++-
 drivers/gpu/drm/radeon/rs400.c        |    2 +-
 drivers/gpu/drm/radeon/rs600.c        |    4 ++--
 10 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index dcbeb98..f7af91c 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -276,7 +276,7 @@ static bool drm_encoder_crtc_ok(struct drm_encoder *encoder,
 	struct drm_crtc *tmp;
 	int crtc_mask = 1;
 
-	WARN(!crtc, "checking null crtc?");
+	WARN(!crtc, "checking null crtc?\n");
 
 	dev = crtc->dev;
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8eb8453..6f775f5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4043,8 +4043,7 @@ i915_gem_object_pin(struct drm_gem_object *obj, uint32_t alignment)
 			alignment = i915_gem_get_gtt_alignment(obj);
 		if (obj_priv->gtt_offset & (alignment - 1)) {
 			WARN(obj_priv->pin_count,
-			     "bo is already pinned with incorrect alignment:"
-			     " offset=%x, req.alignment=%x\n",
+			     "bo is already pinned with incorrect alignment: offset=%x, req.alignment=%x\n",
 			     obj_priv->gtt_offset, alignment);
 			ret = i915_gem_object_unbind(obj);
 			if (ret)
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index f12a5b3..dc9c7b5 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2033,7 +2033,7 @@ int evergreen_irq_set(struct radeon_device *rdev)
 	u32 grbm_int_cntl = 0;
 
 	if (!rdev->irq.installed) {
-		WARN(1, "Can't enable IRQ/MSI because no handler is installed.\n");
+		WARN(1, "Can't enable IRQ/MSI because no handler is installed\n");
 		return -EINVAL;
 	}
 	/* don't enable anything if the ih is disabled */
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 0e8f28a..8e10aa9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -442,7 +442,7 @@ int r100_pci_gart_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.ram.ptr) {
-		WARN(1, "R100 PCI GART already initialized.\n");
+		WARN(1, "R100 PCI GART already initialized\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
@@ -516,7 +516,7 @@ int r100_irq_set(struct radeon_device *rdev)
 	uint32_t tmp = 0;
 
 	if (!rdev->irq.installed) {
-		WARN(1, "Can't enable IRQ/MSI because no handler is installed.\n");
+		WARN(1, "Can't enable IRQ/MSI because no handler is installed\n");
 		WREG32(R_000040_GEN_INT_CNTL, 0);
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 34527e6..cde1d34 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -91,7 +91,7 @@ int rv370_pcie_gart_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.vram.robj) {
-		WARN(1, "RV370 PCIE GART already initialized.\n");
+		WARN(1, "RV370 PCIE GART already initialized\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 33952a1..403e0df 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -919,7 +919,7 @@ int r600_pcie_gart_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.vram.robj) {
-		WARN(1, "R600 PCIE GART already initialized.\n");
+		WARN(1, "R600 PCIE GART already initialized\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
@@ -2995,7 +2995,7 @@ int r600_irq_set(struct radeon_device *rdev)
 	u32 hdmi1, hdmi2;
 
 	if (!rdev->irq.installed) {
-		WARN(1, "Can't enable IRQ/MSI because no handler is installed.\n");
+		WARN(1, "Can't enable IRQ/MSI because no handler is installed\n");
 		return -EINVAL;
 	}
 	/* don't enable anything if the ih is disabled */
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 216392d..daacb28 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -240,7 +240,8 @@ retry:
 		 */
 		if (seq == rdev->fence_drv.last_seq && radeon_gpu_is_lockup(rdev)) {
 			/* good news we believe it's a lockup */
-			WARN(1, "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n", fence->seq, seq);
+			WARN(1, "GPU lockup (waiting for 0x%08X last fence id 0x%08X)\n",
+			     fence->seq, seq);
 			/* FIXME: what should we do ? marking everyone
 			 * as signaled for now
 			 */
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index fe95bb3..01c2c73 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -689,7 +689,8 @@ static int radeon_ttm_backend_bind(struct ttm_backend *backend,
 	gtt = container_of(backend, struct radeon_ttm_backend, backend);
 	gtt->offset = bo_mem->start << PAGE_SHIFT;
 	if (!gtt->num_pages) {
-		WARN(1, "nothing to bind %lu pages for mreg %p back %p!\n", gtt->num_pages, bo_mem, backend);
+		WARN(1, "nothing to bind %lu pages for mreg %p back %p!\n",
+		     gtt->num_pages, bo_mem, backend);
 	}
 	r = radeon_gart_bind(gtt->rdev, gtt->offset,
 			     gtt->num_pages, gtt->pages);
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index f683e51..5512e4e 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -78,7 +78,7 @@ int rs400_gart_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.ram.ptr) {
-		WARN(1, "RS400 GART already initialized.\n");
+		WARN(1, "RS400 GART already initialized\n");
 		return 0;
 	}
 	/* Check gart size */
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index b091a1f..f1c6e02 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -375,7 +375,7 @@ int rs600_gart_init(struct radeon_device *rdev)
 	int r;
 
 	if (rdev->gart.table.vram.robj) {
-		WARN(1, "RS600 GART already initialized.\n");
+		WARN(1, "RS600 GART already initialized\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
@@ -505,7 +505,7 @@ int rs600_irq_set(struct radeon_device *rdev)
 		~S_007D18_DC_HOT_PLUG_DETECT2_INT_EN(1);
 
 	if (!rdev->irq.installed) {
-		WARN(1, "Can't enable IRQ/MSI because no handler is installed.\n");
+		WARN(1, "Can't enable IRQ/MSI because no handler is installed\n");
 		WREG32(R_000040_GEN_INT_CNTL, 0);
 		return -EINVAL;
 	}
-- 
1.7.3.1.g432b3.dirty

