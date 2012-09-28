Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422816Ab2I1VXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:23:46 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56440 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422775Ab2I1U3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 154/218] drm: Check for invalid cursor flags
Date: Fri, 28 Sep 2012 13:16:11 -0700
Message-Id: <20120928201519.203050447@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

commit 7c4eaca4162d0b5ad4fb39f974d7ffd71b9daa09 upstream.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |    2 +-
 include/drm/drm_mode.h     |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1981,7 +1981,7 @@ int drm_mode_cursor_ioctl(struct drm_dev
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
 
-	if (!req->flags)
+	if (!req->flags || (~DRM_MODE_CURSOR_FLAGS & req->flags))
 		return -EINVAL;
 
 	mutex_lock(&dev->mode_config.mutex);
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -343,8 +343,9 @@ struct drm_mode_mode_cmd {
 	struct drm_mode_modeinfo mode;
 };
 
-#define DRM_MODE_CURSOR_BO	(1<<0)
-#define DRM_MODE_CURSOR_MOVE	(1<<1)
+#define DRM_MODE_CURSOR_BO	0x01
+#define DRM_MODE_CURSOR_MOVE	0x02
+#define DRM_MODE_CURSOR_FLAGS	0x03
 
 /*
  * depending on the value in flags different members are used.


