Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1BBBLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:11:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:32493 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1BBAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028226"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [9/139] drm/radeon/kms: fix vram base calculation on rs780/rs880
Message-Id: <20110202004323.267883E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 8961d52d4cc52edf5672f8f2712c57162b736793 upstream.

Avoid overflowing a 32 bit value.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/r600.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/r600.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
@@ -1189,8 +1189,10 @@ void r600_vram_gtt_location(struct radeo
 				mc->vram_end, mc->real_vram_size >> 20);
 	} else {
 		u64 base = 0;
-		if (rdev->flags & RADEON_IS_IGP)
-			base = (RREG32(MC_VM_FB_LOCATION) & 0xFFFF) << 24;
+		if (rdev->flags & RADEON_IS_IGP) {
+			base = RREG32(MC_VM_FB_LOCATION) & 0xFFFF;
+			base <<= 24;
+		}
 		radeon_vram_location(rdev, &rdev->mc, base);
 		rdev->mc.gtt_base_align = 0;
 		radeon_gtt_location(rdev, mc);
