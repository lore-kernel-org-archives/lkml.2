Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1LCIW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:22:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:58079 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1LCIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:51 -0500
Subject: [PATCH] vmwgfx: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.299.camel@localhost.localdomain>
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

diff -u -p a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c 2011-11-13 11:07:24.343455126 +0100
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c 2011-11-28 19:50:07.413502824 +0100
@@ -140,7 +140,7 @@ int vmw_present_ioctl(struct drm_device
 		goto out_clips;
 	}
 
-	clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
+	clips = kcalloc(num_clips, sizeof(*clips), GFP_KERNEL);
 	if (clips == NULL) {
 		DRM_ERROR("Failed to allocate clip rect list.\n");
 		ret = -ENOMEM;
@@ -232,7 +232,7 @@ int vmw_present_readback_ioctl(struct dr
 		goto out_clips;
 	}
 
-	clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
+	clips = kcalloc(num_clips, sizeof(*clips), GFP_KERNEL);
 	if (clips == NULL) {
 		DRM_ERROR("Failed to allocate clip rect list.\n");
 		ret = -ENOMEM;
