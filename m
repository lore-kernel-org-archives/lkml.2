Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1DSUdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:33:12 -0400
Received: from kroah.org ([198.145.64.141]:47526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1DSUQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:43 2011
Message-Id: <20110419201043.405170600@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [02/70] drm/radeon/kms: pll tweaks for rv6xx
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 9bb09fa1b5b07459279301ac6220d575f307597b upstream.

Prefer minm over maxp.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=35994

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -531,6 +531,12 @@ static u32 atombios_adjust_pll(struct dr
 			pll->flags |= RADEON_PLL_PREFER_HIGH_FB_DIV;
 		else
 			pll->flags |= RADEON_PLL_PREFER_LOW_REF_DIV;
+
+		if ((rdev->family == CHIP_R600) ||
+		    (rdev->family == CHIP_RV610) ||
+		    (rdev->family == CHIP_RV630) ||
+		    (rdev->family == CHIP_RV670))
+			pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 


