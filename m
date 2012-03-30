Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966300Ab2C3VjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:39:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37940 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936205Ab2C3VcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:06 -0400
X-Sasl-enc: CrE40c3eDcXU+idF1XlYh9B6Y/6L0lJKNvz3umlZczDd 1333143125
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:56 2012
Message-Id: <20120330194855.862704172@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lennert Buytenhek <buytenh@wantstofly.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 147/175] drm/radeon/kms/atom: force bpc to 8 for now
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 017d213f649c6775e4a4349e50a5631a4e4c7308 upstream.

Using the bpc (bits per color) specified by the monitor
can cause problems in some cases.  Until we get a better
handle on how to deal with those cases, just use a bpc of 8.

Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c     |    8 +++++---
 drivers/gpu/drm/radeon/atombios_dp.c       |    3 +++
 drivers/gpu/drm/radeon/atombios_encoders.c |    4 ++--
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -550,8 +550,8 @@ static u32 atombios_adjust_pll(struct dr
 		if (encoder->crtc == crtc) {
 			radeon_encoder = to_radeon_encoder(encoder);
 			connector = radeon_get_connector_for_encoder(encoder);
-			if (connector && connector->display_info.bpc)
-				bpc = connector->display_info.bpc;
+			/* if (connector && connector->display_info.bpc)
+				bpc = connector->display_info.bpc; */
 			encoder_mode = atombios_get_encoder_mode(encoder);
 			is_duallink = radeon_dig_monitor_is_duallink(encoder, mode->clock);
 			if ((radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
@@ -922,7 +922,9 @@ static void atombios_crtc_set_pll(struct
 		struct radeon_connector_atom_dig *dig_connector =
 			radeon_connector->con_priv;
 		int dp_clock;
-		bpc = connector->display_info.bpc;
+
+		/* if (connector->display_info.bpc)
+			bpc = connector->display_info.bpc; */
 
 		switch (encoder_mode) {
 		case ATOM_ENCODER_MODE_DP_MST:
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -405,10 +405,13 @@ static void dp_get_adjust_train(u8 link_
 /* get bpc from the EDID */
 static int convert_bpc_to_bpp(int bpc)
 {
+#if 0
 	if (bpc == 0)
 		return 24;
 	else
 		return bpc * 3;
+#endif
+	return 24;
 }
 
 /* get the max pix clock supported by the link rate and lane num */
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -537,7 +537,7 @@ atombios_dig_encoder_setup(struct drm_en
 		dp_clock = dig_connector->dp_clock;
 		dp_lane_count = dig_connector->dp_lane_count;
 		hpd_id = radeon_connector->hpd.hpd;
-		bpc = connector->display_info.bpc;
+		/* bpc = connector->display_info.bpc; */
 	}
 
 	/* no dig encoder assigned */
@@ -1098,7 +1098,7 @@ atombios_external_encoder_setup(struct d
 		dp_lane_count = dig_connector->dp_lane_count;
 		connector_object_id =
 			(radeon_connector->connector_object_id & OBJECT_ID_MASK) >> OBJECT_ID_SHIFT;
-		bpc = connector->display_info.bpc;
+		/* bpc = connector->display_info.bpc; */
 	}
 
 	memset(&args, 0, sizeof(args));


