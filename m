Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab2C3VVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46547 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004Ab2C3VVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:04 -0400
Message-Id: <20120330194841.667568133@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 085/175] drm/radeon/kms: fix analog load detection on DVI-I connectors
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e00e8b5e760cbbe9067daeae5454d67c44c8d035 upstream.

We digital encoders have a detect function as well (for
DP to VGA bridges), so we make sure we choose the analog
one here.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=47007

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -946,6 +946,10 @@ radeon_dvi_detect(struct drm_connector *
 
 			encoder = obj_to_encoder(obj);
 
+			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC ||
+			    encoder->encoder_type != DRM_MODE_ENCODER_TVDAC)
+				continue;
+
 			encoder_funcs = encoder->helper_private;
 			if (encoder_funcs->detect) {
 				if (ret != connector_status_connected) {


