Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453Ab1CEBAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:32 -0500
Received: from kroah.org ([198.145.64.141]:50308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760070Ab1CEBA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.678939863@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [42/73] drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 1922756124ddd53846877416d92ba4a802bc658f upstream.

This fixes CVE-2011-1013.

Reported-by: Matthiew Herrb (OpenBSD X.org team)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_irq.c |    3 ++-
 include/drm/drmP.h        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -549,7 +549,8 @@ int drm_modeset_ctl(struct drm_device *d
 		    struct drm_file *file_priv)
 {
 	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
+	int ret = 0;
+	unsigned int crtc;
 
 	/* If drm_vblank_init() hasn't been called yet, just no-op */
 	if (!dev->num_crtcs)
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1022,7 +1022,7 @@ struct drm_device {
 	struct platform_device *platformdev; /**< Platform device struture */
 
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
-	int num_crtcs;                  /**< Number of CRTCs on this device */
+	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
 	struct address_space *dev_mapping;


