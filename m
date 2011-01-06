Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1AFA24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:28:56 -0500
Received: from kroah.org ([198.145.64.141]:35404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1AFA2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:54 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.742407552@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [011/152] drm/radeon/kms: fix vram base calculation on rs780/rs880
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8961d52d4cc52edf5672f8f2712c57162b736793 upstream.

Avoid overflowing a 32 bit value.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1198,8 +1198,10 @@ void r600_vram_gtt_location(struct radeo
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


