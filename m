Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2IQAvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34009 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab2IQAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:42 -0400
Message-Id: <20120917003629.000299486@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jakob Bornecrantz <jakob@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 020/135] drm: Check for invalid cursor flags
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

commit 7c4eaca4162d0b5ad4fb39f974d7ffd71b9daa09 upstream.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_crtc.c |    2 +-
 include/drm/drm_mode.h     |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 08a7aa7..6fbfc24 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1981,7 +1981,7 @@ int drm_mode_cursor_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
 
-	if (!req->flags)
+	if (!req->flags || (~DRM_MODE_CURSOR_FLAGS & req->flags))
 		return -EINVAL;
 
 	mutex_lock(&dev->mode_config.mutex);
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 5581980..3d6301b 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -359,8 +359,9 @@ struct drm_mode_mode_cmd {
 	struct drm_mode_modeinfo mode;
 };
 
-#define DRM_MODE_CURSOR_BO	(1<<0)
-#define DRM_MODE_CURSOR_MOVE	(1<<1)
+#define DRM_MODE_CURSOR_BO	0x01
+#define DRM_MODE_CURSOR_MOVE	0x02
+#define DRM_MODE_CURSOR_FLAGS	0x03
 
 /*
  * depending on the value in flags different members are used.


