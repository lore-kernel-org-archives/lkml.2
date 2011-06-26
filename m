Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1FZQKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1FZQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:56 -0400
Date: Sun, 26 Jun 2011 13:06:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/14] [media] pwc: Use the default version for
 VIDIOC_QUERYCAP
Message-ID: <20110626130608.6f491f24@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussing with Hans, change pwc to use the default version
control.

The only version ever used for pwc driver is 10.0.12, due to
commit 2b455db6d456ef2d44808a8377fd3bc832e08317.

Changing it to 3.x.y won't conflict with the old version.
There's no namespace conflicts in any predictable future.

Even on the remote far-away case where we might have a conflict,
it will be on just one specific stable Kernel release (Kernel 10.0.12),
if we ever have such stable release.

So, it is safe and consistent on using 3.x.y numering schema for
it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index f85c512..059bd95 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -349,7 +349,6 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	strcpy(cap->driver, PWC_NAME);
 	strlcpy(cap->card, vdev->name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->version = PWC_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE	|
 		V4L2_CAP_STREAMING	|
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index 78185c6..98950de 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -44,12 +44,7 @@
 #include <media/pwc-ioctl.h>
 
 /* Version block */
-#define PWC_MAJOR	10
-#define PWC_MINOR	0
-#define PWC_EXTRAMINOR	15
-
-#define PWC_VERSION_CODE KERNEL_VERSION(PWC_MAJOR, PWC_MINOR, PWC_EXTRAMINOR)
-#define PWC_VERSION __stringify(PWC_MAJOR) "." __stringify(PWC_MINOR) "." __stringify(PWC_EXTRAMINOR)
+#define PWC_VERSION	"10.0.15"
 #define PWC_NAME 	"pwc"
 #define PFX		PWC_NAME ": "
 
-- 
1.7.1


