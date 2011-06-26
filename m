Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1FZQLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1FZQH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:58 -0400
Date: Sun, 26 Jun 2011 13:06:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/14] [media] radio: Use the subsystem version control for
 VIDIOC_QUERYCAP
Message-ID: <20110626130608.3ee556b3@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like the video drivers, the right thing to do is to use
the per-subsystem version control.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 3d8cc42..25e58cb 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -102,10 +102,7 @@
 /*
  * Version Information
  */
-#include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
-
-#define DRIVER_VERSION "v0.46"
-#define RADIO_VERSION KERNEL_VERSION(0, 4, 6)
+#define DRIVER_VERSION "0.4.7"
 
 #define DRIVER_AUTHOR "Markus Demleitner <msdemlei@tucana.harvard.edu>"
 #define DRIVER_DESC "D-Link DSB-R100 USB FM radio driver"
@@ -335,7 +332,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "dsbr100", sizeof(v->driver));
 	strlcpy(v->card, "D-Link R-100 USB FM Radio", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
@@ -647,3 +643,4 @@ module_exit (dsbr100_exit);
 MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 4ce10db..1c3f844 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -33,7 +33,6 @@
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
-#include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -41,6 +40,7 @@
 MODULE_AUTHOR("M.Kirkwood");
 MODULE_DESCRIPTION("A driver for the RadioTrack/RadioReveal radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_RTRACK_PORT
 #define CONFIG_RADIO_RTRACK_PORT -1
@@ -53,8 +53,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the RadioTrack card (0x20f or 0x30f)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct rtrack
 {
 	struct v4l2_device v4l2_dev;
@@ -223,7 +221,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-aimslab", sizeof(v->driver));
 	strlcpy(v->card, "RadioTrack", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index dd8a6ab..eed7b08 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -30,7 +30,6 @@
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -38,6 +37,7 @@
 MODULE_AUTHOR("Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the Aztech radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
@@ -53,8 +53,6 @@ module_param(io, int, 0);
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the Aztech card (0x350 or 0x358)");
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct aztech
 {
 	struct v4l2_device v4l2_dev;
@@ -188,7 +186,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-aztech", sizeof(v->driver));
 	strlcpy(v->card, "Aztech Radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index bc9ad08..16a089f 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -30,7 +30,6 @@
  *		Changed API to V4L2
  */
 
-#include <linux/version.h>
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
@@ -46,6 +45,7 @@
 MODULE_AUTHOR("Fred Gleason, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the ADS Cadet AM/FM/RDS radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.3.4");
 
 static int io = -1;		/* default to isapnp activation */
 static int radio_nr = -1;
@@ -54,8 +54,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of Cadet card (0x330,0x332,0x334,0x336,0x338,0x33a,0x33c,0x33e)");
 module_param(radio_nr, int, 0);
 
-#define CADET_VERSION KERNEL_VERSION(0, 3, 3)
-
 #define RDS_BUFFER 256
 #define RDS_RX_FLAG 1
 #define MBS_RX_FLAG 2
@@ -361,7 +359,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "ADS Cadet", sizeof(v->driver));
 	strlcpy(v->card, "ADS Cadet", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = CADET_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
 			  V4L2_CAP_READWRITE | V4L2_CAP_RDS_CAPTURE;
 	return 0;
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 2599364..edadc84 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -21,21 +21,19 @@
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
-#include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 3)
-
 /*
  * Module info.
  */
 
-MODULE_AUTHOR("Jonas Munsin, Pekka Sepp‰nen <pexu@kapsi.fi>");
+MODULE_AUTHOR("Jonas Munsin, Pekka Sepp√§nen <pexu@kapsi.fi>");
 MODULE_DESCRIPTION("A driver for the GemTek Radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.4");
 
 /*
  * Module params.
@@ -387,7 +385,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "radio-gemtek", sizeof(v->driver));
 	strlcpy(v->card, "GemTek", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index e83e840..f872a54 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -40,15 +40,18 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
+#define DRIVER_VERSION	"0.7.8"
+
+
 MODULE_AUTHOR("Dimitromanolakis Apostolos, apdim@grecian.net");
 MODULE_DESCRIPTION("Radio driver for the Guillemot Maxi Radio FM2000 radio.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
 
 static int radio_nr = -1;
 module_param(radio_nr, int, 0);
@@ -58,10 +61,6 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
 
-#define DRIVER_VERSION	"0.77"
-
-#define RADIO_VERSION KERNEL_VERSION(0, 7, 7)
-
 #define dprintk(dev, num, fmt, arg...) \
 	v4l2_dbg(num, debug, &dev->v4l2_dev, fmt, ## arg)
 
@@ -195,7 +194,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-maxiradio", sizeof(v->driver));
 	strlcpy(v->card, "Maxi Radio FM2000 radio", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "PCI:%s", pci_name(dev->pdev));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index b3a635b..1742bd8 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -63,18 +63,17 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
-#include <linux/version.h>	/* for KERNEL_VERSION MACRO */
 #include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
 #define DRIVER_DESC "AverMedia MR 800 USB FM radio driver"
-#define DRIVER_VERSION "0.11"
-#define RADIO_VERSION KERNEL_VERSION(0, 1, 1)
+#define DRIVER_VERSION "0.1.2"
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
 
 #define USB_AMRADIO_VENDOR 0x07ca
 #define USB_AMRADIO_PRODUCT 0xb800
@@ -301,7 +300,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
 	strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index 8d6ea59..3628be6 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -15,7 +15,6 @@
 #include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -23,6 +22,7 @@
 MODULE_AUTHOR("Ben Pfaff");
 MODULE_DESCRIPTION("A driver for the RadioTrack II radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_RTRACK2_PORT
 #define CONFIG_RADIO_RTRACK2_PORT -1
@@ -35,8 +35,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the RadioTrack card (0x20c or 0x30c)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct rtrack2
 {
 	struct v4l2_device v4l2_dev;
@@ -121,7 +119,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "radio-rtrack2", sizeof(v->driver));
 	strlcpy(v->card, "RadioTrack II", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index b5a5f89..22c5743 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -16,7 +16,6 @@
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>	/* __setup			*/
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
@@ -32,6 +31,7 @@
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
 MODULE_DESCRIPTION("A driver for the SF16-FMI and SF16-FMP radio.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 static int io = -1;
 static int radio_nr = -1;
@@ -40,8 +40,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the SF16-FMI or SF16-FMP card (0x284 or 0x384)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct fmi
 {
 	struct v4l2_device v4l2_dev;
@@ -134,7 +132,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-sf16fmi", sizeof(v->driver));
 	strlcpy(v->card, "SF16-FMx radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 0e71d81..ce75c3a 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -39,10 +39,8 @@
 #include <linux/i2c.h>			/* I2C				*/
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <linux/version.h>      	/* for KERNEL_VERSION MACRO     */
 
-#define DRIVER_VERSION	"v0.01"
-#define RADIO_VERSION	KERNEL_VERSION(0, 0, 1)
+#define DRIVER_VERSION	"0.0.2"
 
 #define DRIVER_AUTHOR	"Fabio Belavenuto <belavenuto@gmail.com>"
 #define DRIVER_DESC	"A driver for the TEA5764 radio chip for EZX Phones."
@@ -300,7 +298,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->card, dev->name, sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info),
 		 "I2C:%s", dev_name(&dev->dev));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
@@ -595,6 +592,7 @@ static void __exit tea5764_exit(void)
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
 
 module_param(use_xtal, int, 1);
 MODULE_PARM_DESC(use_xtal, "Chip have a xtal connected in board");
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index a326639..f2ed9cc 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -29,7 +29,6 @@
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -37,6 +36,7 @@
 MODULE_AUTHOR("R.OFFERMANNS & others");
 MODULE_DESCRIPTION("A driver for the TerraTec ActiveRadio Standalone radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_TERRATEC_PORT
 #define CONFIG_RADIO_TERRATEC_PORT 0x590
@@ -49,8 +49,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the TerraTec ActiveRadio card (0x590 or 0x591)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 static struct v4l2_queryctrl radio_qctrl[] = {
 	{
 		.id            = V4L2_CID_AUDIO_MUTE,
@@ -205,7 +203,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "radio-terratec", sizeof(v->driver));
 	strlcpy(v->card, "ActiveRadio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index a185610..f17b540 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -16,7 +16,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #include <linux/io.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
@@ -44,7 +43,6 @@ static int timbradio_vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
 	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
-	v->version = KERNEL_VERSION(0, 0, 1);
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
@@ -245,4 +243,5 @@ module_exit(timbradio_exit);
 MODULE_DESCRIPTION("Timberdale Radio driver");
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
 MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.0.2");
 MODULE_ALIAS("platform:"DRIVER_NAME);
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 22fa9cc..b3f45a0 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <media/v4l2-device.h>
@@ -28,6 +27,7 @@
 MODULE_AUTHOR("Eric Lammerts, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the Trust FM Radio card.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
@@ -42,8 +42,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the Trust FM Radio card (0x350 or 0x358)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct trust {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
@@ -196,7 +194,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "radio-trust", sizeof(v->driver));
 	strlcpy(v->card, "Trust FM Radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index 8dbbf08..398726a 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -31,15 +31,17 @@
 #include <linux/module.h>	/* Modules                        */
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
+#define DRIVER_VERSION "0.1.2"
+
 MODULE_AUTHOR("Dr. Henrik Seidel");
 MODULE_DESCRIPTION("A driver for the Typhoon radio card (a.k.a. EcoRadio).");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
 
 #ifndef CONFIG_RADIO_TYPHOON_PORT
 #define CONFIG_RADIO_TYPHOON_PORT -1
@@ -61,9 +63,7 @@ static unsigned long mutefreq = CONFIG_RADIO_TYPHOON_MUTEFREQ;
 module_param(mutefreq, ulong, 0);
 MODULE_PARM_DESC(mutefreq, "Frequency used when muting the card (in kHz)");
 
-#define RADIO_VERSION KERNEL_VERSION(0, 1, 1)
-
-#define BANNER "Typhoon Radio Card driver v0.1.1\n"
+#define BANNER "Typhoon Radio Card driver v" DRIVER_VERSION "\n"
 
 struct typhoon {
 	struct v4l2_device v4l2_dev;
@@ -171,7 +171,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-typhoon", sizeof(v->driver));
 	strlcpy(v->card, "Typhoon Radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index af99c5b..f5613b9 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -35,7 +35,6 @@
 #include <linux/delay.h>	/* udelay, msleep                 */
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/mutex.h>
-#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -43,6 +42,7 @@
 MODULE_AUTHOR("C.van Schaik");
 MODULE_DESCRIPTION("A driver for the Zoltrix Radio Plus.");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_ZOLTRIX_PORT
 #define CONFIG_RADIO_ZOLTRIX_PORT -1
@@ -55,8 +55,6 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, "I/O address of the Zoltrix Radio Plus (0x20c or 0x30c)");
 module_param(radio_nr, int, 0);
 
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-
 struct zoltrix {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
@@ -228,7 +226,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, "radio-zoltrix", sizeof(v->driver));
 	strlcpy(v->card, "Zoltrix Radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index a2a6777..fd3541b 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -24,10 +24,9 @@
 
 /* driver definitions */
 #define DRIVER_AUTHOR "Joonyoung Shim <jy0922.shim@samsung.com>";
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 1)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "I2C radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.1"
+#define DRIVER_VERSION "1.0.2"
 
 /* kernel includes */
 #include <linux/i2c.h>
@@ -248,7 +247,6 @@ int si470x_vidioc_querycap(struct file *file, void *priv,
 {
 	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
-	capability->version = DRIVER_KERNEL_VERSION;
 	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index ccefdae..4cf5370 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -29,7 +29,6 @@
 
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 10)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
 #define DRIVER_VERSION "1.0.10"
@@ -626,7 +625,6 @@ int si470x_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	usb_make_path(radio->usbdev, capability->bus_info,
 			sizeof(capability->bus_info));
-	capability->version = DRIVER_KERNEL_VERSION;
 	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 68da001..f300a55 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -32,7 +32,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 1a45a5d..d84ad9d 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -28,14 +28,11 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 
-#define FM_DRV_VERSION            "0.10"
-/* Should match with FM_DRV_VERSION */
-#define FM_DRV_RADIO_VERSION      KERNEL_VERSION(0, 0, 1)
+#define FM_DRV_VERSION            "0.1.1"
 #define FM_DRV_NAME               "ti_fmdrv"
 #define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
 #define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 8701072..a4f05e0 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -175,7 +175,6 @@ static int fm_v4l2_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(capability->card, FM_DRV_CARD_SHORT_NAME,
 			sizeof(capability->card));
 	sprintf(capability->bus_info, "UART");
-	capability->version = FM_DRV_RADIO_VERSION;
 	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
 		V4L2_CAP_RADIO | V4L2_CAP_MODULATOR |
 		V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
-- 
1.7.1


