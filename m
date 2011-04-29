Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab1D2TIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:08:18 -0400
Received: from kroah.org ([198.145.64.141]:50232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab1D2S6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.039379722@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [15/55] drm/radeon/kms: pll tweaks for r7xx
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 5785e53ffa73f77fb19e378c899027afc07272bc upstream.

Prefer min m to max p only on pre-r7xx asics.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=36197

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -532,10 +532,7 @@ static u32 atombios_adjust_pll(struct dr
 		else
 			pll->flags |= RADEON_PLL_PREFER_LOW_REF_DIV;
 
-		if ((rdev->family == CHIP_R600) ||
-		    (rdev->family == CHIP_RV610) ||
-		    (rdev->family == CHIP_RV630) ||
-		    (rdev->family == CHIP_RV670))
+		if (rdev->family < CHIP_RV770)
 			pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
@@ -565,7 +562,6 @@ static u32 atombios_adjust_pll(struct dr
 			if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
 				if (ss_enabled) {
 					if (ss->refdiv) {
-						pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 						pll->flags |= RADEON_PLL_USE_REF_DIV;
 						pll->reference_div = ss->refdiv;
 						if (ASIC_IS_AVIVO(rdev))


