Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2KIMLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:11:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62511 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2KIMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:11:13 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/radeon: Use hweight32
Date: Fri,  9 Nov 2012 21:10:41 +0900
Message-Id: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hweight32 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/radeon/r600.c    | 8 +-------
 drivers/gpu/drm/radeon/r600_cp.c | 7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index cda280d..169ecc9 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1424,13 +1424,7 @@ u32 r6xx_remap_render_backend(struct radeon_device *rdev,
 
 int r600_count_pipe_bits(uint32_t val)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < 32; i++) {
-		ret += val & 1;
-		val >>= 1;
-	}
-	return ret;
+	return hweight32(val);
 }
 
 static void r600_gpu_init(struct radeon_device *rdev)
diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
index 2514123..be85f75 100644
--- a/drivers/gpu/drm/radeon/r600_cp.c
+++ b/drivers/gpu/drm/radeon/r600_cp.c
@@ -721,12 +721,7 @@ static u32 r600_get_tile_pipe_to_backend_map(u32 num_tile_pipes,
 
 static int r600_count_pipe_bits(uint32_t val)
 {
-	int i, ret = 0;
-	for (i = 0; i < 32; i++) {
-		ret += val & 1;
-		val >>= 1;
-	}
-	return ret;
+	return hweight32(val);
 }
 
 static void r600_gfx_init(struct drm_device *dev,
-- 
1.7.11.7

