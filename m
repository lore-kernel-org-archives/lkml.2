Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1FZQKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1FZQHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:46 -0400
Date: Sun, 26 Jun 2011 13:06:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/14] [media] return -ENOIOCTLCMD for unsupported ioctl's
 at legacy drivers
Message-ID: <20110626130619.2338a6a8@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those drivers are not relying at the V4L2 core to handle the ioctl's.
So, we need to manually patch them every time a change goes to the
core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a982750..4bf43b1 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -2480,16 +2480,8 @@ static long et61x251_ioctl_v4l2(struct file *filp,
 	case VIDIOC_S_PARM:
 		return et61x251_vidioc_s_parm(cam, arg);
 
-	case VIDIOC_G_STD:
-	case VIDIOC_S_STD:
-	case VIDIOC_QUERYSTD:
-	case VIDIOC_ENUMSTD:
-	case VIDIOC_QUERYMENU:
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-		return -EINVAL;
-
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 
 	}
 }
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 3876114..1c299a8 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -369,11 +369,6 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		break;
 	}
 
-	case VIDIOC_S_AUDIO:
-	{
-		ret = -EINVAL;
-		break;
-	}
 	case VIDIOC_G_TUNER:
 	{
 		struct v4l2_tuner *vt = (struct v4l2_tuner *)arg;
@@ -850,7 +845,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 #endif
 
 	default :
-		ret = -EINVAL;
+		ret = -ENOIOCTLCMD;
 		break;
 	}
 
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 0e07c49..44bf6c3 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -3187,16 +3187,8 @@ static long sn9c102_ioctl_v4l2(struct file *filp,
 	case VIDIOC_S_AUDIO:
 		return sn9c102_vidioc_s_audio(cam, arg);
 
-	case VIDIOC_G_STD:
-	case VIDIOC_S_STD:
-	case VIDIOC_QUERYSTD:
-	case VIDIOC_ENUMSTD:
-	case VIDIOC_QUERYMENU:
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-		return -EINVAL;
-
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 
 	}
 }
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 543a803..1fe2c8f 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -83,7 +83,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	default:
 		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
 			  "%u.\n", xmap->v4l2_type);
-		ret = -EINVAL;
+		ret = -ENOIOCTLCMD;
 		goto done;
 	}
 
-- 
1.7.1


