Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab2DSVxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:53:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46047 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab2DSVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:50 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 17:08:29 EDT
Message-Id: <20120419210309.324843290@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 73/75] drm/radeon/kms: fix the regression of DVI connector check
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e36325071832f1ba96ac54fb8ba1459f08b05dd8 upstream.

The check of the encoder type in the commit [e00e8b5e: drm/radeon/kms:
fix analog load detection on DVI-I connectors] is obviously wrong, and
it's the culprit of the regression on my workstation with DVI-analog
connection resulting in the blank output.

Fixed the typo now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -946,7 +946,7 @@ radeon_dvi_detect(struct drm_connector *
 
 			encoder = obj_to_encoder(obj);
 
-			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC ||
+			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC &&
 			    encoder->encoder_type != DRM_MODE_ENCODER_TVDAC)
 				continue;
 


