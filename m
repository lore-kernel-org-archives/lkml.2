Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1B0AiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 19:38:17 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:43940 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1B0AiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 19:38:14 -0500
Subject: [PATCH] [TRIVIAL] drm: radeon: fix typo in name of struct member
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 27 Feb 2011 01:37:47 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1298767093.1828.24.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_device.stollen_vga_memory must be a typo.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/radeon.h     |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c |   20 ++++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 56c48b6..2b02675 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1111,7 +1111,7 @@ struct radeon_device {
 	uint8_t				*bios;
 	bool				is_atom_bios;
 	uint16_t			bios_header_start;
-	struct radeon_bo		*stollen_vga_memory;
+	struct radeon_bo		*stolen_vga_memory;
 	/* Register mmio */
 	resource_size_t			rmmio_base;
 	resource_size_t			rmmio_size;
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index df95eb8..818b11b 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -159,8 +159,8 @@ int radeon_gem_info_ioctl(struct drm_device *dev, void *data,
 
 	args->vram_size = rdev->mc.real_vram_size;
 	args->vram_visible = rdev->mc.real_vram_size;
-	if (rdev->stollen_vga_memory)
-		args->vram_visible -= radeon_bo_size(rdev->stollen_vga_memory);
+	if (rdev->stolen_vga_memory)
+		args->vram_visible -= radeon_bo_size(rdev->stolen_vga_memory);
 	args->vram_visible -= radeon_fbdev_total_size(rdev);
 	args->gart_size = rdev->mc.gtt_size - rdev->cp.ring_size - 4096 -
 		RADEON_IB_POOL_SIZE*64*1024;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 1272e4b..412d2fd 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -531,17 +531,17 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	}
 	r = radeon_bo_create(rdev, NULL, 256 * 1024, PAGE_SIZE, true,
 				RADEON_GEM_DOMAIN_VRAM,
-				&rdev->stollen_vga_memory);
+				&rdev->stolen_vga_memory);
 	if (r) {
 		return r;
 	}
-	r = radeon_bo_reserve(rdev->stollen_vga_memory, false);
+	r = radeon_bo_reserve(rdev->stolen_vga_memory, false);
 	if (r)
 		return r;
-	r = radeon_bo_pin(rdev->stollen_vga_memory, RADEON_GEM_DOMAIN_VRAM, NULL);
-	radeon_bo_unreserve(rdev->stollen_vga_memory);
+	r = radeon_bo_pin(rdev->stolen_vga_memory, RADEON_GEM_DOMAIN_VRAM, NULL);
+	radeon_bo_unreserve(rdev->stolen_vga_memory);
 	if (r) {
-		radeon_bo_unref(&rdev->stollen_vga_memory);
+		radeon_bo_unref(&rdev->stolen_vga_memory);
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
@@ -572,13 +572,13 @@ void radeon_ttm_fini(struct radeon_device *rdev)
 
 	if (!rdev->mman.initialized)
 		return;
-	if (rdev->stollen_vga_memory) {
-		r = radeon_bo_reserve(rdev->stollen_vga_memory, false);
+	if (rdev->stolen_vga_memory) {
+		r = radeon_bo_reserve(rdev->stolen_vga_memory, false);
 		if (r == 0) {
-			radeon_bo_unpin(rdev->stollen_vga_memory);
-			radeon_bo_unreserve(rdev->stollen_vga_memory);
+			radeon_bo_unpin(rdev->stolen_vga_memory);
+			radeon_bo_unreserve(rdev->stolen_vga_memory);
 		}
-		radeon_bo_unref(&rdev->stollen_vga_memory);
+		radeon_bo_unref(&rdev->stolen_vga_memory);
 	}
 	ttm_bo_clean_mm(&rdev->mman.bdev, TTM_PL_VRAM);
 	ttm_bo_clean_mm(&rdev->mman.bdev, TTM_PL_TT);
-- 
1.7.4.1



