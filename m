Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0H0VHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:07:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41947 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0H0VHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:07:50 -0400
Date: Fri, 27 Aug 2010 14:07:19 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: [PATCH] drm, video: fix use-before-NULL-check
Message-ID: <20100827210719.GD4703@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential crashes due to use-before-NULL situations.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/gpu/drm/drm_fb_helper.c           |    3 ++-
 drivers/media/video/em28xx/em28xx-video.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index de82e20..8dd7e6f 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -94,10 +94,11 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_fb_helper_conn
 	int i;
 	enum drm_connector_force force = DRM_FORCE_UNSPECIFIED;
 	struct drm_fb_helper_cmdline_mode *cmdline_mode;
-	struct drm_connector *connector = fb_helper_conn->connector;
+	struct drm_connector *connector;
 
 	if (!fb_helper_conn)
 		return false;
+	connector = fb_helper_conn->connector;
 
 	cmdline_mode = &fb_helper_conn->cmdline_mode;
 	if (!mode_option)
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 7b9ec6e..95a4b60 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -277,12 +277,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 {
 	void *startwrite, *startread;
 	int  offset;
-	int bytesperline = dev->vbi_width;
+	int bytesperline;
 
 	if (dev == NULL) {
 		em28xx_isocdbg("dev is null\n");
 		return;
 	}
+	bytesperline = dev->vbi_width;
 
 	if (dma_q == NULL) {
 		em28xx_isocdbg("dma_q is null\n");
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
