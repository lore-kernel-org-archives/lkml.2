Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2DUNKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:10:54 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:58081 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2DUNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:10:53 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 09:10:52 EDT
Date: Sat, 21 Apr 2012 17:04:03 +0400
From: my84@bk.ru
To: my84@bk.ru
Subject: [PATCH] [Trivial] staging: go7007: Framesizes features
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, justinmattock@gmail.com,
        dhowells@redhat.com, gregkh@linuxfoundation.org, mchehab@infradead.org
Message-ID: <4f92b043.xYYL+7fcNMQk08OJ%my84@bk.ru>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct framesizes

Signed-off-by Volokh Konstantin <my84@bk.ru>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   79 +++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3ef4cd8..4759441 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1065,10 +1065,85 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	/* Return -EINVAL, if it is a TV board */
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
-	    (go->board_info->sensor_flags & GO7007_SENSOR_TV))
+	if (go->board_info->flags & GO7007_BOARD_HAS_TUNER)
 		return -EINVAL;
 
+	if (go->board_info->sensor_flags & GO7007_SENSOR_TV) {
+		switch (go->standard) {
+		case GO7007_STD_NTSC:
+			switch (fsize->pixel_format) {
+			case V4L2_PIX_FMT_MJPEG:
+			case V4L2_PIX_FMT_MPEG:
+			case V4L2_PIX_FMT_H263:
+				switch (fsize->index) {
+				case 0:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 720;
+					fsize->discrete.height = 480;
+					break;
+				case 1:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 640;
+					fsize->discrete.height = 480;
+					break;
+				case 2:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 352;
+					fsize->discrete.height = 240;
+					break;
+				case 3:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 320;
+					fsize->discrete.height = 240;
+					break;
+				case 4:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 176;
+					fsize->discrete.height = 112;
+					break;
+				default:
+					return -EINVAL;
+				}
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case GO7007_STD_PAL:
+			switch (fsize->pixel_format) {
+			case V4L2_PIX_FMT_MJPEG:
+			case V4L2_PIX_FMT_MPEG:
+			case V4L2_PIX_FMT_H263:
+				switch (fsize->index) {
+				case 0:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 720;
+					fsize->discrete.height = 576;
+					break;
+				case 1:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 352;
+					fsize->discrete.height = 288;
+					break;
+				case 2:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 176;
+					fsize->discrete.height = 144;
+					break;
+				default:
+					return -EINVAL;
+				}
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	}
+
 	if (fsize->index > 0)
 		return -EINVAL;
 
-- 
1.7.7.6

