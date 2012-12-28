Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2L1Tmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:42:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55256 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab2L1TSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:25 -0500
Message-Id: <20121228190353.750132005@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 112/173] drm/radeon/dce32+: use fractional fb dividers for high clocks
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

commit a02dc74b317d78298cb0587b9b1f6f741fd5c139 upstream.

Fixes flickering with some high res montiors.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: use pll->flags instead of radeon_crtc->pll_flags]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -544,6 +544,8 @@ static u32 atombios_adjust_pll(struct dr
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 


