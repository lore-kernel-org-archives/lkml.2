Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2H0HZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:25:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2H0HZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,833,1336320000"; 
   d="scan'208";a="5730524"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 4/5] video:omap3isp:fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:15 +0800
Message-Id: <1346052196-32682-5-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize complete at 2012/08/27 15:25:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
translated as ENOTTY to user mode.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/media/video/omap3isp/ispvideo.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index b37379d..2dd982e 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -337,7 +337,7 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 	if (ret == -ENOIOCTLCMD)
-		ret = -EINVAL;
+		ret = -ENOTTY;
 
 	mutex_unlock(&video->mutex);
 
@@ -723,7 +723,7 @@ isp_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 	if (ret)
-		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 
 	isp_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
 	return 0;
@@ -744,7 +744,7 @@ isp_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
 	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
 	mutex_unlock(&video->mutex);
 
-	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
 
 static int
@@ -771,7 +771,7 @@ isp_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
 	if (ret < 0)
-		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 
 	crop->c.left = 0;
 	crop->c.top = 0;
@@ -796,7 +796,7 @@ isp_video_set_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
 	mutex_unlock(&video->mutex);
 
-	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
 }
 
 static int
-- 
1.7.12

