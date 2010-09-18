Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0IRTQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:31 -0400
Received: from kroah.org ([198.145.64.141]:43921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0IRTQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:28 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.334784557@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [117/129] drm/radeon/kms: force legacy pll algo for RV620 LVDS
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f90087eea44ce5fad139f086bc9d89ca37b0edc2 upstream.

There has been periodic evidence that LVDS, on at least some
panels, prefers the dividers selected by the legacy pll algo.
This patch forces the use of the legacy pll algo on RV620
LVDS panels.  The old behavior (new pll algo) can be selected
by setting the new_pll module parameter to 1.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=30029

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -527,14 +527,15 @@ static u32 atombios_adjust_pll(struct dr
 					pll->algo = PLL_ALGO_LEGACY;
 					pll->flags |= RADEON_PLL_PREFER_CLOSEST_LOWER;
 				}
-				/* There is some evidence (often anecdotal) that RV515 LVDS
+				/* There is some evidence (often anecdotal) that RV515/RV620 LVDS
 				 * (on some boards at least) prefers the legacy algo.  I'm not
 				 * sure whether this should handled generically or on a
 				 * case-by-case quirk basis.  Both algos should work fine in the
 				 * majority of cases.
 				 */
 				if ((radeon_encoder->active_device & (ATOM_DEVICE_LCD_SUPPORT)) &&
-				    (rdev->family == CHIP_RV515)) {
+				    ((rdev->family == CHIP_RV515) ||
+				     (rdev->family == CHIP_RV620))) {
 					/* allow the user to overrride just in case */
 					if (radeon_new_pll == 1)
 						pll->algo = PLL_ALGO_NEW;


