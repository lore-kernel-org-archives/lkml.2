Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0KZSqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:46:15 -0500
Received: from home.keithp.com ([63.227.221.253]:41990 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0KZSqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:46:09 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/2] drm: Set connector DPMS status to ON in drm_crtc_helper_set_config
Date: Fri, 26 Nov 2010 10:45:58 -0800
Message-Id: <1290797159-3977-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting a new crtc configuration, force the DPMS state of all
connectors to ON. Otherwise, they'll be left at OFF and a future mode set
that disables the specified connector will not turn the connector off.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index f7af91c..232ee93 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -471,6 +471,7 @@ int drm_crtc_helper_set_config(struct drm_mode_set *set)
 	int count = 0, ro, fail = 0;
 	struct drm_crtc_helper_funcs *crtc_funcs;
 	int ret = 0;
+	int i;
 
 	DRM_DEBUG_KMS("\n");
 
@@ -666,6 +667,12 @@ int drm_crtc_helper_set_config(struct drm_mode_set *set)
 		if (ret != 0)
 			goto fail;
 	}
+	DRM_DEBUG_KMS("Setting connector DPMS state to on\n");
+	for (i = 0; i < set->num_connectors; i++) {
+		DRM_DEBUG_KMS("\t[CONNECTOR:%d:%s] set DPMS on\n", set->connectors[i]->base.id,
+			      drm_get_connector_name(set->connectors[i]));
+		set->connectors[i]->dpms = DRM_MODE_DPMS_ON;
+	}
 
 	kfree(save_connectors);
 	kfree(save_encoders);
-- 
1.7.2.3

