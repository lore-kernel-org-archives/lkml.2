Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab2EIGbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:31:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229Ab2EIGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:30:59 -0400
Message-Id: <20120509055044.372679815@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 106/167] [PATCH] drm/radeon/kms: need to set up ss on DP bridges as well
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 700698e7c303f5095107c62a81872c2c3dad1702 upstream.

Makes Nutmeg DP to VGA bridges work for me.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=42490

Noticed by Jerome Glisse (after weeks of debugging).

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index c5c31e0..af1054f 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -958,8 +958,8 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
 		break;
 	}
 
-	if (radeon_encoder->active_device &
-	    (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) {
+	if ((radeon_encoder->active_device & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
+	    (radeon_encoder_get_dp_bridge_encoder_id(encoder) != ENCODER_OBJECT_ID_NONE)) {
 		struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 		struct drm_connector *connector =
 			radeon_get_connector_for_encoder(encoder);
-- 
1.7.10



