Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab2JKAOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:14:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45075 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196Ab2JKAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:14:05 -0400
X-Sasl-enc: XCvc+GH51y7WPAWBeJLl3zLpFFiV1JNdLTx99w5lENb6 1349914444
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, lu hua <huax.lu@intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 093/133] drm: Destroy the planes prior to destroying the associated CRTC
Date: Thu, 11 Oct 2012 07:51:59 +0900
Message-Id: <20121010224911.235874613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 3184009c36da413724f283e3c7ac9cc60c623bc4 upstream.

As during the plane cleanup, we wish to disable the hardware and
so may modify state on the associated CRTC, that CRTC must continue to
exist until we are finished.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=54101
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: lu hua <huax.lu@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1034,15 +1034,15 @@ void drm_mode_config_cleanup(struct drm_
 		fb->funcs->destroy(fb);
 	}
 
-	list_for_each_entry_safe(crtc, ct, &dev->mode_config.crtc_list, head) {
-		crtc->funcs->destroy(crtc);
-	}
-
 	list_for_each_entry_safe(plane, plt, &dev->mode_config.plane_list,
 				 head) {
 		plane->funcs->destroy(plane);
 	}
 
+	list_for_each_entry_safe(crtc, ct, &dev->mode_config.crtc_list, head) {
+		crtc->funcs->destroy(crtc);
+	}
+
 	idr_remove_all(&dev->mode_config.crtc_idr);
 	idr_destroy(&dev->mode_config.crtc_idr);
 }


