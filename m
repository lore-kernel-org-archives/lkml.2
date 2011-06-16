Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1FPHgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:36:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48977 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515Ab1FPHAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:55 -0400
X-Sasl-enc: HHKcfoGeTrML4vNi4VzYAshOGe7fGU5BbkEd6TcQ85rE 1308207654
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.622931544@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [37/89] drm/radeon/kms: viewport height has to be even
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit adcfde516e10aad72d66f6fefd36e6d0e6bd7be7 upstream.

Otherwise, no vblank interrupts.
Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37522

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1011,7 +1011,7 @@ static int dce4_crtc_do_set_base(struct
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
 	u32 fb_swap = EVERGREEN_GRPH_ENDIAN_SWAP(EVERGREEN_GRPH_ENDIAN_NONE);
-	u32 tmp;
+	u32 tmp, viewport_w, viewport_h;
 	int r;
 
 	/* no fb bound */
@@ -1137,8 +1137,10 @@ static int dce4_crtc_do_set_base(struct
 	y &= ~1;
 	WREG32(EVERGREEN_VIEWPORT_START + radeon_crtc->crtc_offset,
 	       (x << 16) | y);
+	viewport_w = crtc->mode.hdisplay;
+	viewport_h = (crtc->mode.vdisplay + 1) & ~1;
 	WREG32(EVERGREEN_VIEWPORT_SIZE + radeon_crtc->crtc_offset,
-	       (crtc->mode.hdisplay << 16) | crtc->mode.vdisplay);
+	       (viewport_w << 16) | viewport_h);
 
 	/* pageflip setup */
 	/* make sure flip is at vb rather than hb */
@@ -1179,7 +1181,7 @@ static int avivo_crtc_do_set_base(struct
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
 	u32 fb_swap = R600_D1GRPH_SWAP_ENDIAN_NONE;
-	u32 tmp;
+	u32 tmp, viewport_w, viewport_h;
 	int r;
 
 	/* no fb bound */
@@ -1304,8 +1306,10 @@ static int avivo_crtc_do_set_base(struct
 	y &= ~1;
 	WREG32(AVIVO_D1MODE_VIEWPORT_START + radeon_crtc->crtc_offset,
 	       (x << 16) | y);
+	viewport_w = crtc->mode.hdisplay;
+	viewport_h = (crtc->mode.vdisplay + 1) & ~1;
 	WREG32(AVIVO_D1MODE_VIEWPORT_SIZE + radeon_crtc->crtc_offset,
-	       (crtc->mode.hdisplay << 16) | crtc->mode.vdisplay);
+	       (viewport_w << 16) | viewport_h);
 
 	/* pageflip setup */
 	/* make sure flip is at vb rather than hb */


