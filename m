Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2IQBXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:23:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab2IQAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:59 -0400
Message-Id: <20120917003644.155904821@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 130/135] drm/radeon: fix ordering in pll picking on dce4+
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ecd67955fd4c8e66e4df312098989d5fa7da624c upstream.

No functional change, but re-order the cases so they
evaluate properly due to the way the DCE macros work.

Noticed by kallisti5 on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: drop the DCE6 case]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1468,10 +1468,10 @@ static int radeon_atom_pick_pll(struct d
 				 * crtc virtual pixel clock.
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-					if (ASIC_IS_DCE5(rdev))
-						return ATOM_DCPLL;
-					else if (rdev->clock.dp_extclk)
+					if (rdev->clock.dp_extclk)
 						return ATOM_PPLL_INVALID;
+					else if (ASIC_IS_DCE5(rdev))
+						return ATOM_DCPLL;
 				}
 			}
 		}


