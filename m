Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1CHKES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:04:18 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51673 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1CHKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:04:14 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm: fix unsigned vs signed comparison issue in modeset ctl ioctl." has been added to staging queue
Date: Tue,  8 Mar 2011 11:04:11 +0100
Message-Id: <1299578651-8902-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Dave Airlie <airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 1a24f0451bd22eaa6e61405e3fcb214fb8fa3931 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Thu, 24 Feb 2011 08:35:06 +1000
Subject: [PATCH] drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

commit 1922756124ddd53846877416d92ba4a802bc658f upstream.

This fixes CVE-2011-1013.

Reported-by: Matthiew Herrb (OpenBSD X.org team)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/drm_irq.c |    3 ++-
 include/drm/drmP.h        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index b98384d..d07dfe1 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -543,7 +543,8 @@ int drm_modeset_ctl(struct drm_device *dev, void *data,
 		    struct drm_file *file_priv)
 {
 	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
+	int ret = 0;
+	unsigned int crtc;

 	/* If drm_vblank_init() hasn't been called yet, just no-op */
 	if (!dev->num_crtcs)
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index ffac157..c6c8eb9 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1020,7 +1020,7 @@ struct drm_device {
 	struct pci_controller *hose;
 #endif
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
-	int num_crtcs;                  /**< Number of CRTCs on this device */
+	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
 	struct address_space *dev_mapping;
--
1.7.0.4

