Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1FZQKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1FZQHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:36 -0400
Date: Sun, 26 Jun 2011 13:06:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/14] [media] et61x251: Use LINUX_VERSION_CODE for
 VIDIOC_QUERYCAP
Message-ID: <20110626130613.6392f2fc@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

et61x251 doesn't use vidioc_ioctl2. As the API is changing to use
a common version for all drivers, we need to expliticly fix this
driver.

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
index 4bf43b1..81eb1aa 100644
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
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 08ce994..e99df66 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -24,7 +24,6 @@
 #define MODULE_NAME "gspca"
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
@@ -51,11 +50,12 @@
 #error "DEF_NURBS too big"
 #endif
 
+#define DRIVER_VERSION_NUMBER	"2.13.0"
+
 MODULE_AUTHOR("Jean-François Moine <http://moinejf.free.fr>");
 MODULE_DESCRIPTION("GSPCA USB Camera Driver");
 MODULE_LICENSE("GPL");
-
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 13, 0)
+MODULE_VERSION(DRIVER_VERSION_NUMBER);
 
 #ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE;
@@ -1291,7 +1291,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	}
 	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
 			sizeof(cap->bus_info));
-	cap->version = DRIVER_VERSION_NUMBER;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
@@ -2478,10 +2477,7 @@ EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
 /* -- module insert / remove -- */
 static int __init gspca_init(void)
 {
-	info("v%d.%d.%d registered",
-		(DRIVER_VERSION_NUMBER >> 16) & 0xff,
-		(DRIVER_VERSION_NUMBER >> 8) & 0xff,
-		DRIVER_VERSION_NUMBER & 0xff);
+	info("v%s registered", DRIVER_VERSION_NUMBER);
 	return 0;
 }
 static void __exit gspca_exit(void)
-- 
1.7.1


