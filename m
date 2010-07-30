Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab0G3Saw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:30:52 -0400
Received: from kroah.org ([198.145.64.141]:58175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759894Ab0G3RzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.219519573@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [062/205] drm/radeon/kms: fix DP after DPMS cycle
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a5f798ce2b9de4b14c46cb68d58c488dc1b8e215 upstream.

The transmitter needs to be enabled before the link is trained.

Reported-By: Lars Doelle <lars.doelle@on-line.de>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1075,6 +1075,8 @@ radeon_atom_encoder_dpms(struct drm_enco
 	if (is_dig) {
 		switch (mode) {
 		case DRM_MODE_DPMS_ON:
+			if (!ASIC_IS_DCE4(rdev))
+				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 			if (atombios_get_encoder_mode(encoder) == ATOM_ENCODER_MODE_DP) {
 				struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
 
@@ -1082,8 +1084,6 @@ radeon_atom_encoder_dpms(struct drm_enco
 				if (ASIC_IS_DCE4(rdev))
 					atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_ON);
 			}
-			if (!ASIC_IS_DCE4(rdev))
-				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 			break;
 		case DRM_MODE_DPMS_STANDBY:
 		case DRM_MODE_DPMS_SUSPEND:


