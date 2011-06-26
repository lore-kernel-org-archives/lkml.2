Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1FZQK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab1FZQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:52 -0400
Date: Sun, 26 Jun 2011 13:06:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/14] [media] Stop using linux/version.h on most video
 drivers
Message-ID: <20110626130606.34be41c1@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the modified drivers didn't have any version increment since
Jan, 1 2011. Several of them didn't have any version increment
for a long time, even having new features and important bug fixes
happening.

As we're now filling the QUERYCAP version with the current Kernel
Release, we don't need to maintain a per-driver version control
anymore. So, let's just use the default.

In order to preserve the Kernel module version history, a
KERNEL_VERSION() macro were added to all modified drivers, and
the extraver number were incremented.

I opted to preserve the per-driver version control to a few
drivers: cx18, davinci, fsl-viu, gspca, ivtv, m5mols, soc_camera,
pwc, pvrusb2, s2255, s5p-fimc and sh_vou.

A few drivers are still using the legacy way to handle ioctl's.
So, we can't do such change on them, otherwise, they'll break.
Those are: uvc, et61x251 and sn9c102.

The rationale is that the per-driver version control seems to be
actively maintained on those.

Yet, I think that the better for them would be to just use the
default version numbering, instead of doing that by themselves.

While here, removed a few uneeded include linux/version.h

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index f989f28..b6ed44a 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
@@ -54,7 +53,7 @@
  */
 #define USE_INT		0	/* Don't modify */
 
-#define VERSION	"0.04"
+#define VERSION	"0.0.5"
 
 #define ar_inl(addr) 		inl((unsigned long)(addr))
 #define ar_outl(val, addr)	outl((unsigned long)(val), (unsigned long)(addr))
@@ -404,7 +403,6 @@ static int ar_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, ar->vdev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "Colour AR VGA", sizeof(vcap->card));
 	strlcpy(vcap->bus_info, "Platform", sizeof(vcap->bus_info));
-	vcap->version = KERNEL_VERSION(0, 0, 4);
 	vcap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	return 0;
 }
@@ -879,3 +877,4 @@ module_exit(ar_cleanup_module);
 MODULE_AUTHOR("Takeo Takahashi <takahashi.takeo@renesas.com>");
 MODULE_DESCRIPTION("Colour AR M64278(VGA) for Video4Linux");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(VERSION);
diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index ca342e4..1e4ce50 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -292,3 +292,4 @@ module_exit(au0828_exit);
 MODULE_DESCRIPTION("Driver for Auvitek AU0828 based products");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.2");
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index c03eb29..0b3e481 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
@@ -43,8 +42,6 @@
 
 static DEFINE_MUTEX(au0828_sysfs_lock);
 
-#define AU0828_VERSION_CODE KERNEL_VERSION(0, 0, 1)
-
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
@@ -1254,8 +1251,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, dev->board.name, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
 
-	cap->version = AU0828_VERSION_CODE;
-
 	/*set the device capabilities */
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VBI_CAPTURE |
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a97cf27..696e978 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -57,6 +57,7 @@
 
 #include <media/saa6588.h>
 
+#define BTTV_VERSION "0.9.19"
 
 unsigned int bttv_num;			/* number of Bt848s in use */
 struct bttv *bttvs[BTTV_MAX];
@@ -163,6 +164,7 @@ MODULE_PARM_DESC(radio_nr, "radio device numbers");
 MODULE_DESCRIPTION("bttv - v4l/v4l2 driver module for bt848/878 based cards");
 MODULE_AUTHOR("Ralph Metzler & Marcus Metzler & Gerd Knorr");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(BTTV_VERSION);
 
 /* ----------------------------------------------------------------------- */
 /* sysfs                                                                   */
@@ -2616,7 +2618,6 @@ static int bttv_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, btv->video_dev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(btv->c.pci));
-	cap->version = BTTV_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VBI_CAPTURE |
@@ -3416,7 +3417,6 @@ static int radio_querycap(struct file *file, void *priv,
 	strcpy(cap->driver, "bttv");
 	strlcpy(cap->card, btv->radio_dev->name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(btv->c.pci));
-	cap->version = BTTV_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
 
 	return 0;
@@ -4585,14 +4585,8 @@ static int __init bttv_init_module(void)
 
 	bttv_num = 0;
 
-	printk(KERN_INFO "bttv: driver version %d.%d.%d loaded\n",
-	       (BTTV_VERSION_CODE >> 16) & 0xff,
-	       (BTTV_VERSION_CODE >> 8) & 0xff,
-	       BTTV_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "bttv: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "bttv: driver version %s loaded\n",
+	       BTTV_VERSION);
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
 	if (gbufsize > BTTV_MAX_FBUF)
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 9b776fa..318edf2 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -25,9 +25,6 @@
 #ifndef _BTTVP_H_
 #define _BTTVP_H_
 
-#include <linux/version.h>
-#define BTTV_VERSION_CODE KERNEL_VERSION(0,9,18)
-
 #include <linux/types.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index c119350..2fc998e 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -71,7 +71,6 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/mm.h>
 #include <linux/parport.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -647,7 +646,6 @@ static int qcam_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "B&W Quickcam", sizeof(vcap->card));
 	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
-	vcap->version = KERNEL_VERSION(0, 0, 2);
 	vcap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	return 0;
 }
@@ -1092,3 +1090,4 @@ module_init(init_bw_qcams);
 module_exit(exit_bw_qcams);
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index 24fc009..b8d800e 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <asm/uaccess.h>
 #include <media/v4l2-device.h>
@@ -517,7 +516,6 @@ static int qcam_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "Color Quickcam", sizeof(vcap->card));
 	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
-	vcap->version = KERNEL_VERSION(0, 0, 3);
 	vcap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	return 0;
 }
@@ -886,6 +884,7 @@ static void __exit cqcam_cleanup(void)
 MODULE_AUTHOR("Philip Blundell <philb@gnu.org>");
 MODULE_DESCRIPTION(BANNER);
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.4");
 
 module_init(cqcam_init);
 module_exit(cqcam_cleanup);
diff --git a/drivers/media/video/cpia2/cpia2.h b/drivers/media/video/cpia2/cpia2.h
index 6d6d184..ab25218 100644
--- a/drivers/media/video/cpia2/cpia2.h
+++ b/drivers/media/video/cpia2/cpia2.h
@@ -31,7 +31,6 @@
 #ifndef __CPIA2_H__
 #define __CPIA2_H__
 
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/usb.h>
@@ -43,10 +42,6 @@
 /* define for verbose debug output */
 //#define _CPIA2_DEBUG_
 
-#define CPIA2_MAJ_VER	3
-#define CPIA2_MIN_VER   0
-#define CPIA2_PATCH_VER	0
-
 /***
  * Image defines
  ***/
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 40eb632..077eb1d 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -29,8 +29,7 @@
  *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
-#include <linux/version.h>
-
+#define CPIA_VERSION "3.0.1"
 
 #include <linux/module.h>
 #include <linux/time.h>
@@ -80,6 +79,7 @@ MODULE_AUTHOR("Steve Miller (STMicroelectronics) <steve.miller@st.com>");
 MODULE_DESCRIPTION("V4L-driver for STMicroelectronics CPiA2 based cameras");
 MODULE_SUPPORTED_DEVICE("video");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CPIA_VERSION);
 
 #define ABOUT "V4L-Driver for Vision CPiA2 based cameras"
 
@@ -465,9 +465,6 @@ static int cpia2_querycap(struct file *file, void *fh, struct v4l2_capability *v
 	if (usb_make_path(cam->dev, vc->bus_info, sizeof(vc->bus_info)) <0)
 		memset(vc->bus_info,0, sizeof(vc->bus_info));
 
-	vc->version = KERNEL_VERSION(CPIA2_MAJ_VER, CPIA2_MIN_VER,
-				     CPIA2_PATCH_VER);
-
 	vc->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 			   V4L2_CAP_READWRITE |
 			   V4L2_CAP_STREAMING;
@@ -1558,8 +1555,8 @@ static void __init check_parameters(void)
  *****************************************************************************/
 static int __init cpia2_init(void)
 {
-	LOG("%s v%d.%d.%d\n",
-	    ABOUT, CPIA2_MAJ_VER, CPIA2_MIN_VER, CPIA2_PATCH_VER);
+	LOG("%s v%s\n",
+	    ABOUT, CPIA_VERSION);
 	check_parameters();
 	cpia2_usb_init();
 	return 0;
@@ -1579,4 +1576,3 @@ static void __exit cpia2_exit(void)
 
 module_init(cpia2_init);
 module_exit(cpia2_exit);
-
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index a69c24d..21fa547 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -29,7 +29,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -45,7 +44,7 @@
 #include "cx231xx.h"
 #include "cx231xx-vbi.h"
 
-#define CX231XX_VERSION_CODE            KERNEL_VERSION(0, 0, 1)
+#define CX231XX_VERSION "0.0.2"
 
 #define DRIVER_AUTHOR   "Srinivasa Deevi <srinivasa.deevi@conexant.com>"
 #define DRIVER_DESC     "Conexant cx231xx based USB video device driver"
@@ -70,6 +69,7 @@ do {\
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX231XX_VERSION);
 
 static unsigned int card[]     = {[0 ... (CX231XX_MAXBOARDS - 1)] = UNSET };
 static unsigned int video_nr[] = {[0 ... (CX231XX_MAXBOARDS - 1)] = UNSET };
@@ -1869,8 +1869,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->version = CX231XX_VERSION_CODE;
-
 	cap->capabilities = V4L2_CAP_VBI_CAPTURE |
 #if 0
 		V4L2_CAP_SLICED_VBI_CAPTURE |
@@ -2057,7 +2055,6 @@ static int radio_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->version = CX231XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
@@ -2570,11 +2567,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 {
 	int ret;
 
-	cx231xx_info("%s: v4l2 driver version %d.%d.%d\n",
-		     dev->name,
-		     (CX231XX_VERSION_CODE >> 16) & 0xff,
-		     (CX231XX_VERSION_CODE >> 8) & 0xff,
-		     CX231XX_VERSION_CODE & 0xff);
+	cx231xx_info("%s: v4l2 driver version %s\n",
+		     dev->name, CX231XX_VERSION);
 
 	/* set default norm */
 	/*dev->norm = cx231xx_video_template.current_norm; */
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index b39b85e..c8d0d3d 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -114,7 +114,6 @@
 	V4L2_STD_PAL_BG |  V4L2_STD_PAL_DK    |  V4L2_STD_PAL_I    | \
 	V4L2_STD_PAL_M  |  V4L2_STD_PAL_N     |  V4L2_STD_PAL_Nc   | \
 	V4L2_STD_PAL_60 |  V4L2_STD_SECAM_L   |  V4L2_STD_SECAM_DK)
-#define CX231xx_VERSION_CODE KERNEL_VERSION(0, 0, 2)
 
 #define SLEEP_S5H1432    30
 #define CX23417_OSC_EN   8
diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/video/cx23885/altera-ci.c
index 678539b..1fa8927 100644
--- a/drivers/media/video/cx23885/altera-ci.c
+++ b/drivers/media/video/cx23885/altera-ci.c
@@ -52,7 +52,6 @@
  * |  DATA7|  DATA6|  DATA5|  DATA4|  DATA3|  DATA2|  DATA1|  DATA0|
  * +-------+-------+-------+-------+-------+-------+-------+-------+
  */
-#include <linux/version.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
 #include "altera-ci.h"
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 9a98dc5..67c4a59 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1359,7 +1359,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[tsport->dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = CX23885_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE     |
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 64d9b21..0b44255 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -42,6 +42,7 @@
 MODULE_DESCRIPTION("Driver for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX23885_VERSION);
 
 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -2152,14 +2153,8 @@ static struct pci_driver cx23885_pci_driver = {
 
 static int __init cx23885_init(void)
 {
-	printk(KERN_INFO "cx23885 driver version %d.%d.%d loaded\n",
-	       (CX23885_VERSION_CODE >> 16) & 0xff,
-	       (CX23885_VERSION_CODE >>  8) & 0xff,
-	       CX23885_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx23885: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx23885 driver version %s loaded\n",
+		CX23885_VERSION);
 	return pci_register_driver(&cx23885_pci_driver);
 }
 
@@ -2170,5 +2165,3 @@ static void __exit cx23885_fini(void)
 
 module_init(cx23885_init);
 module_exit(cx23885_fini);
-
-/* ----------------------------------------------------------- */
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index ee57f6b..896bb32 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1000,7 +1000,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->version = CX23885_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE     |
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index c186473..01c3b7b 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -36,10 +36,9 @@
 #include "cx23885-reg.h"
 #include "media/cx2341x.h"
 
-#include <linux/version.h>
 #include <linux/mutex.h>
 
-#define CX23885_VERSION_CODE KERNEL_VERSION(0, 0, 2)
+#define CX23885_VERSION "0.0.3"
 
 #define UNSET (-1U)
 
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 423c1af..68d1240 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -113,6 +113,8 @@ MODULE_DESCRIPTION("ALSA driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Ricardo Cerqueira");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX88_VERSION);
+
 MODULE_SUPPORTED_DEVICE("{{Conexant,23881},"
 			"{{Conexant,23882},"
 			"{{Conexant,23883}");
@@ -973,14 +975,8 @@ static struct pci_driver cx88_audio_pci_driver = {
  */
 static int __init cx88_audio_init(void)
 {
-	printk(KERN_INFO "cx2388x alsa driver version %d.%d.%d loaded\n",
-	       (CX88_VERSION_CODE >> 16) & 0xff,
-	       (CX88_VERSION_CODE >>  8) & 0xff,
-	       CX88_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx2388x: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx2388x alsa driver version %s loaded\n",
+	       CX88_VERSION);
 	return pci_register_driver(&cx88_audio_pci_driver);
 }
 
@@ -994,10 +990,3 @@ static void __exit cx88_audio_fini(void)
 
 module_init(cx88_audio_init);
 module_exit(cx88_audio_fini);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 11e49bb..e46446a 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -42,6 +42,7 @@
 MODULE_DESCRIPTION("driver for cx2388x/cx23416 based mpeg encoder cards");
 MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX88_VERSION);
 
 static unsigned int mpegbufs = 32;
 module_param(mpegbufs,int,0644);
@@ -730,7 +731,6 @@ static int vidioc_querycap (struct file *file, void  *priv,
 	strcpy(cap->driver, "cx88_blackbird");
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
 	sprintf(cap->bus_info,"PCI:%s",pci_name(dev->pci));
-	cap->version = CX88_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE     |
@@ -1368,14 +1368,8 @@ static struct cx8802_driver cx8802_blackbird_driver = {
 
 static int __init blackbird_init(void)
 {
-	printk(KERN_INFO "cx2388x blackbird driver version %d.%d.%d loaded\n",
-	       (CX88_VERSION_CODE >> 16) & 0xff,
-	       (CX88_VERSION_CODE >>  8) & 0xff,
-	       CX88_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx2388x: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx2388x blackbird driver version %s loaded\n",
+	       CX88_VERSION);
 	return cx8802_register_driver(&cx8802_blackbird_driver);
 }
 
@@ -1389,11 +1383,3 @@ module_exit(blackbird_fini);
 
 module_param_named(video_debug,cx8802_mpeg_template.debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable debug messages [video]");
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 1ed72ce..cf3d33a 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -64,6 +64,7 @@ MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -1749,14 +1750,8 @@ static struct cx8802_driver cx8802_dvb_driver = {
 
 static int __init dvb_init(void)
 {
-	printk(KERN_INFO "cx88/2: cx2388x dvb driver version %d.%d.%d loaded\n",
-	       (CX88_VERSION_CODE >> 16) & 0xff,
-	       (CX88_VERSION_CODE >>  8) & 0xff,
-	       CX88_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx2388x: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx88/2: cx2388x dvb driver version %s loaded\n",
+	       CX88_VERSION);
 	return cx8802_register_driver(&cx8802_dvb_driver);
 }
 
@@ -1767,10 +1762,3 @@ static void __exit dvb_fini(void)
 
 module_init(dvb_init);
 module_exit(dvb_fini);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * compile-command: "make DVB=1"
- * End:
- */
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 1a7b983..ccd8797 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -39,6 +39,7 @@ MODULE_AUTHOR("Jelle Foks <jelle@foks.us>");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
 module_param(debug,int,0644);
@@ -890,14 +891,8 @@ static struct pci_driver cx8802_pci_driver = {
 
 static int __init cx8802_init(void)
 {
-	printk(KERN_INFO "cx88/2: cx2388x MPEG-TS Driver Manager version %d.%d.%d loaded\n",
-	       (CX88_VERSION_CODE >> 16) & 0xff,
-	       (CX88_VERSION_CODE >>  8) & 0xff,
-	       CX88_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx2388x: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx88/2: cx2388x MPEG-TS Driver Manager version %s loaded\n",
+	       CX88_VERSION);
 	return pci_register_driver(&cx8802_pci_driver);
 }
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index cef4f28..1db97f3 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -45,6 +45,7 @@
 MODULE_DESCRIPTION("v4l2 driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CX88_VERSION);
 
 /* ------------------------------------------------------------------ */
 
@@ -1161,7 +1162,6 @@ static int vidioc_querycap (struct file *file, void  *priv,
 	strcpy(cap->driver, "cx8800");
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
 	sprintf(cap->bus_info,"PCI:%s",pci_name(dev->pci));
-	cap->version = CX88_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE     |
@@ -1480,7 +1480,6 @@ static int radio_querycap (struct file *file, void  *priv,
 	strcpy(cap->driver, "cx8800");
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
 	sprintf(cap->bus_info,"PCI:%s", pci_name(dev->pci));
-	cap->version = CX88_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
@@ -2139,14 +2138,8 @@ static struct pci_driver cx8800_pci_driver = {
 
 static int __init cx8800_init(void)
 {
-	printk(KERN_INFO "cx88/0: cx2388x v4l2 driver version %d.%d.%d loaded\n",
-	       (CX88_VERSION_CODE >> 16) & 0xff,
-	       (CX88_VERSION_CODE >>  8) & 0xff,
-	       CX88_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "cx2388x: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "cx88/0: cx2388x v4l2 driver version %s loaded\n",
+	       CX88_VERSION);
 	return pci_register_driver(&cx8800_pci_driver);
 }
 
@@ -2157,11 +2150,3 @@ static void __exit cx8800_fini(void)
 
 module_init(cx8800_init);
 module_exit(cx8800_fini);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 5719063..425c9fb 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -39,9 +39,9 @@
 #include "cx88-reg.h"
 #include "tuner-xc2028.h"
 
-#include <linux/version.h>
 #include <linux/mutex.h>
-#define CX88_VERSION_CODE KERNEL_VERSION(0, 0, 8)
+
+#define CX88_VERSION "0.0.9"
 
 #define UNSET (-1U)
 
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 7b6461d..d176dc0 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -32,7 +32,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -50,7 +49,8 @@
 		      "Sascha Sommer <saschasommer@freenet.de>"
 
 #define DRIVER_DESC         "Empia em28xx based USB video device driver"
-#define EM28XX_VERSION_CODE  KERNEL_VERSION(0, 1, 2)
+
+#define EM28XX_VERSION "0.1.3"
 
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
@@ -72,6 +72,7 @@ do {\
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(EM28XX_VERSION);
 
 static unsigned int video_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
 static unsigned int vbi_nr[]   = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
@@ -1757,8 +1758,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->version = EM28XX_VERSION_CODE;
-
 	cap->capabilities =
 			V4L2_CAP_SLICED_VBI_CAPTURE |
 			V4L2_CAP_VIDEO_CAPTURE |
@@ -1976,7 +1975,6 @@ static int radio_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->version = EM28XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
@@ -2450,10 +2448,8 @@ int em28xx_register_analog_devices(struct em28xx *dev)
       u8 val;
 	int ret;
 
-	printk(KERN_INFO "%s: v4l2 driver version %d.%d.%d\n",
-		dev->name,
-		(EM28XX_VERSION_CODE >> 16) & 0xff,
-		(EM28XX_VERSION_CODE >> 8) & 0xff, EM28XX_VERSION_CODE & 0xff);
+	printk(KERN_INFO "%s: v4l2 driver version %s\n",
+		dev->name, EM28XX_VERSION);
 
 	/* set default norm */
 	dev->norm = em28xx_video_template.current_norm;
diff --git a/drivers/media/video/gspca/gl860/gl860.h b/drivers/media/video/gspca/gl860/gl860.h
index 49ad4ac..0330a02 100644
--- a/drivers/media/video/gspca/gl860/gl860.h
+++ b/drivers/media/video/gspca/gl860/gl860.h
@@ -18,7 +18,6 @@
  */
 #ifndef GL860_DEV_H
 #define GL860_DEV_H
-#include <linux/version.h>
 
 #include "gspca.h"
 
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index a27d93b..5442a17 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -474,5 +474,6 @@ module_init(hdpvr_init);
 module_exit(hdpvr_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.2.1");
 MODULE_AUTHOR("Janne Grunau");
 MODULE_DESCRIPTION("Hauppauge HD PVR driver");
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 514aea7..087f7c0 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -17,7 +17,6 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 
 #include <linux/videodev2.h>
@@ -574,7 +573,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, "hdpvr");
 	strcpy(cap->card, "Hauppauge HD PVR");
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->version = HDPVR_VERSION;
 	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_AUDIO         |
 				V4L2_CAP_READWRITE;
diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
index 072f23c..d6439db 100644
--- a/drivers/media/video/hdpvr/hdpvr.h
+++ b/drivers/media/video/hdpvr/hdpvr.h
@@ -18,12 +18,6 @@
 #include <media/v4l2-device.h>
 #include <media/ir-kbd-i2c.h>
 
-#define HDPVR_MAJOR_VERSION 0
-#define HDPVR_MINOR_VERSION 2
-#define HDPVR_RELEASE 0
-#define HDPVR_VERSION \
-	KERNEL_VERSION(HDPVR_MAJOR_VERSION, HDPVR_MINOR_VERSION, HDPVR_RELEASE)
-
 #define HDPVR_MAX 8
 #define HDPVR_I2C_MAX_SIZE 128
 
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index b03d74e..166bf93 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -35,7 +34,7 @@
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("0.1.1");
 
 #define MIN_W 32
 #define MIN_H 32
@@ -380,7 +379,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->version = KERNEL_VERSION(0, 1, 0);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
 			  | V4L2_CAP_STREAMING;
 
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 7551907..e753b5e 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -28,7 +28,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
@@ -39,7 +38,7 @@
 #include <media/v4l2-device.h>
 
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("0.0.4");
 
 #define MOTOROLA	1
 #define PHILIPS2	2               /* SAA7191 */
@@ -678,7 +677,6 @@ static int pms_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, dev->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "Mediavision PMS", sizeof(vcap->card));
 	strlcpy(vcap->bus_info, "ISA", sizeof(vcap->bus_info));
-	vcap->version = KERNEL_VERSION(0, 0, 3);
 	vcap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	return 0;
 }
diff --git a/drivers/media/video/pwc/pwc-ioctl.h b/drivers/media/video/pwc/pwc-ioctl.h
index 8c0cae7..b74fea0 100644
--- a/drivers/media/video/pwc/pwc-ioctl.h
+++ b/drivers/media/video/pwc/pwc-ioctl.h
@@ -52,7 +52,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/version.h>
 
  /* Enumeration of image sizes */
 #define PSZ_SQCIF	0x00
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index e947766..78185c6 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -29,7 +29,6 @@
 #include <linux/usb.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -47,9 +46,10 @@
 /* Version block */
 #define PWC_MAJOR	10
 #define PWC_MINOR	0
-#define PWC_EXTRAMINOR	12
-#define PWC_VERSION_CODE KERNEL_VERSION(PWC_MAJOR,PWC_MINOR,PWC_EXTRAMINOR)
-#define PWC_VERSION	"10.0.14"
+#define PWC_EXTRAMINOR	15
+
+#define PWC_VERSION_CODE KERNEL_VERSION(PWC_MAJOR, PWC_MINOR, PWC_EXTRAMINOR)
+#define PWC_VERSION __stringify(PWC_MAJOR) "." __stringify(PWC_MINOR) "." __stringify(PWC_EXTRAMINOR)
 #define PWC_NAME 	"pwc"
 #define PFX		PWC_NAME ": "
 
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index f9be737..ca65cda 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -39,6 +39,8 @@
 MODULE_DESCRIPTION("v4l2 driver module for saa7130/34 based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(SAA7134_VERSION);
+
 
 /* ------------------------------------------------------------------ */
 
@@ -1332,14 +1334,8 @@ static struct pci_driver saa7134_pci_driver = {
 static int __init saa7134_init(void)
 {
 	INIT_LIST_HEAD(&saa7134_devlist);
-	printk(KERN_INFO "saa7130/34: v4l2 driver version %d.%d.%d loaded\n",
-	       (SAA7134_VERSION_CODE >> 16) & 0xff,
-	       (SAA7134_VERSION_CODE >>  8) & 0xff,
-	       SAA7134_VERSION_CODE & 0xff);
-#ifdef SNAPSHOT
-	printk(KERN_INFO "saa7130/34: snapshot date %04d-%02d-%02d\n",
-	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
-#endif
+	printk(KERN_INFO "saa7130/34: v4l2 driver version %s loaded\n",
+	       SAA7134_VERSION);
 	return pci_register_driver(&saa7134_pci_driver);
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 18294db..dde361a 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -172,7 +172,6 @@ static int empress_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = SAA7134_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 776ba2d..9cf7914 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1810,7 +1810,6 @@ static int saa7134_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = SAA7134_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VBI_CAPTURE |
@@ -2307,7 +2306,6 @@ static int radio_querycap(struct file *file, void *priv,
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = SAA7134_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
 	return 0;
 }
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 28eb103..bc8d6bb 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -19,8 +19,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
-#define SAA7134_VERSION_CODE KERNEL_VERSION(0, 2, 16)
+#define SAA7134_VERSION "0, 2, 17"
 
 #include <linux/pci.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 16745d2..6678bf1 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -48,7 +48,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/kdev_t.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/crc32.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index fc611eb..84cd1b6 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -20,7 +20,6 @@
  * Timberdale FPGA LogiWin Video In
  */
 
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
index 46066bd..56564e6 100644
--- a/drivers/media/video/tlg2300/pd-common.h
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -1,7 +1,6 @@
 #ifndef PD_COMMON_H
 #define PD_COMMON_H
 
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/wait.h>
 #include <linux/list.h>
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 99c81a9..129f135 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -531,3 +531,4 @@ module_exit(poseidon_exit);
 MODULE_AUTHOR("Telegent Systems");
 MODULE_DESCRIPTION("For tlg2300-based USB device ");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.2");
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
index fae84c2..4fad1df 100644
--- a/drivers/media/video/tlg2300/pd-radio.c
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -6,7 +6,6 @@
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <media/v4l2-dev.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <media/v4l2-ioctl.h>
@@ -149,7 +148,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
 	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
 	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
-	v->version = KERNEL_VERSION(0, 0, 1);
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index ea8ea8a..5a74f5e 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -45,7 +45,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/timer.h>
@@ -77,15 +76,7 @@
 #define DRIVER_ALIAS "USBVision"
 #define DRIVER_DESC "USBVision USB Video Device Driver for Linux"
 #define DRIVER_LICENSE "GPL"
-#define USBVISION_DRIVER_VERSION_MAJOR 0
-#define USBVISION_DRIVER_VERSION_MINOR 9
-#define USBVISION_DRIVER_VERSION_PATCHLEVEL 10
-#define USBVISION_DRIVER_VERSION KERNEL_VERSION(USBVISION_DRIVER_VERSION_MAJOR,\
-USBVISION_DRIVER_VERSION_MINOR,\
-USBVISION_DRIVER_VERSION_PATCHLEVEL)
-#define USBVISION_VERSION_STRING __stringify(USBVISION_DRIVER_VERSION_MAJOR) \
-"." __stringify(USBVISION_DRIVER_VERSION_MINOR) \
-"." __stringify(USBVISION_DRIVER_VERSION_PATCHLEVEL)
+#define USBVISION_VERSION_STRING "0.9.11"
 
 #define	ENABLE_HEXDUMP	0	/* Enable if you need it */
 
@@ -516,7 +507,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		usbvision_device_data[usbvision->dev_model].model_string,
 		sizeof(vc->card));
 	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
-	vc->version = USBVISION_DRIVER_VERSION;
 	vc->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index d63e9d9..52a0a37 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/time.h>
-#include <linux/version.h>
 #include <linux/kmod.h>
 
 #include <linux/i2c.h>
@@ -61,8 +60,7 @@
 // #define VINO_DEBUG
 // #define VINO_DEBUG_INT
 
-#define VINO_MODULE_VERSION "0.0.6"
-#define VINO_VERSION_CODE KERNEL_VERSION(0, 0, 6)
+#define VINO_MODULE_VERSION "0.0.7"
 
 MODULE_DESCRIPTION("SGI VINO Video4Linux2 driver");
 MODULE_VERSION(VINO_MODULE_VERSION);
@@ -2934,7 +2932,6 @@ static int vino_querycap(struct file *file, void *__fh,
 	strcpy(cap->driver, vino_driver_name);
 	strcpy(cap->card, vino_driver_description);
 	strcpy(cap->bus_info, vino_bus_name);
-	cap->version = VINO_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING;
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..3b9db8c 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/font.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/kthread.h>
@@ -44,15 +43,12 @@
 #define MAX_WIDTH 1920
 #define MAX_HEIGHT 1200
 
-#define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 8
-#define VIVI_RELEASE 0
-#define VIVI_VERSION \
-	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
+#define VIVI_VERSION "0.8.1"
 
 MODULE_DESCRIPTION("Video Technology Magazine Virtual Video Capture Board");
 MODULE_AUTHOR("Mauro Carvalho Chehab, Ted Walther and John Sokol");
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(VIVI_VERSION);
 
 static unsigned video_nr = -1;
 module_param(video_nr, uint, 0644);
@@ -812,7 +808,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, "vivi");
 	strcpy(cap->card, "vivi");
 	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
-	cap->version = VIVI_VERSION;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING | \
 			    V4L2_CAP_READWRITE;
 	return 0;
@@ -1325,9 +1320,8 @@ static int __init vivi_init(void)
 	}
 
 	printk(KERN_INFO "Video Technology Magazine Virtual Video "
-			"Capture Board ver %u.%u.%u successfully loaded.\n",
-			(VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF,
-			VIVI_VERSION & 0xFF);
+			"Capture Board ver %s successfully loaded.\n",
+			VIVI_VERSION);
 
 	/* n_devs will reflect the actual number of allocated devices */
 	n_devs = i;
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index fa35639..453dbbd 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -57,7 +57,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
@@ -127,7 +126,7 @@ struct w9966 {
 MODULE_AUTHOR("Jakob Kemi <jakob.kemi@post.utfors.se>");
 MODULE_DESCRIPTION("Winbond w9966cf WebCam driver (0.32)");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("0.33.1");
 
 #ifdef MODULE
 static const char *pardev[] = {[0 ... W9966_MAXCAMS] = ""};
@@ -568,7 +567,6 @@ static int cam_querycap(struct file *file, void  *priv,
 	strlcpy(vcap->driver, cam->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, W9966_DRIVERNAME, sizeof(vcap->card));
 	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
-	vcap->version = KERNEL_VERSION(0, 33, 0);
 	vcap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	return 0;
 }
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index f3f6400..d7166af 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -41,10 +41,6 @@ struct zoran_sync {
 };
 
 
-#define MAJOR_VERSION 0		/* driver major version */
-#define MINOR_VERSION 10	/* driver minor version */
-#define RELEASE_VERSION 0	/* release version */
-
 #define ZORAN_NAME    "ZORAN"	/* name of the device */
 
 #define ZR_DEVNAME(zr) ((zr)->name)
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index 79b04ac..c3602d6 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -123,9 +123,12 @@ int zr36067_debug = 1;
 module_param_named(debug, zr36067_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-5)");
 
+#define ZORAN_VERSION "0.10.1"
+
 MODULE_DESCRIPTION("Zoran-36057/36067 JPEG codec driver");
 MODULE_AUTHOR("Serguei Miridonov");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(ZORAN_VERSION);
 
 #define ZR_DEVICE(subven, subdev, data)	{ \
 	.vendor = PCI_VENDOR_ID_ZORAN, .device = PCI_DEVICE_ID_ZORAN_36057, \
@@ -1459,8 +1462,8 @@ static int __init zoran_init(void)
 {
 	int res;
 
-	printk(KERN_INFO "Zoran MJPEG board driver version %d.%d.%d\n",
-	       MAJOR_VERSION, MINOR_VERSION, RELEASE_VERSION);
+	printk(KERN_INFO "Zoran MJPEG board driver version %s\n",
+	       ZORAN_VERSION);
 
 	/* check the parameters we have been given, adjust if necessary */
 	if (v4l_nbufs < 2)
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 2771d81..d4d05d2 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -44,7 +44,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -1538,8 +1537,6 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	strncpy(cap->driver, "zoran", sizeof(cap->driver)-1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(zr->pci_dev));
-	cap->version = KERNEL_VERSION(MAJOR_VERSION, MINOR_VERSION,
-			   RELEASE_VERSION);
 	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OVERLAY;
 	return 0;
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 7dfb01e..c492846 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -29,7 +29,6 @@
 
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
@@ -42,8 +41,7 @@
 
 
 /* Version Information */
-#define DRIVER_VERSION "v0.73"
-#define ZR364XX_VERSION_CODE KERNEL_VERSION(0, 7, 3)
+#define DRIVER_VERSION "0.7.4"
 #define DRIVER_AUTHOR "Antoine Jacquet, http://royale.zerezo.com/"
 #define DRIVER_DESC "Zoran 364xx"
 
@@ -744,7 +742,6 @@ static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
-	cap->version = ZR364XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_READWRITE |
 			    V4L2_CAP_STREAMING;
@@ -1721,3 +1718,4 @@ module_exit(zr364xx_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
-- 
1.7.1


