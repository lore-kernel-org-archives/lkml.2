Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab1F1Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:34:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700Ab1F1Qb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:31:58 -0400
Date: Mon, 27 Jun 2011 23:17:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 11/13] [media] Stop using linux/version.h the remaining
 video drivers
Message-ID: <20110627231727.6f2263fe@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize the remaining video drivers to return the API version
for the VIDIOC_QUERYCAP version, instead of a per-driver version.

Those drivers had the version updated more recently or are SoC
drivers. Even so, it doesn't sound a good idea to keep a per-driver
version control, so, let's use the per-subsystem version control
instead.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index d93ad74..49e4deb 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -44,6 +43,7 @@
 
 MODULE_DESCRIPTION("TI DaVinci VPIF Capture driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(VPIF_CAPTURE_VERSION);
 
 #define vpif_err(fmt, arg...)	v4l2_err(&vpif_obj.v4l2_dev, fmt, ## arg)
 #define vpif_dbg(level, debug, fmt, arg...)	\
@@ -1677,7 +1677,6 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 
-	cap->version = VPIF_CAPTURE_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "DM646x Platform", sizeof(cap->bus_info));
@@ -2211,10 +2210,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
 		vfd->release = video_device_release;
 		snprintf(vfd->name, sizeof(vfd->name),
-			 "DM646x_VPIFCapture_DRIVER_V%d.%d.%d",
-			 (VPIF_CAPTURE_VERSION_CODE >> 16) & 0xff,
-			 (VPIF_CAPTURE_VERSION_CODE >> 8) & 0xff,
-			 (VPIF_CAPTURE_VERSION_CODE) & 0xff);
+			 "DM646x_VPIFCapture_DRIVER_V%s",
+			 VPIF_CAPTURE_VERSION);
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 7a4196d..064550f 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -23,7 +23,6 @@
 
 /* Header files */
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
@@ -33,11 +32,7 @@
 #include "vpif.h"
 
 /* Macros */
-#define VPIF_MAJOR_RELEASE		0
-#define VPIF_MINOR_RELEASE		0
-#define VPIF_BUILD			1
-#define VPIF_CAPTURE_VERSION_CODE	((VPIF_MAJOR_RELEASE << 16) | \
-	(VPIF_MINOR_RELEASE << 8) | VPIF_BUILD)
+#define VPIF_CAPTURE_VERSION		"0.0.2"
 
 #define VPIF_VALID_FIELD(field)		(((V4L2_FIELD_ANY == field) || \
 	(V4L2_FIELD_NONE == field)) || \
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index cdf659a..286f029 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 
 #include <asm/irq.h>
@@ -47,6 +46,7 @@
 
 MODULE_DESCRIPTION("TI DaVinci VPIF Display driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(VPIF_DISPLAY_VERSION);
 
 #define DM646X_V4L2_STD (V4L2_STD_525_60 | V4L2_STD_625_50)
 
@@ -701,7 +701,6 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 
-	cap->version = VPIF_DISPLAY_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
@@ -1740,10 +1739,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
 		vfd->release = video_device_release;
 		snprintf(vfd->name, sizeof(vfd->name),
-			 "DM646x_VPIFDisplay_DRIVER_V%d.%d.%d",
-			 (VPIF_DISPLAY_VERSION_CODE >> 16) & 0xff,
-			 (VPIF_DISPLAY_VERSION_CODE >> 8) & 0xff,
-			 (VPIF_DISPLAY_VERSION_CODE) & 0xff);
+			 "DM646x_VPIFDisplay_DRIVER_V%s",
+			 VPIF_DISPLAY_VERSION);
 
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index b53aaa8..5d1936d 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -18,7 +18,6 @@
 
 /* Header files */
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
@@ -27,12 +26,7 @@
 #include "vpif.h"
 
 /* Macros */
-#define VPIF_MAJOR_RELEASE	(0)
-#define VPIF_MINOR_RELEASE	(0)
-#define VPIF_BUILD		(1)
-
-#define VPIF_DISPLAY_VERSION_CODE \
-	((VPIF_MAJOR_RELEASE << 16) | (VPIF_MINOR_RELEASE << 8) | VPIF_BUILD)
+#define VPIF_DISPLAY_VERSION	"0.0.2"
 
 #define VPIF_VALID_FIELD(field) \
 	(((V4L2_FIELD_ANY == field) || (V4L2_FIELD_NONE == field)) || \
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 908d701..27cb197 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -23,19 +23,13 @@
 #include <linux/io.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf-dma-contig.h>
 
 #define DRV_NAME		"fsl_viu"
-#define VIU_MAJOR_VERSION	0
-#define VIU_MINOR_VERSION	5
-#define VIU_RELEASE		0
-#define VIU_VERSION		KERNEL_VERSION(VIU_MAJOR_VERSION, \
-					       VIU_MINOR_VERSION, \
-					       VIU_RELEASE)
+#define VIU_VERSION		"0.5.1"
 
 #define BUFFER_TIMEOUT		msecs_to_jiffies(500)  /* 0.5 seconds */
 
@@ -610,7 +604,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strcpy(cap->driver, "viu");
 	strcpy(cap->card, "viu");
-	cap->version = VIU_VERSION;
 	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
 				V4L2_CAP_VIDEO_OVERLAY |
@@ -1684,3 +1677,4 @@ module_exit(viu_exit);
 MODULE_DESCRIPTION("Freescale Video-In(VIU)");
 MODULE_AUTHOR("Hongjun Chen");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(VIU_VERSION);
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index d71a390..bf704cb 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -18,11 +18,9 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 76eac26..05d086e 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index bc0c23a..0c4277a 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -31,7 +31,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
@@ -73,7 +72,7 @@
 #define CSISR_SOF_INT		(1 << 16)
 #define CSISR_DRDY		(1 << 0)
 
-#define VERSION_CODE KERNEL_VERSION(0, 0, 1)
+#define DRIVER_VERSION "0.0.2"
 #define DRIVER_NAME "mx1-camera"
 
 #define CSI_IRQ_MASK	(CSISR_SFF_OR_INT | CSISR_RFF_OR_INT | \
@@ -680,7 +679,6 @@ static int mx1_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the friendly caller:-> */
 	strlcpy(cap->card, "i.MX1/i.MXL Camera", sizeof(cap->card));
-	cap->version = VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -887,4 +885,5 @@ module_exit(mx1_camera_exit);
 MODULE_DESCRIPTION("i.MX1/i.MXL SoC Camera Host driver");
 MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
 MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 4eab1c6..e05e800 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -23,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
@@ -47,7 +46,7 @@
 #include <asm/dma.h>
 
 #define MX2_CAM_DRV_NAME "mx2-camera"
-#define MX2_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
+#define MX2_CAM_VERSION "0.0.6"
 #define MX2_CAM_DRIVER_DESCRIPTION "i.MX2x_Camera"
 
 /* reset values */
@@ -1014,7 +1013,6 @@ static int mx2_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the friendly caller:-> */
 	strlcpy(cap->card, MX2_CAM_DRIVER_DESCRIPTION, sizeof(cap->card));
-	cap->version = MX2_CAM_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -1523,3 +1521,4 @@ module_exit(mx2_camera_exit);
 MODULE_DESCRIPTION("i.MX27/i.MX25 SoC Camera Host driver");
 MODULE_AUTHOR("Sascha Hauer <sha@pengutronix.de>");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(MX2_CAM_VERSION);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c7680eb..36f0ed9 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -11,7 +11,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
@@ -1000,7 +999,6 @@ static int mx3_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the firendly caller:-> */
 	strlcpy(cap->card, "i.MX3x Camera", sizeof(cap->card));
-	cap->version = KERNEL_VERSION(0, 2, 2);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -1325,4 +1323,5 @@ module_exit(mx3_camera_exit);
 MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
 MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.2.3");
 MODULE_ALIAS("platform:" MX3_CAM_DRV_NAME);
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index e7cfc85..9bfe4c1 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 
 #include <media/omap1_camera.h>
 #include <media/soc_camera.h>
@@ -38,7 +37,7 @@
 
 
 #define DRIVER_NAME		"omap1-camera"
-#define VERSION_CODE		KERNEL_VERSION(0, 0, 1)
+#define DRIVER_VERSION		"0.0.2"
 
 
 /*
@@ -1431,7 +1430,6 @@ static int omap1_cam_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the friendly caller:-> */
 	strlcpy(cap->card, "OMAP1 Camera", sizeof(cap->card));
-	cap->version = VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -1718,4 +1716,5 @@ MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
 MODULE_DESCRIPTION("OMAP1 Camera Interface driver");
 MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
 MODULE_LICENSE("GPL v2");
+MODULE_LICENSE(DRIVER_VERSION);
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index f6626e8..ba3a8af 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -31,7 +31,6 @@
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
 #include <linux/pci.h>		/* needed for videobufs */
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -43,7 +42,7 @@
 
 #include "omap24xxcam.h"
 
-#define OMAP24XXCAM_VERSION KERNEL_VERSION(0, 0, 0)
+#define OMAP24XXCAM_VERSION "0.0.1"
 
 #define RESET_TIMEOUT_NS 10000
 
@@ -993,7 +992,6 @@ static int vidioc_querycap(struct file *file, void *fh,
 
 	strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, cam->vfd->name, sizeof(cap->card));
-	cap->version = OMAP24XXCAM_VERSION;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -1889,6 +1887,7 @@ static void __exit omap24xxcam_cleanup(void)
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
 MODULE_DESCRIPTION("OMAP24xx Video for Linux camera driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(OMAP24XXCAM_VERSION);
 module_param(video_nr, int, 0);
 MODULE_PARM_DESC(video_nr,
 		 "Minor number for video device (-1 ==> auto assign)");
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index c9fd04e..a7bbe68 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -2234,3 +2234,4 @@ module_exit(isp_cleanup);
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("TI OMAP3 ISP driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(ISP_VIDEO_DRIVER_VERSION);
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 9cd8f1a..fd965ad 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -695,7 +695,6 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	strlcpy(cap->driver, ISP_VIDEO_DRIVER_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, video->video.name, sizeof(cap->card));
 	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
-	cap->version = ISP_VIDEO_DRIVER_VERSION;
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 911bea6..53160aa 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -27,7 +27,6 @@
 #define OMAP3_ISP_VIDEO_H
 
 #include <linux/v4l2-mediabus.h>
-#include <linux/version.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
@@ -35,7 +34,7 @@
 #include "ispqueue.h"
 
 #define ISP_VIDEO_DRIVER_NAME		"ispvideo"
-#define ISP_VIDEO_DRIVER_VERSION	KERNEL_VERSION(0, 0, 1)
+#define ISP_VIDEO_DRIVER_VERSION	"0.0.2"
 
 struct isp_device;
 struct isp_video;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index b42bfa5..c5b27a4 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
@@ -40,7 +39,7 @@
 #include <mach/dma.h>
 #include <mach/camera.h>
 
-#define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
+#define PXA_CAM_VERSION "0.0.6"
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
 /* Camera Interface */
@@ -1578,7 +1577,6 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 {
 	/* cap->name is set by the firendly caller:-> */
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
-	cap->version = PXA_CAM_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	return 0;
@@ -1843,4 +1841,5 @@ module_exit(pxa_camera_exit);
 MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(PXA_CAM_VERSION);
 MODULE_ALIAS("platform:" PXA_CAM_DRV_NAME);
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 704e2cb..803c9c8 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -42,7 +42,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
@@ -51,12 +50,7 @@
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
 
-#define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	22
-#define S2255_RELEASE		0
-#define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
-					       S2255_MINOR_VERSION, \
-					       S2255_RELEASE)
+#define S2255_VERSION		"1.22.1"
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
 /* default JPEG quality */
@@ -851,7 +845,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->version = S2255_VERSION;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	return 0;
 }
@@ -1979,9 +1972,8 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 			  video_device_node_name(&channel->vdev));
 
 	}
-	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
-	       S2255_MAJOR_VERSION,
-	       S2255_MINOR_VERSION);
+	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %s\n",
+	       S2255_VERSION);
 	/* if no channels registered, return error and probe will fail*/
 	if (atomic_read(&dev->num_channels) == 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
@@ -2713,3 +2705,4 @@ module_exit(usb_s2255_exit);
 MODULE_DESCRIPTION("Sensoray 2255 Video for Linux driver");
 MODULE_AUTHOR("Dean Anderson (Sensoray Company Inc.)");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(S2255_VERSION);
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index d142b40..576b54e 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
@@ -467,7 +466,6 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(1, 0, 0);
 	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index dc91a85..31b8b31 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
@@ -786,7 +785,6 @@ static int fimc_m2m_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(1, 0, 0);
 	cap->capabilities = V4L2_CAP_STREAMING |
 		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
 		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
@@ -1949,3 +1947,4 @@ module_exit(fimc_exit);
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
 MODULE_DESCRIPTION("S5P FIMC camera host interface/video postprocessor driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.1");
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3ae5c9c..aa48e27 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -27,7 +27,6 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
@@ -1827,7 +1826,6 @@ static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
 				  struct v4l2_capability *cap)
 {
 	strlcpy(cap->card, "SuperH_Mobile_CEU", sizeof(cap->card));
-	cap->version = KERNEL_VERSION(0, 0, 5);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	return 0;
 }
@@ -2158,4 +2156,5 @@ module_exit(sh_mobile_ceu_exit);
 MODULE_DESCRIPTION("SuperH Mobile CEU driver");
 MODULE_AUTHOR("Magnus Damm");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.6");
 MODULE_ALIAS("platform:sh_mobile_ceu");
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 07cf0c6..6a72987 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -19,7 +19,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 
 #include <media/sh_vou.h>
@@ -393,7 +392,6 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
 
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
-	cap->version = KERNEL_VERSION(0, 1, 0);
 	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	return 0;
 }
@@ -1490,4 +1488,5 @@ module_exit(sh_vou_exit);
 MODULE_DESCRIPTION("SuperH VOU driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
 MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.1.0");
 MODULE_ALIAS("platform:sh-vou");
-- 
1.7.1


