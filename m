Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1CYXxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:53:21 -0400
Received: from kroah.org ([198.145.64.141]:41896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab1CYXxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:13 2011
Message-Id: <20110325234513.718925992@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [56/63] drm/radeon/kms: prefer legacy pll algo for tv-out
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 64146f8b2af1ba77fe3c21d9d6d7213b9bb72b40 upstream.

ntsc seems to work fine with either algo, some
pal TVs seem pickier.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=30832

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -957,7 +957,11 @@ static void atombios_crtc_set_pll(struct
 	/* adjust pixel clock as needed */
 	adjusted_clock = atombios_adjust_pll(crtc, mode, pll, ss_enabled, &ss);
 
-	if (ASIC_IS_AVIVO(rdev))
+	if (radeon_encoder->active_device & (ATOM_DEVICE_TV_SUPPORT))
+		/* TV seems to prefer the legacy algo on some boards */
+		radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
+					  &ref_div, &post_div);
+	else if (ASIC_IS_AVIVO(rdev))
 		radeon_compute_pll_avivo(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
 					 &ref_div, &post_div);
 	else


