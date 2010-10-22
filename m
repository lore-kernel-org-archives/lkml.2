Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab0JVTH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:07:59 -0400
Received: from kroah.org ([198.145.64.141]:34281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432Ab0JVS4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.381943280@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, airlied@gmail.com,
        dri-devel@lists.freedesktop.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [067/103] drm/radeon/kms: fix possible sigbus in evergreen accel code
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

Not upstream in Linus's tree as it was fixed by a much more intrusive
patch in a different manner, commit c919b371cb734f42b11


2.6.35 and 2.6.36 do not contain blit support for evergreen
asics so if they use unmappable vram, you can end up with an
unreachable buffer address.  This should not be applied to drm-next
as that tree already contains evergreen blit support.  This should
only be applied to the 2.6.35 and 2.6.36 stable trees.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=30188

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1389,6 +1389,8 @@ int evergreen_mc_init(struct radeon_devi
 	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
 	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
+	/* limit it to the aperture size for now as there is no blit support in 2.6.35/36*/
+	rdev->mc.real_vram_size = rdev->mc.visible_vram_size;
 	r600_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
 


