Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab1F1QfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757Ab1F1QcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:05 -0400
Date: Mon, 27 Jun 2011 23:17:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 08/13] [media] sn9c102: Use LINUX_VERSION_CODE for
 VIDIOC_QUERYCAP
Message-ID: <20110627231730.5d68ef63@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sn9c102 doesn't use vidioc_ioctl2. As the API is changing to use
a common version for all drivers, we need to expliticly fix this
driver.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/sn9c102/sn9c102.h b/drivers/media/video/sn9c102/sn9c102.h
index cbfc444..22ea211 100644
--- a/drivers/media/video/sn9c102/sn9c102.h
+++ b/drivers/media/video/sn9c102/sn9c102.h
@@ -21,7 +21,6 @@
 #ifndef _SN9C102_H_
 #define _SN9C102_H_
 
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 0e07c49..d8eece8 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -33,6 +33,7 @@
 #include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/version.h>
 #include <linux/page-flags.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
@@ -47,8 +48,7 @@
 #define SN9C102_MODULE_AUTHOR   "(C) 2004-2007 Luca Risolia"
 #define SN9C102_AUTHOR_EMAIL    "<luca.risolia@studio.unibo.it>"
 #define SN9C102_MODULE_LICENSE  "GPL"
-#define SN9C102_MODULE_VERSION  "1:1.47pre49"
-#define SN9C102_MODULE_VERSION_CODE  KERNEL_VERSION(1, 1, 47)
+#define SN9C102_MODULE_VERSION  "1:1.48"
 
 /*****************************************************************************/
 
@@ -2158,7 +2158,7 @@ sn9c102_vidioc_querycap(struct sn9c102_device* cam, void __user * arg)
 {
 	struct v4l2_capability cap = {
 		.driver = "sn9c102",
-		.version = SN9C102_MODULE_VERSION_CODE,
+		.version = LINUX_VERSION_CODE,
 		.capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 				V4L2_CAP_STREAMING,
 	};
-- 
1.7.1


