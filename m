Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2JCG17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:27:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59442 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2JCG15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:27:57 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] media: davinci: vpbe: fix build warning
Date: Wed,  3 Oct 2012 11:57:38 +0530
Message-Id: <1349245658-7125-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

recent patch with commit id 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
which makes vidioc_s_crop const, was causing a following build warning,

vpbe_display.c: In function 'vpbe_display_s_crop':
vpbe_display.c:640: warning: initialization discards qualifiers from pointer target type

This patch fixes the above build warning.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1b238fe..161c776 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -637,7 +637,7 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct osd_layer_config *cfg = &layer->layer_info.config;
 	struct osd_state *osd_device = disp_dev->osd_device;
-	struct v4l2_rect *rect = &crop->c;
+	struct v4l2_rect rect = crop->c;
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -648,21 +648,21 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (rect->top < 0)
-		rect->top = 0;
-	if (rect->left < 0)
-		rect->left = 0;
+	if (rect.top < 0)
+		rect.top = 0;
+	if (rect.left < 0)
+		rect.left = 0;
 
-	vpbe_disp_check_window_params(disp_dev, rect);
+	vpbe_disp_check_window_params(disp_dev, &rect);
 
 	osd_device->ops.get_layer_config(osd_device,
 			layer->layer_info.id, cfg);
 
 	vpbe_disp_calculate_scale_factor(disp_dev, layer,
-					rect->width,
-					rect->height);
-	vpbe_disp_adj_position(disp_dev, layer, rect->top,
-					rect->left);
+					rect.width,
+					rect.height);
+	vpbe_disp_adj_position(disp_dev, layer, rect.top,
+					rect.left);
 	ret = osd_device->ops.set_layer_config(osd_device,
 				layer->layer_info.id, cfg);
 	if (ret < 0) {
-- 
1.7.4.1

