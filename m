Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1FZQHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1FZQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:38 -0400
Date: Sun, 26 Jun 2011 13:06:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/14] [media] pvrusb2: Use LINUX_VERSION_CODE for
 VIDIOC_QUERYCAP
Message-ID: <20110626130614.209dd335@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pvrusb2 doesn't use vidioc_ioctl2. As the API is changing to use
a common version for all drivers, we need to expliticly fix this
driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/pvrusb2/pvrusb2-main.c b/drivers/media/video/pvrusb2/pvrusb2-main.c
index 2254194..c1d9bb6 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-main.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-main.c
@@ -168,6 +168,7 @@ module_exit(pvr_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.9.1");
 
 
 /*
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 1c299a8..96effbc 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -91,7 +91,7 @@ static struct v4l2_capability pvr_capability ={
 	.driver         = "pvrusb2",
 	.card           = "Hauppauge WinTV pvr-usb2",
 	.bus_info       = "usb",
-	.version        = KERNEL_VERSION(0, 9, 0),
+	.version        = LINUX_VERSION_CODE,
 	.capabilities   = (V4L2_CAP_VIDEO_CAPTURE |
 			   V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
 			   V4L2_CAP_READWRITE),
-- 
1.7.1


