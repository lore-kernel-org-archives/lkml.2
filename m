Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2IQBYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:24:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2IQAt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:58 -0400
Message-Id: <20120917003644.023385807@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [ 129/135] drm/radeon: fix up pll selection on DCE5/6
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

commit 26fe45a0a76f165425f332a5aaa298f149f9db22 upstream.

Selecting ATOM_PPLL_INVALID should be equivalent as the
DCPLL or PPLL0 are already programmed for the DISPCLK, but
the preferred method is to always specify the PLL selected.
SetPixelClock will check the parameters and skip the
programming if the PLL is already set up.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
[bwh: Backported to 3.2: drop the DCE6 case]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1468,7 +1468,9 @@ static int radeon_atom_pick_pll(struct d
 				 * crtc virtual pixel clock.
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-					if (ASIC_IS_DCE5(rdev) || rdev->clock.dp_extclk)
+					if (ASIC_IS_DCE5(rdev))
+						return ATOM_DCPLL;
+					else if (rdev->clock.dp_extclk)
 						return ATOM_PPLL_INVALID;
 				}
 			}


