Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1EUACV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:38728 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab1EUACI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="4777425"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/12] RADEON: drop inlines in r600_blit.c
Date: Fri, 20 May 2011 17:01:14 -0700
Message-Id: <1305936082-21304-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/r600_blit.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_blit.c b/drivers/gpu/drm/radeon/r600_blit.c
index 7f10434..3c031a4 100644
--- a/drivers/gpu/drm/radeon/r600_blit.c
+++ b/drivers/gpu/drm/radeon/r600_blit.c
@@ -41,7 +41,7 @@
 #define COLOR_5_6_5           0x8
 #define COLOR_8_8_8_8         0x1a
 
-static inline void
+static void
 set_render_target(drm_radeon_private_t *dev_priv, int format, int w, int h, u64 gpu_addr)
 {
 	u32 cb_color_info;
@@ -99,7 +99,7 @@ set_render_target(drm_radeon_private_t *dev_priv, int format, int w, int h, u64
 	ADVANCE_RING();
 }
 
-static inline void
+static void
 cp_set_surface_sync(drm_radeon_private_t *dev_priv,
 		    u32 sync_type, u32 size, u64 mc_addr)
 {
@@ -121,7 +121,7 @@ cp_set_surface_sync(drm_radeon_private_t *dev_priv,
 	ADVANCE_RING();
 }
 
-static inline void
+static void
 set_shaders(struct drm_device *dev)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
@@ -184,7 +184,7 @@ set_shaders(struct drm_device *dev)
 			    R600_SH_ACTION_ENA, 512, gpu_addr);
 }
 
-static inline void
+static void
 set_vtx_resource(drm_radeon_private_t *dev_priv, u64 gpu_addr)
 {
 	uint32_t sq_vtx_constant_word2;
@@ -220,7 +220,7 @@ set_vtx_resource(drm_radeon_private_t *dev_priv, u64 gpu_addr)
 				    R600_VC_ACTION_ENA, 48, gpu_addr);
 }
 
-static inline void
+static void
 set_tex_resource(drm_radeon_private_t *dev_priv,
 		 int format, int w, int h, int pitch, u64 gpu_addr)
 {
@@ -258,7 +258,7 @@ set_tex_resource(drm_radeon_private_t *dev_priv,
 
 }
 
-static inline void
+static void
 set_scissors(drm_radeon_private_t *dev_priv, int x1, int y1, int x2, int y2)
 {
 	RING_LOCALS;
@@ -282,7 +282,7 @@ set_scissors(drm_radeon_private_t *dev_priv, int x1, int y1, int x2, int y2)
 	ADVANCE_RING();
 }
 
-static inline void
+static void
 draw_auto(drm_radeon_private_t *dev_priv)
 {
 	RING_LOCALS;
@@ -311,7 +311,7 @@ draw_auto(drm_radeon_private_t *dev_priv)
 	COMMIT_RING();
 }
 
-static inline void
+static void
 set_default_state(drm_radeon_private_t *dev_priv)
 {
 	int i;
@@ -489,7 +489,7 @@ set_default_state(drm_radeon_private_t *dev_priv)
 	ADVANCE_RING();
 }
 
-static inline uint32_t i2f(uint32_t input)
+static uint32_t i2f(uint32_t input)
 {
 	u32 result, i, exponent, fraction;
 
@@ -515,7 +515,7 @@ static inline uint32_t i2f(uint32_t input)
 }
 
 
-static inline int r600_nomm_get_vb(struct drm_device *dev)
+static int r600_nomm_get_vb(struct drm_device *dev)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 	dev_priv->blit_vb = radeon_freelist_get(dev);
@@ -526,7 +526,7 @@ static inline int r600_nomm_get_vb(struct drm_device *dev)
 	return 0;
 }
 
-static inline void r600_nomm_put_vb(struct drm_device *dev)
+static void r600_nomm_put_vb(struct drm_device *dev)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
@@ -534,7 +534,7 @@ static inline void r600_nomm_put_vb(struct drm_device *dev)
 	radeon_cp_discard_buffer(dev, dev_priv->blit_vb->file_priv->master, dev_priv->blit_vb);
 }
 
-static inline void *r600_nomm_get_vb_ptr(struct drm_device *dev)
+static void *r600_nomm_get_vb_ptr(struct drm_device *dev)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 	return (((char *)dev->agp_buffer_map->handle +
-- 
1.7.4.4

