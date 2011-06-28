Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab1F1Qev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab1F1QcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:01 -0400
Date: Mon, 27 Jun 2011 23:17:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 06/13] [media] et61x251: Use LINUX_VERSION_CODE for
 VIDIOC_QUERYCAP
Message-ID: <20110627231728.2e895fa7@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

et61x251 doesn't use vidioc_ioctl2. As the API is changing to use
a common version for all drivers, we need to expliticly fix this
driver.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/et61x251/et61x251.h b/drivers/media/video/et61x251/et61x251.h
index bf66189..14bb907 100644
--- a/drivers/media/video/et61x251/et61x251.h
+++ b/drivers/media/video/et61x251/et61x251.h
@@ -21,7 +21,6 @@
 #ifndef _ET61X251_H_
 #define _ET61X251_H_
 
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a982750..d7efb33 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
  ***************************************************************************/
 
+#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -48,8 +49,7 @@
 #define ET61X251_MODULE_AUTHOR  "(C) 2006-2007 Luca Risolia"
 #define ET61X251_AUTHOR_EMAIL   "<luca.risolia@studio.unibo.it>"
 #define ET61X251_MODULE_LICENSE "GPL"
-#define ET61X251_MODULE_VERSION "1:1.09"
-#define ET61X251_MODULE_VERSION_CODE  KERNEL_VERSION(1, 1, 9)
+#define ET61X251_MODULE_VERSION "1.1.10"
 
 /*****************************************************************************/
 
@@ -1579,7 +1579,7 @@ et61x251_vidioc_querycap(struct et61x251_device* cam, void __user * arg)
 {
 	struct v4l2_capability cap = {
 		.driver = "et61x251",
-		.version = ET61X251_MODULE_VERSION_CODE,
+		.version = LINUX_VERSION_CODE,
 		.capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 				V4L2_CAP_STREAMING,
 	};
-- 
1.7.1


