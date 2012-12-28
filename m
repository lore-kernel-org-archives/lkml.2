Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2L1TSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55257 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab2L1TSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:20 -0500
Message-Id: <20121228190353.518111503@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 111/173] drm/radeon/kms: use frac fb div on APUs
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 37d4174d2d252c37dcb3d88cafae488542087848 upstream.

Seems to be more stable on certain monitors.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=48880

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: drop the ASIC_IS_DCE61() case]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index b5ff1f7..c5c31e0 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -575,6 +575,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 
 		if (rdev->family < CHIP_RV770)
 			pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
+		/* use frac fb div on APUs */
+		if (ASIC_IS_DCE41(rdev))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 


