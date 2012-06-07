Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab2FGEUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2FGEUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:46 -0400
Message-Id: <20120607040346.363154246@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:44 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 68/82] drm/radeon/audio: dont hardcode CRTC id
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit 0aecb5a4ba1ea4167f31d1790eec027f1e658f2d upstream.

This is based on info released by AMD, should allow using audio in much
more cases.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_audio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_audio.c
+++ b/drivers/gpu/drm/radeon/r600_audio.c
@@ -239,6 +239,7 @@ void r600_audio_set_clock(struct drm_enc
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(encoder->crtc);
 	int base_rate = 48000;
 
 	switch (radeon_encoder->encoder_id) {
@@ -264,8 +265,8 @@ void r600_audio_set_clock(struct drm_enc
 		WREG32(EVERGREEN_AUDIO_PLL1_DIV, clock * 10);
 		WREG32(EVERGREEN_AUDIO_PLL1_UNK, 0x00000071);
 
-		/* Some magic trigger or src sel? */
-		WREG32_P(0x5ac, 0x01, ~0x77);
+		/* Select DTO source */
+		WREG32(0x5ac, radeon_crtc->crtc_id);
 	} else {
 		switch (dig->dig_encoder) {
 		case 0:


