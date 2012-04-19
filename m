Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab2DSVOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:14:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65069 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab2DSVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:33 -0400
Message-Id: <20120419210616.003422872@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:07:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 57/59] drm/radeon/kms: fix the regression of DVI connector check
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -990,7 +990,7 @@ radeon_dvi_detect(struct drm_connector *
 
 			encoder = obj_to_encoder(obj);
 
-			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC ||
+			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC &&
 			    encoder->encoder_type != DRM_MODE_ENCODER_TVDAC)
 				continue;
 


