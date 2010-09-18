Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0IRTSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:18:35 -0400
Received: from kroah.org ([198.145.64.141]:43928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab0IRTQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:29 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.418546431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [118/129] drm/radeon/kms: properly set crtc high base on r7xx
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 95347871865ca5093c7e87a223274f7c3b5eccda upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1007,11 +1007,11 @@ static int avivo_crtc_set_base(struct dr
 
 	if (rdev->family >= CHIP_RV770) {
 		if (radeon_crtc->crtc_id) {
-			WREG32(R700_D2GRPH_PRIMARY_SURFACE_ADDRESS_HIGH, 0);
-			WREG32(R700_D2GRPH_SECONDARY_SURFACE_ADDRESS_HIGH, 0);
+			WREG32(R700_D2GRPH_PRIMARY_SURFACE_ADDRESS_HIGH, upper_32_bits(fb_location));
+			WREG32(R700_D2GRPH_SECONDARY_SURFACE_ADDRESS_HIGH, upper_32_bits(fb_location));
 		} else {
-			WREG32(R700_D1GRPH_PRIMARY_SURFACE_ADDRESS_HIGH, 0);
-			WREG32(R700_D1GRPH_SECONDARY_SURFACE_ADDRESS_HIGH, 0);
+			WREG32(R700_D1GRPH_PRIMARY_SURFACE_ADDRESS_HIGH, upper_32_bits(fb_location));
+			WREG32(R700_D1GRPH_SECONDARY_SURFACE_ADDRESS_HIGH, upper_32_bits(fb_location));
 		}
 	}
 	WREG32(AVIVO_D1GRPH_PRIMARY_SURFACE_ADDRESS + radeon_crtc->crtc_offset,


