Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2KNKaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:30:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56434 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2KNKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:30:14 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 02/16] staging/omapdrm: remove the unnecessary initialization of a local variable in omap_crtc.c
Date: Wed, 14 Nov 2012 19:30:08 +0900
Message-Id: <1352889008-14783-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error fixed.
- ERROR: do not initialise statics to 0 or NULL

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/omap_crtc.c b/drivers/staging/omapdrm/omap_crtc.c
index 5249223..cbda7e0 100644
--- a/drivers/staging/omapdrm/omap_crtc.c
+++ b/drivers/staging/omapdrm/omap_crtc.c
@@ -114,7 +114,7 @@ static void omap_crtc_load_lut(struct drm_crtc *crtc)
 
 static void vblank_cb(void *arg)
 {
-	static uint32_t sequence = 0;
+	static uint32_t sequence;
 	struct drm_crtc *crtc = arg;
 	struct drm_device *dev = crtc->dev;
 	struct omap_crtc *omap_crtc = to_omap_crtc(crtc);
-- 
1.7.9.5

