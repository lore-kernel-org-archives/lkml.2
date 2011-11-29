Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1LCIVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:21:02 -0500
Received: from www17.your-server.de ([213.133.104.17]:58091 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1LCIUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:54 -0500
Subject: [PATCH] drm: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.300.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
--- a/drivers/gpu/drm/drm_bufs.c 2011-11-13 11:07:23.536775743 +0100
+++ b/drivers/gpu/drm/drm_bufs.c 2011-11-28 19:50:05.523467782 +0100
@@ -679,7 +679,7 @@ int drm_addbufs_agp(struct drm_device *
 		return -EINVAL;
 	}
 
-	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
+	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
@@ -831,14 +831,14 @@ int drm_addbufs_pci(struct drm_device *
 		return -EINVAL;
 	}
 
-	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
+	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
 
-	entry->seglist = kzalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
+	entry->seglist = kcalloc(count, sizeof(*entry->seglist), GFP_KERNEL);
 	if (!entry->seglist) {
 		kfree(entry->buflist);
 		mutex_unlock(&dev->struct_mutex);
@@ -1044,8 +1044,7 @@ static int drm_addbufs_sg(struct drm_dev
 		return -EINVAL;
 	}
 
-	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
-				GFP_KERNEL);
+	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
@@ -1202,8 +1201,7 @@ static int drm_addbufs_fb(struct drm_dev
 		return -EINVAL;
 	}
 
-	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
-				GFP_KERNEL);
+	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
diff -u -p a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
--- a/drivers/gpu/drm/drm_crtc.c 2011-11-28 19:36:47.383431617 +0100
+++ b/drivers/gpu/drm/drm_crtc.c 2011-11-28 19:50:03.813436083 +0100
@@ -1877,7 +1877,7 @@ int drm_mode_dirtyfb_ioctl(struct drm_de
 			ret = -EINVAL;
 			goto out_err1;
 		}
-		clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
+		clips = kcalloc(num_clips, sizeof(*clips), GFP_KERNEL);
 		if (!clips) {
 			ret = -ENOMEM;
 			goto out_err1;
