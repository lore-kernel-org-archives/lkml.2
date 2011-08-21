Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1HUXBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:01:07 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:54645 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932075Ab1HUXBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:01:01 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] [media] gspca: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:57 -0700
Message-Id: <9927bff9b5f212dcbe867a9f882e53ed80bd9a0f.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert usb style logging macros to pr_<level>.
Remove now unused old usb style logging macros.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/benq.c                   |   18 ++++---
 drivers/media/video/gspca/conex.c                  |    6 ++-
 drivers/media/video/gspca/cpia1.c                  |    7 ++-
 drivers/media/video/gspca/etoms.c                  |    6 ++-
 drivers/media/video/gspca/gspca.c                  |   46 ++++++++++---------
 drivers/media/video/gspca/gspca.h                  |   22 +++------
 drivers/media/video/gspca/jeilinj.c                |   10 +++--
 drivers/media/video/gspca/kinect.c                 |   36 +++++++++-------
 drivers/media/video/gspca/konica.c                 |   16 ++++---
 drivers/media/video/gspca/mars.c                   |    6 ++-
 drivers/media/video/gspca/mr97310a.c               |   24 ++++++-----
 drivers/media/video/gspca/nw80x.c                  |    9 +++-
 drivers/media/video/gspca/ov519.c                  |   41 +++++++++---------
 drivers/media/video/gspca/ov534.c                  |   12 +++--
 drivers/media/video/gspca/ov534_9.c                |   12 +++--
 drivers/media/video/gspca/pac7302.c                |   15 +++---
 drivers/media/video/gspca/pac7311.c                |   15 +++---
 drivers/media/video/gspca/se401.c                  |   46 +++++++++++---------
 drivers/media/video/gspca/sn9c2028.c               |   14 +++---
 drivers/media/video/gspca/sonixj.c                 |   22 +++++----
 drivers/media/video/gspca/spca1528.c               |    8 ++-
 drivers/media/video/gspca/spca500.c                |    6 ++-
 drivers/media/video/gspca/spca501.c                |    4 +-
 drivers/media/video/gspca/spca505.c                |    8 ++-
 drivers/media/video/gspca/spca508.c                |    6 ++-
 drivers/media/video/gspca/spca561.c                |    4 +-
 drivers/media/video/gspca/sq905.c                  |   17 +++----
 drivers/media/video/gspca/sq905c.c                 |   10 ++--
 drivers/media/video/gspca/sq930x.c                 |   21 +++++----
 drivers/media/video/gspca/stk014.c                 |   16 ++++---
 drivers/media/video/gspca/stv0680.c                |    6 ++-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   18 ++++---
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   10 +++--
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |    8 ++-
 drivers/media/video/gspca/sunplus.c                |   10 +++--
 drivers/media/video/gspca/vc032x.c                 |   13 +++---
 drivers/media/video/gspca/vicam.c                  |   12 +++--
 drivers/media/video/gspca/w996Xcf.c                |    8 ++-
 drivers/media/video/gspca/xirlink_cit.c            |   14 +++---
 drivers/media/video/gspca/zc3xx.c                  |   14 +++---
 42 files changed, 338 insertions(+), 266 deletions(-)

diff --git a/drivers/media/video/gspca/benq.c b/drivers/media/video/gspca/benq.c
index a09c470..f4357f7 100644
--- a/drivers/media/video/gspca/benq.c
+++ b/drivers/media/video/gspca/benq.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "benq"
 
 #include "gspca.h"
@@ -62,7 +64,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			0,
 			500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -91,7 +93,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
 	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface,
 		gspca_dev->nbalt - 1);
 	if (ret < 0) {
-		err("usb_set_interface failed");
+		pr_err("usb_set_interface failed\n");
 		return ret;
 	}
 /*	reg_w(gspca_dev, 0x0003, 0x0002); */
@@ -113,7 +115,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	for (n = 0; n < 4; n++) {
 		urb = usb_alloc_urb(SD_NPKT, GFP_KERNEL);
 		if (!urb) {
-			err("usb_alloc_urb failed");
+			pr_err("usb_alloc_urb failed\n");
 			return -ENOMEM;
 		}
 		gspca_dev->urb[n] = urb;
@@ -123,7 +125,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 						&urb->transfer_dma);
 
 		if (urb->transfer_buffer == NULL) {
-			err("usb_alloc_coherent failed");
+			pr_err("usb_alloc_coherent failed\n");
 			return -ENOMEM;
 		}
 		urb->dev = gspca_dev->dev;
@@ -181,7 +183,7 @@ static void sd_isoc_irq(struct urb *urb)
 		if (gspca_dev->frozen)
 			return;
 #endif
-		err("urb status: %d", urb->status);
+		pr_err("urb status: %d\n", urb->status);
 		return;
 	}
 
@@ -209,7 +211,7 @@ static void sd_isoc_irq(struct urb *urb)
 		if (st == 0)
 			st = urb->iso_frame_desc[i].status;
 		if (st) {
-			err("ISOC data error: [%d] status=%d",
+			pr_err("ISOC data error: [%d] status=%d\n",
 				i, st);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
@@ -256,10 +258,10 @@ static void sd_isoc_irq(struct urb *urb)
 	/* resubmit the URBs */
 	st = usb_submit_urb(urb0, GFP_ATOMIC);
 	if (st < 0)
-		err("usb_submit_urb(0) ret %d", st);
+		pr_err("usb_submit_urb(0) ret %d\n", st);
 	st = usb_submit_urb(urb, GFP_ATOMIC);
 	if (st < 0)
-		err("usb_submit_urb() ret %d", st);
+		pr_err("usb_submit_urb() ret %d\n", st);
 }
 
 /* sub-driver description */
diff --git a/drivers/media/video/gspca/conex.c b/drivers/media/video/gspca/conex.c
index 8b39849..4c56dbe 100644
--- a/drivers/media/video/gspca/conex.c
+++ b/drivers/media/video/gspca/conex.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "conex"
 
 #include "gspca.h"
@@ -129,7 +131,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_r: buffer overflow");
+		pr_err("reg_r: buffer overflow\n");
 		return;
 	}
 #endif
@@ -169,7 +171,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_w: buffer overflow");
+		pr_err("reg_w: buffer overflow\n");
 		return;
 	}
 	PDEBUG(D_USBO, "reg write [%02x] = %02x..", index, *buffer);
diff --git a/drivers/media/video/gspca/cpia1.c b/drivers/media/video/gspca/cpia1.c
index f2a9451..f9b86b2 100644
--- a/drivers/media/video/gspca/cpia1.c
+++ b/drivers/media/video/gspca/cpia1.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "cpia1"
 
 #include <linux/input.h>
@@ -550,8 +552,7 @@ retry:
 			      gspca_dev->usb_buf, databytes, 1000);
 
 	if (ret < 0)
-		err("usb_control_msg %02x, error %d", command[1],
-		       ret);
+		pr_err("usb_control_msg %02x, error %d\n", command[1], ret);
 
 	if (ret == -EPIPE && retries > 0) {
 		retries--;
@@ -1279,7 +1280,7 @@ static void monitor_exposure(struct gspca_dev *gspca_dev)
 	cmd[7] = 0;
 	ret = cpia_usb_transferCmd(gspca_dev, cmd);
 	if (ret) {
-		err("ReadVPRegs(30,4,9,8) - failed: %d", ret);
+		pr_err("ReadVPRegs(30,4,9,8) - failed: %d\n", ret);
 		return;
 	}
 	exp_acc = gspca_dev->usb_buf[0];
diff --git a/drivers/media/video/gspca/etoms.c b/drivers/media/video/gspca/etoms.c
index 4b2c483..0357d6d 100644
--- a/drivers/media/video/gspca/etoms.c
+++ b/drivers/media/video/gspca/etoms.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "etoms"
 
 #include "gspca.h"
@@ -236,7 +238,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_r: buffer overflow");
+		pr_err("reg_r: buffer overflow\n");
 		return;
 	}
 #endif
@@ -274,7 +276,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_w: buffer overflow");
+		pr_err("reg_w: buffer overflow\n");
 		return;
 	}
 	PDEBUG(D_USBO, "reg write [%02x] = %02x..", index, *buffer);
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 5da4879..a3c2d36 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -21,6 +21,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "gspca"
 
 #include <linux/init.h>
@@ -148,7 +150,7 @@ static void int_irq(struct urb *urb)
 	if (ret == 0) {
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret < 0)
-			err("Resubmit URB failed with error %i", ret);
+			pr_err("Resubmit URB failed with error %i\n", ret);
 	}
 }
 
@@ -177,8 +179,8 @@ static int gspca_input_connect(struct gspca_dev *dev)
 
 		err = input_register_device(input_dev);
 		if (err) {
-			err("Input device registration failed with error %i",
-				err);
+			pr_err("Input device registration failed with error %i\n",
+			       err);
 			input_dev->dev.parent = NULL;
 			input_free_device(input_dev);
 		} else {
@@ -323,8 +325,8 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 		/* check the packet status and length */
 		st = urb->iso_frame_desc[i].status;
 		if (st) {
-			err("ISOC data error: [%d] len=%d, status=%d",
-				i, len, st);
+			pr_err("ISOC data error: [%d] len=%d, status=%d\n",
+			       i, len, st);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
 		}
@@ -346,7 +348,7 @@ resubmit:
 	/* resubmit the URB */
 	st = usb_submit_urb(urb, GFP_ATOMIC);
 	if (st < 0)
-		err("usb_submit_urb() ret %d", st);
+		pr_err("usb_submit_urb() ret %d\n", st);
 }
 
 /*
@@ -400,7 +402,7 @@ resubmit:
 	if (gspca_dev->cam.bulk_nurbs != 0) {
 		st = usb_submit_urb(urb, GFP_ATOMIC);
 		if (st < 0)
-			err("usb_submit_urb() ret %d", st);
+			pr_err("usb_submit_urb() ret %d\n", st);
 	}
 }
 
@@ -464,7 +466,7 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 		} else {
 /* !! image is NULL only when last pkt is LAST or DISCARD
 			if (gspca_dev->image == NULL) {
-				err("gspca_frame_add() image == NULL");
+				pr_err("gspca_frame_add() image == NULL\n");
 				return;
 			}
  */
@@ -525,7 +527,7 @@ static int frame_alloc(struct gspca_dev *gspca_dev, struct file *file,
 		count = GSPCA_MAX_FRAMES - 1;
 	gspca_dev->frbuf = vmalloc_32(frsz * count);
 	if (!gspca_dev->frbuf) {
-		err("frame alloc failed");
+		pr_err("frame alloc failed\n");
 		return -ENOMEM;
 	}
 	gspca_dev->capt_file = file;
@@ -597,7 +599,7 @@ static int gspca_set_alt0(struct gspca_dev *gspca_dev)
 		return 0;
 	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 0);
 	if (ret < 0)
-		err("set alt 0 err %d", ret);
+		pr_err("set alt 0 err %d\n", ret);
 	return ret;
 }
 
@@ -673,7 +675,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 		}
 	}
 	if (ep == NULL) {
-		err("no transfer endpoint found");
+		pr_err("no transfer endpoint found\n");
 		return NULL;
 	}
 	PDEBUG(D_STREAM, "use alt %d ep 0x%02x",
@@ -682,7 +684,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 	if (gspca_dev->nbalt > 1) {
 		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
 		if (ret < 0) {
-			err("set alt %d err %d", i, ret);
+			pr_err("set alt %d err %d\n", i, ret);
 			ep = NULL;
 		}
 	}
@@ -731,7 +733,7 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 	for (n = 0; n < nurbs; n++) {
 		urb = usb_alloc_urb(npkt, GFP_KERNEL);
 		if (!urb) {
-			err("usb_alloc_urb failed");
+			pr_err("usb_alloc_urb failed\n");
 			return -ENOMEM;
 		}
 		gspca_dev->urb[n] = urb;
@@ -741,7 +743,7 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 						&urb->transfer_dma);
 
 		if (urb->transfer_buffer == NULL) {
-			err("usb_alloc_coherent failed");
+			pr_err("usb_alloc_coherent failed\n");
 			return -ENOMEM;
 		}
 		urb->dev = gspca_dev->dev;
@@ -854,8 +856,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 			break;
 		gspca_stream_off(gspca_dev);
 		if (ret != -ENOSPC) {
-			err("usb_submit_urb alt %d err %d",
-				gspca_dev->alt, ret);
+			pr_err("usb_submit_urb alt %d err %d\n",
+			       gspca_dev->alt, ret);
 			goto out;
 		}
 
@@ -2202,12 +2204,12 @@ int gspca_dev_probe2(struct usb_interface *intf,
 		dev_size = sizeof *gspca_dev;
 	gspca_dev = kzalloc(dev_size, GFP_KERNEL);
 	if (!gspca_dev) {
-		err("couldn't kzalloc gspca struct");
+		pr_err("couldn't kzalloc gspca struct\n");
 		return -ENOMEM;
 	}
 	gspca_dev->usb_buf = kmalloc(USB_BUF_SZ, GFP_KERNEL);
 	if (!gspca_dev->usb_buf) {
-		err("out of memory");
+		pr_err("out of memory\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2264,7 +2266,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 				  VFL_TYPE_GRABBER,
 				  -1);
 	if (ret < 0) {
-		err("video_register_device err %d", ret);
+		pr_err("video_register_device err %d\n", ret);
 		goto out;
 	}
 
@@ -2296,8 +2298,8 @@ int gspca_dev_probe(struct usb_interface *intf,
 
 	/* we don't handle multi-config cameras */
 	if (dev->descriptor.bNumConfigurations != 1) {
-		err("%04x:%04x too many config",
-				id->idVendor, id->idProduct);
+		pr_err("%04x:%04x too many config\n",
+		       id->idVendor, id->idProduct);
 		return -ENODEV;
 	}
 
@@ -2480,7 +2482,7 @@ EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
 /* -- module insert / remove -- */
 static int __init gspca_init(void)
 {
-	info("v" DRIVER_VERSION_NUMBER " registered");
+	pr_info("v" DRIVER_VERSION_NUMBER " registered\n");
 	return 0;
 }
 static void __exit gspca_exit(void)
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index 49e2fcb..e444f16 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -14,11 +14,12 @@
 #ifdef GSPCA_DEBUG
 /* GSPCA our debug messages */
 extern int gspca_debug;
-#define PDEBUG(level, fmt, args...) \
-	do {\
-		if (gspca_debug & (level)) \
-			printk(KERN_INFO MODULE_NAME ": " fmt "\n", ## args); \
-	} while (0)
+#define PDEBUG(level, fmt, ...)					\
+do {								\
+	if (gspca_debug & (level))				\
+		pr_info(fmt, ##__VA_ARGS__);			\
+} while (0)
+
 #define D_ERR  0x01
 #define D_PROBE 0x02
 #define D_CONF 0x04
@@ -29,17 +30,8 @@ extern int gspca_debug;
 #define D_USBO 0x00
 #define D_V4L2 0x0100
 #else
-#define PDEBUG(level, fmt, args...)
+#define PDEBUG(level, fmt, ...)
 #endif
-#undef err
-#define err(fmt, args...) \
-	printk(KERN_ERR MODULE_NAME ": " fmt "\n", ## args)
-#undef info
-#define info(fmt, args...) \
-	printk(KERN_INFO MODULE_NAME ": " fmt "\n", ## args)
-#undef warn
-#define warn(fmt, args...) \
-	printk(KERN_WARNING MODULE_NAME ": " fmt "\n", ## args)
 
 #define GSPCA_MAX_FRAMES 16	/* maximum number of video frame buffers */
 /* image transfers */
diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 1bd9c4b..4ccc08d 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "jeilinj"
 
 #include <linux/slab.h>
@@ -113,8 +115,8 @@ static void jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
 			usb_sndbulkpipe(gspca_dev->dev, 3),
 			gspca_dev->usb_buf, 2, NULL, 500);
 	if (retval < 0) {
-		err("command write [%02x] error %d",
-				gspca_dev->usb_buf[0], retval);
+		pr_err("command write [%02x] error %d\n",
+		       gspca_dev->usb_buf[0], retval);
 		gspca_dev->usb_err = retval;
 	}
 }
@@ -131,8 +133,8 @@ static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 				gspca_dev->usb_buf, 1, NULL, 500);
 	response = gspca_dev->usb_buf[0];
 	if (retval < 0) {
-		err("read command [%02x] error %d",
-				gspca_dev->usb_buf[0], retval);
+		pr_err("read command [%02x] error %d\n",
+		       gspca_dev->usb_buf[0], retval);
 		gspca_dev->usb_err = retval;
 	}
 }
diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index 26fc206..9ed15a1 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "kinect"
 
 #include "gspca.h"
@@ -141,7 +143,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	struct cam_hdr *rhdr = (void *)ibuf;
 
 	if (cmd_len & 1 || cmd_len > (0x400 - sizeof(*chdr))) {
-		err("send_cmd: Invalid command length (0x%x)", cmd_len);
+		pr_err("send_cmd: Invalid command length (0x%x)\n", cmd_len);
 		return -1;
 	}
 
@@ -157,7 +159,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	PDEBUG(D_USBO, "Control cmd=%04x tag=%04x len=%04x: %d", cmd,
 		sd->cam_tag, cmd_len, res);
 	if (res < 0) {
-		err("send_cmd: Output control transfer failed (%d)", res);
+		pr_err("send_cmd: Output control transfer failed (%d)\n", res);
 		return res;
 	}
 
@@ -166,33 +168,35 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	} while (actual_len == 0);
 	PDEBUG(D_USBO, "Control reply: %d", res);
 	if (actual_len < sizeof(*rhdr)) {
-		err("send_cmd: Input control transfer failed (%d)", res);
+		pr_err("send_cmd: Input control transfer failed (%d)\n", res);
 		return res;
 	}
 	actual_len -= sizeof(*rhdr);
 
 	if (rhdr->magic[0] != 0x52 || rhdr->magic[1] != 0x42) {
-		err("send_cmd: Bad magic %02x %02x", rhdr->magic[0],
-			rhdr->magic[1]);
+		pr_err("send_cmd: Bad magic %02x %02x\n",
+		       rhdr->magic[0], rhdr->magic[1]);
 		return -1;
 	}
 	if (rhdr->cmd != chdr->cmd) {
-		err("send_cmd: Bad cmd %02x != %02x", rhdr->cmd, chdr->cmd);
+		pr_err("send_cmd: Bad cmd %02x != %02x\n",
+		       rhdr->cmd, chdr->cmd);
 		return -1;
 	}
 	if (rhdr->tag != chdr->tag) {
-		err("send_cmd: Bad tag %04x != %04x", rhdr->tag, chdr->tag);
+		pr_err("send_cmd: Bad tag %04x != %04x\n",
+		       rhdr->tag, chdr->tag);
 		return -1;
 	}
 	if (cpu_to_le16(rhdr->len) != (actual_len/2)) {
-		err("send_cmd: Bad len %04x != %04x",
-				cpu_to_le16(rhdr->len), (int)(actual_len/2));
+		pr_err("send_cmd: Bad len %04x != %04x\n",
+		       cpu_to_le16(rhdr->len), (int)(actual_len/2));
 		return -1;
 	}
 
 	if (actual_len > reply_len) {
-		warn("send_cmd: Data buffer is %d bytes long, but got %d bytes",
-				reply_len, actual_len);
+		pr_warn("send_cmd: Data buffer is %d bytes long, but got %d bytes\n",
+			reply_len, actual_len);
 		memcpy(replybuf, ibuf+sizeof(*rhdr), reply_len);
 	} else {
 		memcpy(replybuf, ibuf+sizeof(*rhdr), actual_len);
@@ -218,8 +222,8 @@ static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
 	if (res < 0)
 		return res;
 	if (res != 2) {
-		warn("send_cmd returned %d [%04x %04x], 0000 expected",
-				res, reply[0], reply[1]);
+		pr_warn("send_cmd returned %d [%04x %04x], 0000 expected\n",
+			res, reply[0], reply[1]);
 	}
 	return 0;
 }
@@ -353,8 +357,8 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 		return;
 
 	if (hdr->magic[0] != 'R' || hdr->magic[1] != 'B') {
-		warn("[Stream %02x] Invalid magic %02x%02x", sd->stream_flag,
-				hdr->magic[0], hdr->magic[1]);
+		pr_warn("[Stream %02x] Invalid magic %02x%02x\n",
+			sd->stream_flag, hdr->magic[0], hdr->magic[1]);
 		return;
 	}
 
@@ -368,7 +372,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 		gspca_frame_add(gspca_dev, LAST_PACKET, data, datalen);
 
 	else
-		warn("Packet type not recognized...");
+		pr_warn("Packet type not recognized...\n");
 }
 
 /* sub-driver description */
diff --git a/drivers/media/video/gspca/konica.c b/drivers/media/video/gspca/konica.c
index 5964691..f3f7fe0 100644
--- a/drivers/media/video/gspca/konica.c
+++ b/drivers/media/video/gspca/konica.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "konica"
 
 #include <linux/input.h>
@@ -200,7 +202,7 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 			0,
 			1000);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -221,7 +223,7 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 value, u16 index)
 			2,
 			1000);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -284,7 +286,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		err("Couldn't get altsetting");
+		pr_err("Couldn't get altsetting\n");
 		return -EIO;
 	}
 
@@ -315,7 +317,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 			le16_to_cpu(alt->endpoint[i].desc.wMaxPacketSize);
 		urb = usb_alloc_urb(SD_NPKT, GFP_KERNEL);
 		if (!urb) {
-			err("usb_alloc_urb failed");
+			pr_err("usb_alloc_urb failed\n");
 			return -ENOMEM;
 		}
 		gspca_dev->urb[n] = urb;
@@ -324,7 +326,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 						GFP_KERNEL,
 						&urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
-			err("usb_buffer_alloc failed");
+			pr_err("usb_buffer_alloc failed\n");
 			return -ENOMEM;
 		}
 
@@ -386,7 +388,7 @@ static void sd_isoc_irq(struct urb *urb)
 		PDEBUG(D_ERR, "urb status: %d", urb->status);
 		st = usb_submit_urb(urb, GFP_ATOMIC);
 		if (st < 0)
-			err("resubmit urb error %d", st);
+			pr_err("resubmit urb error %d\n", st);
 		return;
 	}
 
@@ -477,7 +479,7 @@ resubmit:
 	}
 	st = usb_submit_urb(status_urb, GFP_ATOMIC);
 	if (st < 0)
-		err("usb_submit_urb(status_urb) ret %d", st);
+		pr_err("usb_submit_urb(status_urb) ret %d\n", st);
 }
 
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
diff --git a/drivers/media/video/gspca/mars.c b/drivers/media/video/gspca/mars.c
index 0196209..ef45fa5 100644
--- a/drivers/media/video/gspca/mars.c
+++ b/drivers/media/video/gspca/mars.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "mars"
 
 #include "gspca.h"
@@ -178,8 +180,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			&alen,
 			500);	/* timeout in milliseconds */
 	if (ret < 0) {
-		err("reg write [%02x] error %d",
-			gspca_dev->usb_buf[0], ret);
+		pr_err("reg write [%02x] error %d\n",
+		       gspca_dev->usb_buf[0], ret);
 		gspca_dev->usb_err = ret;
 	}
 }
diff --git a/drivers/media/video/gspca/mr97310a.c b/drivers/media/video/gspca/mr97310a.c
index 97e5079..473e813 100644
--- a/drivers/media/video/gspca/mr97310a.c
+++ b/drivers/media/video/gspca/mr97310a.c
@@ -40,6 +40,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "mr97310a"
 
 #include "gspca.h"
@@ -267,7 +269,7 @@ static int mr_write(struct gspca_dev *gspca_dev, int len)
 			  usb_sndbulkpipe(gspca_dev->dev, 4),
 			  gspca_dev->usb_buf, len, NULL, 500);
 	if (rc < 0)
-		err("reg write [%02x] error %d",
+		pr_err("reg write [%02x] error %d\n",
 		       gspca_dev->usb_buf[0], rc);
 	return rc;
 }
@@ -281,7 +283,7 @@ static int mr_read(struct gspca_dev *gspca_dev, int len)
 			  usb_rcvbulkpipe(gspca_dev->dev, 3),
 			  gspca_dev->usb_buf, len, NULL, 500);
 	if (rc < 0)
-		err("reg read [%02x] error %d",
+		pr_err("reg read [%02x] error %d\n",
 		       gspca_dev->usb_buf[0], rc);
 	return rc;
 }
@@ -540,7 +542,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			sd->sensor_type = 1;
 			break;
 		default:
-			err("Unknown CIF Sensor id : %02x",
+			pr_err("Unknown CIF Sensor id : %02x\n",
 			       gspca_dev->usb_buf[1]);
 			return -ENODEV;
 		}
@@ -575,10 +577,10 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			sd->sensor_type = 2;
 		} else if ((gspca_dev->usb_buf[0] != 0x03) &&
 					(gspca_dev->usb_buf[0] != 0x04)) {
-			err("Unknown VGA Sensor id Byte 0: %02x",
-					gspca_dev->usb_buf[0]);
-			err("Defaults assumed, may not work");
-			err("Please report this");
+			pr_err("Unknown VGA Sensor id Byte 0: %02x\n",
+			       gspca_dev->usb_buf[0]);
+			pr_err("Defaults assumed, may not work\n");
+			pr_err("Please report this\n");
 		}
 		/* Sakar Digital color needs to be adjusted. */
 		if ((gspca_dev->usb_buf[0] == 0x03) &&
@@ -595,10 +597,10 @@ static int sd_config(struct gspca_dev *gspca_dev,
 				/* Nothing to do here. */
 				break;
 			default:
-				err("Unknown VGA Sensor id Byte 1: %02x",
-					gspca_dev->usb_buf[1]);
-				err("Defaults assumed, may not work");
-				err("Please report this");
+				pr_err("Unknown VGA Sensor id Byte 1: %02x\n",
+				       gspca_dev->usb_buf[1]);
+				pr_err("Defaults assumed, may not work\n");
+				pr_err("Please report this\n");
 			}
 		}
 		PDEBUG(D_PROBE, "MR97310A VGA camera detected, sensor: %d",
diff --git a/drivers/media/video/gspca/nw80x.c b/drivers/media/video/gspca/nw80x.c
index 8e754fd..7681814 100644
--- a/drivers/media/video/gspca/nw80x.c
+++ b/drivers/media/video/gspca/nw80x.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "nw80x"
 
 #include "gspca.h"
@@ -1571,7 +1573,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			len,
 			500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1592,7 +1594,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			0x00, index,
 			gspca_dev->usb_buf, len, 500);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 		return;
 	}
@@ -1802,7 +1804,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		}
 	}
 	if (webcam_chip[sd->webcam] != sd->bridge) {
-		err("Bad webcam type %d for NW80%d", sd->webcam, sd->bridge);
+		pr_err("Bad webcam type %d for NW80%d\n",
+		       sd->webcam, sd->bridge);
 		gspca_dev->usb_err = -ENODEV;
 		return gspca_dev->usb_err;
 	}
diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index 0800433..17d0d56 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -36,6 +36,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "ov519"
 
 #include <linux/input.h>
@@ -2171,7 +2174,7 @@ static void reg_w(struct sd *sd, u16 index, u16 value)
 			sd->gspca_dev.usb_buf, 1, 500);
 leave:
 	if (ret < 0) {
-		err("reg_w %02x failed %d", index, ret);
+		pr_err("reg_w %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 		return;
 	}
@@ -2210,7 +2213,7 @@ static int reg_r(struct sd *sd, u16 index)
 		PDEBUG(D_USBI, "GET %02x 0000 %04x %02x",
 			req, index, ret);
 	} else {
-		err("reg_r %02x failed %d", index, ret);
+		pr_err("reg_r %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2235,7 +2238,7 @@ static int reg_r8(struct sd *sd,
 	if (ret >= 0) {
 		ret = sd->gspca_dev.usb_buf[0];
 	} else {
-		err("reg_r8 %02x failed %d", index, ret);
+		pr_err("reg_r8 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2288,7 +2291,7 @@ static void ov518_reg_w32(struct sd *sd, u16 index, u32 value, int n)
 			0, index,
 			sd->gspca_dev.usb_buf, n, 500);
 	if (ret < 0) {
-		err("reg_w32 %02x failed %d", index, ret);
+		pr_err("reg_w32 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 }
@@ -2457,7 +2460,7 @@ static void ovfx2_i2c_w(struct sd *sd, u8 reg, u8 value)
 			(u16) value, (u16) reg, NULL, 0, 500);
 
 	if (ret < 0) {
-		err("ovfx2_i2c_w %02x failed %d", reg, ret);
+		pr_err("ovfx2_i2c_w %02x failed %d\n", reg, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2481,7 +2484,7 @@ static int ovfx2_i2c_r(struct sd *sd, u8 reg)
 		ret = sd->gspca_dev.usb_buf[0];
 		PDEBUG(D_USBI, "ovfx2_i2c_r %02x %02x", reg, ret);
 	} else {
-		err("ovfx2_i2c_r %02x failed %d", reg, ret);
+		pr_err("ovfx2_i2c_r %02x failed %d\n", reg, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2727,7 +2730,7 @@ static void ov_hires_configure(struct sd *sd)
 	int high, low;
 
 	if (sd->bridge != BRIDGE_OVFX2) {
-		err("error hires sensors only supported with ovfx2");
+		pr_err("error hires sensors only supported with ovfx2\n");
 		return;
 	}
 
@@ -2762,7 +2765,7 @@ static void ov_hires_configure(struct sd *sd)
 		}
 		break;
 	}
-	err("Error unknown sensor type: %02x%02x", high, low);
+	pr_err("Error unknown sensor type: %02x%02x\n", high, low);
 }
 
 /* This initializes the OV8110, OV8610 sensor. The OV8110 uses
@@ -2783,7 +2786,7 @@ static void ov8xx0_configure(struct sd *sd)
 	if ((rc & 3) == 1)
 		sd->sensor = SEN_OV8610;
 	else
-		err("Unknown image sensor version: %d", rc & 3);
+		pr_err("Unknown image sensor version: %d\n", rc & 3);
 }
 
 /* This initializes the OV7610, OV7620, or OV76BE sensor. The OV76BE uses
@@ -2840,8 +2843,8 @@ static void ov7xx0_configure(struct sd *sd)
 		if (high == 0x76) {
 			switch (low) {
 			case 0x30:
-				err("Sensor is an OV7630/OV7635");
-				err("7630 is not supported by this driver");
+				pr_err("Sensor is an OV7630/OV7635\n");
+				pr_err("7630 is not supported by this driver\n");
 				return;
 			case 0x40:
 				PDEBUG(D_PROBE, "Sensor is an OV7645");
@@ -2869,7 +2872,7 @@ static void ov7xx0_configure(struct sd *sd)
 			sd->sensor = SEN_OV7620;
 		}
 	} else {
-		err("Unknown image sensor version: %d", rc & 3);
+		pr_err("Unknown image sensor version: %d\n", rc & 3);
 	}
 }
 
@@ -2892,8 +2895,7 @@ static void ov6xx0_configure(struct sd *sd)
 	switch (rc) {
 	case 0x00:
 		sd->sensor = SEN_OV6630;
-		warn("WARNING: Sensor is an OV66308. Your camera may have");
-		warn("been misdetected in previous driver versions.");
+		pr_warn("WARNING: Sensor is an OV66308. Your camera may have been misdetected in previous driver versions.\n");
 		break;
 	case 0x01:
 		sd->sensor = SEN_OV6620;
@@ -2909,11 +2911,10 @@ static void ov6xx0_configure(struct sd *sd)
 		break;
 	case 0x90:
 		sd->sensor = SEN_OV6630;
-		warn("WARNING: Sensor is an OV66307. Your camera may have");
-		warn("been misdetected in previous driver versions.");
+		pr_warn("WARNING: Sensor is an OV66307. Your camera may have been misdetected in previous driver versions.\n");
 		break;
 	default:
-		err("FATAL: Unknown sensor version: 0x%02x", rc);
+		pr_err("FATAL: Unknown sensor version: 0x%02x\n", rc);
 		return;
 	}
 
@@ -3407,7 +3408,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	} else if (init_ov_sensor(sd, OV_HIRES_SID) >= 0) {
 		ov_hires_configure(sd);
 	} else {
-		err("Can't determine sensor slave IDs");
+		pr_err("Can't determine sensor slave IDs\n");
 		goto error;
 	}
 
@@ -3592,7 +3593,7 @@ static void ov511_mode_init_regs(struct sd *sd)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		err("Couldn't get altsetting");
+		pr_err("Couldn't get altsetting\n");
 		sd->gspca_dev.usb_err = -EIO;
 		return;
 	}
@@ -3715,7 +3716,7 @@ static void ov518_mode_init_regs(struct sd *sd)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		err("Couldn't get altsetting");
+		pr_err("Couldn't get altsetting\n");
 		sd->gspca_dev.usb_err = -EIO;
 		return;
 	}
diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 0c6369b..76907ec 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "ov534"
 
 #include "gspca.h"
@@ -775,7 +777,7 @@ static void ov534_reg_write(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
 	if (ret < 0) {
-		err("write failed %d", ret);
+		pr_err("write failed %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -794,7 +796,7 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
 	PDEBUG(D_USBI, "GET 01 0000 %04x %02x", reg, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
-		err("read failed %d", ret);
+		pr_err("read failed %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 	return gspca_dev->usb_buf[0];
@@ -858,7 +860,7 @@ static void sccb_reg_write(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 	ov534_reg_write(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_3);
 
 	if (!sccb_check_status(gspca_dev)) {
-		err("sccb_reg_write failed");
+		pr_err("sccb_reg_write failed\n");
 		gspca_dev->usb_err = -EIO;
 	}
 }
@@ -868,11 +870,11 @@ static u8 sccb_reg_read(struct gspca_dev *gspca_dev, u16 reg)
 	ov534_reg_write(gspca_dev, OV534_REG_SUBADDR, reg);
 	ov534_reg_write(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_2);
 	if (!sccb_check_status(gspca_dev))
-		err("sccb_reg_read failed 1");
+		pr_err("sccb_reg_read failed 1\n");
 
 	ov534_reg_write(gspca_dev, OV534_REG_OPERATION, OV534_OP_READ_2);
 	if (!sccb_check_status(gspca_dev))
-		err("sccb_reg_read failed 2");
+		pr_err("sccb_reg_read failed 2\n");
 
 	return ov534_reg_read(gspca_dev, OV534_REG_READ);
 }
diff --git a/drivers/media/video/gspca/ov534_9.c b/drivers/media/video/gspca/ov534_9.c
index aaf5428..a954a31 100644
--- a/drivers/media/video/gspca/ov534_9.c
+++ b/drivers/media/video/gspca/ov534_9.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "ov534_9"
 
 #include "gspca.h"
@@ -785,7 +787,7 @@ static void reg_w_i(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
 	if (ret < 0) {
-		err("reg_w failed %d", ret);
+		pr_err("reg_w failed %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -810,7 +812,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
 	PDEBUG(D_USBI, "reg_r [%04x] -> %02x", reg, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 	return gspca_dev->usb_buf[0];
@@ -848,7 +850,7 @@ static void sccb_write(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 	reg_w_i(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_3);
 
 	if (!sccb_check_status(gspca_dev))
-		err("sccb_write failed");
+		pr_err("sccb_write failed\n");
 }
 
 static u8 sccb_read(struct gspca_dev *gspca_dev, u16 reg)
@@ -856,11 +858,11 @@ static u8 sccb_read(struct gspca_dev *gspca_dev, u16 reg)
 	reg_w(gspca_dev, OV534_REG_SUBADDR, reg);
 	reg_w(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_2);
 	if (!sccb_check_status(gspca_dev))
-		err("sccb_read failed 1");
+		pr_err("sccb_read failed 1\n");
 
 	reg_w(gspca_dev, OV534_REG_OPERATION, OV534_OP_READ_2);
 	if (!sccb_check_status(gspca_dev))
-		err("sccb_read failed 2");
+		pr_err("sccb_read failed 2\n");
 
 	return reg_r(gspca_dev, OV534_REG_READ);
 }
diff --git a/drivers/media/video/gspca/pac7302.c b/drivers/media/video/gspca/pac7302.c
index 5615d7b..1c44f78 100644
--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -61,6 +61,8 @@
     3   | 0x21       | sethvflip()
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "pac7302"
 
 #include <linux/input.h>
@@ -408,8 +410,8 @@ static void reg_w_buf(struct gspca_dev *gspca_dev,
 			index, gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
-		err("reg_w_buf failed index 0x%02x, error %d",
-			index, ret);
+		pr_err("reg_w_buf failed index 0x%02x, error %d\n",
+		       index, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -431,8 +433,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			0, index, gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_w() failed index 0x%02x, value 0x%02x, error %d",
-			index, value, ret);
+		pr_err("reg_w() failed index 0x%02x, value 0x%02x, error %d\n",
+		       index, value, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -466,9 +468,8 @@ static void reg_w_page(struct gspca_dev *gspca_dev,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
 		if (ret < 0) {
-			err("reg_w_page() failed index 0x%02x, "
-			"value 0x%02x, error %d",
-				index, page[index], ret);
+			pr_err("reg_w_page() failed index 0x%02x, value 0x%02x, error %d\n",
+			       index, page[index], ret);
 			gspca_dev->usb_err = ret;
 			break;
 		}
diff --git a/drivers/media/video/gspca/pac7311.c b/drivers/media/video/gspca/pac7311.c
index f8801b5..7509d05 100644
--- a/drivers/media/video/gspca/pac7311.c
+++ b/drivers/media/video/gspca/pac7311.c
@@ -49,6 +49,8 @@
 		for max gain, 0x14 for minimal gain.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "pac7311"
 
 #include <linux/input.h>
@@ -276,8 +278,8 @@ static void reg_w_buf(struct gspca_dev *gspca_dev,
 			index, gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
-		err("reg_w_buf() failed index 0x%02x, error %d",
-			index, ret);
+		pr_err("reg_w_buf() failed index 0x%02x, error %d\n",
+		       index, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -299,8 +301,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			0, index, gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_w() failed index 0x%02x, value 0x%02x, error %d",
-			index, value, ret);
+		pr_err("reg_w() failed index 0x%02x, value 0x%02x, error %d\n",
+		       index, value, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -334,9 +336,8 @@ static void reg_w_page(struct gspca_dev *gspca_dev,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
 		if (ret < 0) {
-			err("reg_w_page() failed index 0x%02x, "
-			"value 0x%02x, error %d",
-				index, page[index], ret);
+			pr_err("reg_w_page() failed index 0x%02x, value 0x%02x, error %d\n",
+			       index, page[index], ret);
 			gspca_dev->usb_err = ret;
 			break;
 		}
diff --git a/drivers/media/video/gspca/se401.c b/drivers/media/video/gspca/se401.c
index 4c283c2..3b71bbc 100644
--- a/drivers/media/video/gspca/se401.c
+++ b/drivers/media/video/gspca/se401.c
@@ -23,6 +23,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "se401"
 
 #define BULK_SIZE 4096
@@ -144,8 +146,8 @@ static void se401_write_req(struct gspca_dev *gspca_dev, u16 req, u16 value,
 			      value, 0, NULL, 0, 1000);
 	if (err < 0) {
 		if (!silent)
-			err("write req failed req %#04x val %#04x error %d",
-			    req, value, err);
+			pr_err("write req failed req %#04x val %#04x error %d\n",
+			       req, value, err);
 		gspca_dev->usb_err = err;
 	}
 }
@@ -158,7 +160,7 @@ static void se401_read_req(struct gspca_dev *gspca_dev, u16 req, int silent)
 		return;
 
 	if (USB_BUF_SZ < READ_REQ_SIZE) {
-		err("USB_BUF_SZ too small!!");
+		pr_err("USB_BUF_SZ too small!!\n");
 		gspca_dev->usb_err = -ENOBUFS;
 		return;
 	}
@@ -169,7 +171,8 @@ static void se401_read_req(struct gspca_dev *gspca_dev, u16 req, int silent)
 			      0, 0, gspca_dev->usb_buf, READ_REQ_SIZE, 1000);
 	if (err < 0) {
 		if (!silent)
-			err("read req failed req %#04x error %d", req, err);
+			pr_err("read req failed req %#04x error %d\n",
+			       req, err);
 		gspca_dev->usb_err = err;
 	}
 }
@@ -188,8 +191,8 @@ static void se401_set_feature(struct gspca_dev *gspca_dev,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      param, selector, NULL, 0, 1000);
 	if (err < 0) {
-		err("set feature failed sel %#04x param %#04x error %d",
-		    selector, param, err);
+		pr_err("set feature failed sel %#04x param %#04x error %d\n",
+		       selector, param, err);
 		gspca_dev->usb_err = err;
 	}
 }
@@ -202,7 +205,7 @@ static int se401_get_feature(struct gspca_dev *gspca_dev, u16 selector)
 		return gspca_dev->usb_err;
 
 	if (USB_BUF_SZ < 2) {
-		err("USB_BUF_SZ too small!!");
+		pr_err("USB_BUF_SZ too small!!\n");
 		gspca_dev->usb_err = -ENOBUFS;
 		return gspca_dev->usb_err;
 	}
@@ -213,7 +216,8 @@ static int se401_get_feature(struct gspca_dev *gspca_dev, u16 selector)
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0, selector, gspca_dev->usb_buf, 2, 1000);
 	if (err < 0) {
-		err("get feature failed sel %#04x error %d", selector, err);
+		pr_err("get feature failed sel %#04x error %d\n",
+		       selector, err);
 		gspca_dev->usb_err = err;
 		return err;
 	}
@@ -300,21 +304,21 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		return gspca_dev->usb_err;
 
 	if (cd[1] != 0x41) {
-		err("Wrong descriptor type");
+		pr_err("Wrong descriptor type\n");
 		return -ENODEV;
 	}
 
 	if (!(cd[2] & SE401_FORMAT_BAYER)) {
-		err("Bayer format not supported!");
+		pr_err("Bayer format not supported!\n");
 		return -ENODEV;
 	}
 
 	if (cd[3])
-		info("ExtraFeatures: %d", cd[3]);
+		pr_info("ExtraFeatures: %d\n", cd[3]);
 
 	n = cd[4] | (cd[5] << 8);
 	if (n > MAX_MODES) {
-		err("Too many frame sizes");
+		pr_err("Too many frame sizes\n");
 		return -ENODEV;
 	}
 
@@ -353,15 +357,16 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			sd->fmts[i].pixelformat = V4L2_PIX_FMT_SBGGR8;
 			sd->fmts[i].bytesperline = widths[i];
 			sd->fmts[i].sizeimage = widths[i] * heights[i];
-			info("Frame size: %dx%d bayer", widths[i], heights[i]);
+			pr_info("Frame size: %dx%d bayer\n",
+				widths[i], heights[i]);
 		} else {
 			/* Found a match use janggu compression */
 			sd->fmts[i].pixelformat = V4L2_PIX_FMT_SE401;
 			sd->fmts[i].bytesperline = 0;
 			sd->fmts[i].sizeimage = widths[i] * heights[i] * 3;
-			info("Frame size: %dx%d 1/%dth janggu",
-			     widths[i], heights[i],
-			     sd->fmts[i].priv * sd->fmts[i].priv);
+			pr_info("Frame size: %dx%d 1/%dth janggu\n",
+				widths[i], heights[i],
+				sd->fmts[i].priv * sd->fmts[i].priv);
 		}
 	}
 
@@ -571,11 +576,12 @@ static void sd_pkt_scan_janggu(struct gspca_dev *gspca_dev, u8 *data, int len)
 		plen   = ((bits + 47) >> 4) << 1;
 		/* Sanity checks */
 		if (plen > 1024) {
-			err("invalid packet len %d restarting stream", plen);
+			pr_err("invalid packet len %d restarting stream\n",
+			       plen);
 			goto error;
 		}
 		if (info == 3) {
-			err("unknown frame info value restarting stream");
+			pr_err("unknown frame info value restarting stream\n");
 			goto error;
 		}
 
@@ -599,8 +605,8 @@ static void sd_pkt_scan_janggu(struct gspca_dev *gspca_dev, u8 *data, int len)
 			break;
 		case 1: /* EOF */
 			if (sd->pixels_read != imagesize) {
-				err("frame size %d expected %d",
-				    sd->pixels_read, imagesize);
+				pr_err("frame size %d expected %d\n",
+				       sd->pixels_read, imagesize);
 				goto error;
 			}
 			sd_complete_frame(gspca_dev, sd->packet, plen);
diff --git a/drivers/media/video/gspca/sn9c2028.c b/drivers/media/video/gspca/sn9c2028.c
index 4271f86..48aae39 100644
--- a/drivers/media/video/gspca/sn9c2028.c
+++ b/drivers/media/video/gspca/sn9c2028.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sn9c2028"
 
 #include "gspca.h"
@@ -75,8 +77,8 @@ static int sn9c2028_command(struct gspca_dev *gspca_dev, u8 *command)
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			2, 0, gspca_dev->usb_buf, 6, 500);
 	if (rc < 0) {
-		err("command write [%02x] error %d",
-				gspca_dev->usb_buf[0], rc);
+		pr_err("command write [%02x] error %d\n",
+		       gspca_dev->usb_buf[0], rc);
 		return rc;
 	}
 
@@ -93,7 +95,7 @@ static int sn9c2028_read1(struct gspca_dev *gspca_dev)
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			1, 0, gspca_dev->usb_buf, 1, 500);
 	if (rc != 1) {
-		err("read1 error %d", rc);
+		pr_err("read1 error %d\n", rc);
 		return (rc < 0) ? rc : -EIO;
 	}
 	PDEBUG(D_USBI, "read1 response %02x", gspca_dev->usb_buf[0]);
@@ -109,7 +111,7 @@ static int sn9c2028_read4(struct gspca_dev *gspca_dev, u8 *reading)
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			4, 0, gspca_dev->usb_buf, 4, 500);
 	if (rc != 4) {
-		err("read4 error %d", rc);
+		pr_err("read4 error %d\n", rc);
 		return (rc < 0) ? rc : -EIO;
 	}
 	memcpy(reading, gspca_dev->usb_buf, 4);
@@ -131,7 +133,7 @@ static int sn9c2028_long_command(struct gspca_dev *gspca_dev, u8 *command)
 	for (i = 0; i < 256 && status < 2; i++)
 		status = sn9c2028_read1(gspca_dev);
 	if (status != 2) {
-		err("long command status read error %d", status);
+		pr_err("long command status read error %d\n", status);
 		return (status < 0) ? status : -EIO;
 	}
 
@@ -638,7 +640,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		err_code = start_vivitar_cam(gspca_dev);
 		break;
 	default:
-		err("Starting unknown camera, please report this");
+		pr_err("Starting unknown camera, please report this\n");
 		return -ENXIO;
 	}
 
diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 81b8a60..f23b4c0 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sonixj"
 
 #include <linux/input.h>
@@ -1395,7 +1397,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 		return;
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_r: buffer overflow");
+		pr_err("reg_r: buffer overflow\n");
 		return;
 	}
 #endif
@@ -1408,7 +1410,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			500);
 	PDEBUG(D_USBI, "reg_r [%02x] -> %02x", value, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1432,7 +1434,7 @@ static void reg_w1(struct gspca_dev *gspca_dev,
 			gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_w1 err %d", ret);
+		pr_err("reg_w1 err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1449,7 +1451,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 		value, buffer[0], buffer[1]);
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_w: buffer overflow");
+		pr_err("reg_w: buffer overflow\n");
 		return;
 	}
 #endif
@@ -1462,7 +1464,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1502,7 +1504,7 @@ static void i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 			gspca_dev->usb_buf, 8,
 			500);
 	if (ret < 0) {
-		err("i2c_w1 err %d", ret);
+		pr_err("i2c_w1 err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1527,7 +1529,7 @@ static void i2c_w8(struct gspca_dev *gspca_dev,
 			500);
 	msleep(2);
 	if (ret < 0) {
-		err("i2c_w8 err %d", ret);
+		pr_err("i2c_w8 err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -1591,7 +1593,7 @@ static void hv7131r_probe(struct gspca_dev *gspca_dev)
 		PDEBUG(D_PROBE, "Sensor HV7131R found");
 		return;
 	}
-	warn("Erroneous HV7131R ID 0x%02x 0x%02x 0x%02x",
+	pr_warn("Erroneous HV7131R ID 0x%02x 0x%02x 0x%02x\n",
 		gspca_dev->usb_buf[0], gspca_dev->usb_buf[1],
 		gspca_dev->usb_buf[2]);
 }
@@ -1710,7 +1712,7 @@ static void ov7648_probe(struct gspca_dev *gspca_dev)
 		sd->sensor = SENSOR_PO1030;
 		return;
 	}
-	err("Unknown sensor %04x", val);
+	pr_err("Unknown sensor %04x\n", val);
 }
 
 /* 0c45:6142 sensor may be po2030n, gc0305 or gc0307 */
@@ -1748,7 +1750,7 @@ static void po2030n_probe(struct gspca_dev *gspca_dev)
 		PDEBUG(D_PROBE, "Sensor po2030n");
 /*		sd->sensor = SENSOR_PO2030N; */
 	} else {
-		err("Unknown sensor ID %04x", val);
+		pr_err("Unknown sensor ID %04x\n", val);
 	}
 }
 
diff --git a/drivers/media/video/gspca/spca1528.c b/drivers/media/video/gspca/spca1528.c
index 76c006b..4131be5 100644
--- a/drivers/media/video/gspca/spca1528.c
+++ b/drivers/media/video/gspca/spca1528.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca1528"
 
 #include "gspca.h"
@@ -171,7 +173,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	PDEBUG(D_USBI, "GET %02x 0000 %04x %02x", req, index,
 			 gspca_dev->usb_buf[0]);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -193,7 +195,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			value, index,
 			NULL, 0, 500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -217,7 +219,7 @@ static void reg_wb(struct gspca_dev *gspca_dev,
 			value, index,
 			gspca_dev->usb_buf, 1, 500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
diff --git a/drivers/media/video/gspca/spca500.c b/drivers/media/video/gspca/spca500.c
index 3e76951..bb82c94 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca500"
 
 #include "gspca.h"
@@ -396,7 +398,7 @@ static int reg_w(struct gspca_dev *gspca_dev,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index, NULL, 0, 500);
 	if (ret < 0)
-		err("reg write: error %d", ret);
+		pr_err("reg write: error %d\n", ret);
 	return ret;
 }
 
@@ -418,7 +420,7 @@ static int reg_r_12(struct gspca_dev *gspca_dev,
 			gspca_dev->usb_buf, length,
 			500);		/* timeout */
 	if (ret < 0) {
-		err("reg_r_12 err %d", ret);
+		pr_err("reg_r_12 err %d\n", ret);
 		return ret;
 	}
 	return (gspca_dev->usb_buf[1] << 8) + gspca_dev->usb_buf[0];
diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/video/gspca/spca501.c
index f7ef282..7aaac72 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca501"
 
 #include "gspca.h"
@@ -1852,7 +1854,7 @@ static int reg_write(struct usb_device *dev,
 	PDEBUG(D_USBO, "reg write: 0x%02x 0x%02x 0x%02x",
 		req, index, value);
 	if (ret < 0)
-		err("reg write: error %d", ret);
+		pr_err("reg write: error %d\n", ret);
 	return ret;
 }
 
diff --git a/drivers/media/video/gspca/spca505.c b/drivers/media/video/gspca/spca505.c
index e5bf865..16722dc 100644
--- a/drivers/media/video/gspca/spca505.c
+++ b/drivers/media/video/gspca/spca505.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca505"
 
 #include "gspca.h"
@@ -578,7 +580,7 @@ static int reg_write(struct usb_device *dev,
 	PDEBUG(D_USBO, "reg write: 0x%02x,0x%02x:0x%02x, %d",
 		req, index, value, ret);
 	if (ret < 0)
-		err("reg write: error %d", ret);
+		pr_err("reg write: error %d\n", ret);
 	return ret;
 }
 
@@ -685,8 +687,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return ret;
 	}
 	if (ret != 0x0101) {
-		err("After vector read returns 0x%04x should be 0x0101",
-			ret);
+		pr_err("After vector read returns 0x%04x should be 0x0101\n",
+		       ret);
 	}
 
 	ret = reg_write(gspca_dev->dev, 0x06, 0x16, 0x0a);
diff --git a/drivers/media/video/gspca/spca508.c b/drivers/media/video/gspca/spca508.c
index 9d0b460..a44fe3d 100644
--- a/drivers/media/video/gspca/spca508.c
+++ b/drivers/media/video/gspca/spca508.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca508"
 
 #include "gspca.h"
@@ -1275,7 +1277,7 @@ static int reg_write(struct usb_device *dev,
 	PDEBUG(D_USBO, "reg write i:0x%04x = 0x%02x",
 		index, value);
 	if (ret < 0)
-		err("reg write: error %d", ret);
+		pr_err("reg write: error %d\n", ret);
 	return ret;
 }
 
@@ -1297,7 +1299,7 @@ static int reg_read(struct gspca_dev *gspca_dev,
 	PDEBUG(D_USBI, "reg read i:%04x --> %02x",
 		index, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
-		err("reg_read err %d", ret);
+		pr_err("reg_read err %d\n", ret);
 		return ret;
 	}
 	return gspca_dev->usb_buf[0];
diff --git a/drivers/media/video/gspca/spca561.c b/drivers/media/video/gspca/spca561.c
index e836e77..c82fd53 100644
--- a/drivers/media/video/gspca/spca561.c
+++ b/drivers/media/video/gspca/spca561.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "spca561"
 
 #include <linux/input.h>
@@ -315,7 +317,7 @@ static void reg_w_val(struct usb_device *dev, __u16 index, __u8 value)
 			      value, index, NULL, 0, 500);
 	PDEBUG(D_USBO, "reg write: 0x%02x:0x%02x", index, value);
 	if (ret < 0)
-		err("reg write: error %d", ret);
+		pr_err("reg write: error %d\n", ret);
 }
 
 static void write_vector(struct gspca_dev *gspca_dev,
diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/video/gspca/sq905.c
index 5ba96af..df805f7 100644
--- a/drivers/media/video/gspca/sq905.c
+++ b/drivers/media/video/gspca/sq905.c
@@ -33,6 +33,8 @@
  * drivers.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sq905"
 
 #include <linux/workqueue.h>
@@ -123,8 +125,7 @@ static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
 			      SQ905_COMMAND, index, gspca_dev->usb_buf, 1,
 			      SQ905_CMD_TIMEOUT);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed (%d)",
-			__func__, ret);
+		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -135,8 +136,7 @@ static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
 			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
 			      SQ905_CMD_TIMEOUT);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed 2 (%d)",
-			__func__, ret);
+		pr_err("%s: usb_control_msg failed 2 (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -158,7 +158,7 @@ static int sq905_ack_frame(struct gspca_dev *gspca_dev)
 			      SQ905_READ_DONE, 0, gspca_dev->usb_buf, 1,
 			      SQ905_CMD_TIMEOUT);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed (%d)", __func__, ret);
+		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -186,7 +186,7 @@ sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size, int need_lock)
 	if (need_lock)
 		mutex_unlock(&gspca_dev->usb_lock);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed (%d)", __func__, ret);
+		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
 		return ret;
 	}
 	ret = usb_bulk_msg(gspca_dev->dev,
@@ -195,8 +195,7 @@ sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size, int need_lock)
 
 	/* successful, it returns 0, otherwise  negative */
 	if (ret < 0 || act_len != size) {
-		err("bulk read fail (%d) len %d/%d",
-			ret, act_len, size);
+		pr_err("bulk read fail (%d) len %d/%d\n", ret, act_len, size);
 		return -EIO;
 	}
 	return 0;
@@ -226,7 +225,7 @@ static void sq905_dostream(struct work_struct *work)
 
 	buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
-		err("Couldn't allocate USB buffer");
+		pr_err("Couldn't allocate USB buffer\n");
 		goto quit_stream;
 	}
 
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index 457563b..c2c0560 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -27,6 +27,8 @@
  * and may contain code fragments from it.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sq905c"
 
 #include <linux/workqueue.h>
@@ -95,8 +97,7 @@ static int sq905c_command(struct gspca_dev *gspca_dev, u16 command, u16 index)
 			      command, index, NULL, 0,
 			      SQ905C_CMD_TIMEOUT);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed (%d)",
-			__func__, ret);
+		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -115,8 +116,7 @@ static int sq905c_read(struct gspca_dev *gspca_dev, u16 command, u16 index,
 			      command, index, gspca_dev->usb_buf, size,
 			      SQ905C_CMD_TIMEOUT);
 	if (ret < 0) {
-		err("%s: usb_control_msg failed (%d)",
-		       __func__, ret);
+		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -146,7 +146,7 @@ static void sq905c_dostream(struct work_struct *work)
 
 	buffer = kmalloc(SQ905C_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
-		err("Couldn't allocate USB buffer");
+		pr_err("Couldn't allocate USB buffer\n");
 		goto quit_stream;
 	}
 
diff --git a/drivers/media/video/gspca/sq930x.c b/drivers/media/video/gspca/sq930x.c
index 8215d5d..e4255b4 100644
--- a/drivers/media/video/gspca/sq930x.c
+++ b/drivers/media/video/gspca/sq930x.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sq930x"
 
 #include "gspca.h"
@@ -468,7 +470,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			value, 0, gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
-		err("reg_r %04x failed %d", value, ret);
+		pr_err("reg_r %04x failed %d\n", value, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -488,7 +490,7 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 			500);
 	msleep(30);
 	if (ret < 0) {
-		err("reg_w %04x %04x failed %d", value, index, ret);
+		pr_err("reg_w %04x %04x failed %d\n", value, index, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -511,7 +513,7 @@ static void reg_wb(struct gspca_dev *gspca_dev, u16 value, u16 index,
 			1000);
 	msleep(30);
 	if (ret < 0) {
-		err("reg_wb %04x %04x failed %d", value, index, ret);
+		pr_err("reg_wb %04x %04x failed %d\n", value, index, ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -556,7 +558,7 @@ static void i2c_write(struct sd *sd,
 			gspca_dev->usb_buf, buf - gspca_dev->usb_buf,
 			500);
 	if (ret < 0) {
-		err("i2c_write failed %d", ret);
+		pr_err("i2c_write failed %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -575,7 +577,7 @@ static void ucbus_write(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if ((batchsize - 1) * 3 > USB_BUF_SZ) {
-		err("Bug: usb_buf overflow");
+		pr_err("Bug: usb_buf overflow\n");
 		gspca_dev->usb_err = -ENOMEM;
 		return;
 	}
@@ -612,7 +614,7 @@ static void ucbus_write(struct gspca_dev *gspca_dev,
 				gspca_dev->usb_buf, buf - gspca_dev->usb_buf,
 				500);
 		if (ret < 0) {
-			err("ucbus_write failed %d", ret);
+			pr_err("ucbus_write failed %d\n", ret);
 			gspca_dev->usb_err = ret;
 			return;
 		}
@@ -688,7 +690,7 @@ static void cmos_probe(struct gspca_dev *gspca_dev)
 			break;
 	}
 	if (i >= ARRAY_SIZE(probe_order)) {
-		err("Unknown sensor");
+		pr_err("Unknown sensor\n");
 		gspca_dev->usb_err = -EINVAL;
 		return;
 	}
@@ -696,7 +698,8 @@ static void cmos_probe(struct gspca_dev *gspca_dev)
 	switch (sd->sensor) {
 	case SENSOR_OV7660:
 	case SENSOR_OV9630:
-		err("Sensor %s not yet treated", sensor_tb[sd->sensor].name);
+		pr_err("Sensor %s not yet treated\n",
+		       sensor_tb[sd->sensor].name);
 		gspca_dev->usb_err = -EINVAL;
 		break;
 	}
@@ -1091,7 +1094,7 @@ static void sd_dq_callback(struct gspca_dev *gspca_dev)
 	gspca_dev->cam.bulk_nurbs = 1;
 	ret = usb_submit_urb(gspca_dev->urb[0], GFP_ATOMIC);
 	if (ret < 0)
-		err("sd_dq_callback() err %d", ret);
+		pr_err("sd_dq_callback() err %d\n", ret);
 
 	/* wait a little time, otherwise the webcam crashes */
 	msleep(100);
diff --git a/drivers/media/video/gspca/stk014.c b/drivers/media/video/gspca/stk014.c
index 7637477..42a7a28 100644
--- a/drivers/media/video/gspca/stk014.c
+++ b/drivers/media/video/gspca/stk014.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "stk014"
 
 #include "gspca.h"
@@ -137,7 +139,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev,
 			gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 		return 0;
 	}
@@ -162,7 +164,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 			0,
 			500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -192,7 +194,7 @@ static void rcv_val(struct gspca_dev *gspca_dev,
 			&alen,
 			500);		/* timeout in milliseconds */
 	if (ret < 0) {
-		err("rcv_val err %d", ret);
+		pr_err("rcv_val err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -235,7 +237,7 @@ static void snd_val(struct gspca_dev *gspca_dev,
 			&alen,
 			500);	/* timeout in milliseconds */
 	if (ret < 0) {
-		err("snd_val err %d", ret);
+		pr_err("snd_val err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	} else {
 		if (ads == 0x003f08) {
@@ -315,7 +317,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	ret = reg_r(gspca_dev, 0x0740);
 	if (gspca_dev->usb_err >= 0) {
 		if (ret != 0xff) {
-			err("init reg: 0x%02x", ret);
+			pr_err("init reg: 0x%02x\n", ret);
 			gspca_dev->usb_err = -EIO;
 		}
 	}
@@ -349,8 +351,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 					gspca_dev->iface,
 					gspca_dev->alt);
 	if (ret < 0) {
-		err("set intf %d %d failed",
-			gspca_dev->iface, gspca_dev->alt);
+		pr_err("set intf %d %d failed\n",
+		       gspca_dev->iface, gspca_dev->alt);
 		gspca_dev->usb_err = ret;
 		goto out;
 	}
diff --git a/drivers/media/video/gspca/stv0680.c b/drivers/media/video/gspca/stv0680.c
index e2ef41c..4dcc7e3 100644
--- a/drivers/media/video/gspca/stv0680.c
+++ b/drivers/media/video/gspca/stv0680.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "stv0680"
 
 #include "gspca.h"
@@ -79,7 +81,7 @@ static int stv_sndctrl(struct gspca_dev *gspca_dev, int set, u8 req, u16 val,
 			      val, 0, gspca_dev->usb_buf, size, 500);
 
 	if ((ret < 0) && (req != 0x0a))
-		err("usb_control_msg error %i, request = 0x%x, error = %i",
+		pr_err("usb_control_msg error %i, request = 0x%x, error = %i\n",
 		       set, req, ret);
 
 	return ret;
@@ -236,7 +238,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	if (stv_sndctrl(gspca_dev, 2, 0x06, 0x0100, 0x12) != 0x12 ||
 	    gspca_dev->usb_buf[8] != 0x53 || gspca_dev->usb_buf[9] != 0x05) {
-		err("Could not get descriptor 0100.");
+		pr_err("Could not get descriptor 0100\n");
 		return stv0680_handle_error(gspca_dev, -EIO);
 	}
 
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/video/gspca/stv06xx/stv06xx.c
index abf1658..b1fca7d 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -27,6 +27,8 @@
  * P/N 861040-0000: Sensor ST VV6410       ASIC STV0610   - QuickCam Web
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/input.h>
 #include "stv06xx_sensor.h"
 
@@ -189,7 +191,7 @@ int stv06xx_read_sensor(struct sd *sd, const u8 address, u16 *value)
 			      0x04, 0x40, 0x1400, 0, buf, I2C_BUFFER_LENGTH,
 			      STV06XX_URB_MSG_TIMEOUT);
 	if (err < 0) {
-		err("I2C: Read error writing address: %d", err);
+		pr_err("I2C: Read error writing address: %d\n", err);
 		return err;
 	}
 
@@ -213,14 +215,14 @@ static void stv06xx_dump_bridge(struct sd *sd)
 	int i;
 	u8 data, buf;
 
-	info("Dumping all stv06xx bridge registers");
+	pr_info("Dumping all stv06xx bridge registers\n");
 	for (i = 0x1400; i < 0x160f; i++) {
 		stv06xx_read_bridge(sd, i, &data);
 
-		info("Read 0x%x from address 0x%x", data, i);
+		pr_info("Read 0x%x from address 0x%x\n", data, i);
 	}
 
-	info("Testing stv06xx bridge registers for writability");
+	pr_info("Testing stv06xx bridge registers for writability\n");
 	for (i = 0x1400; i < 0x160f; i++) {
 		stv06xx_read_bridge(sd, i, &data);
 		buf = data;
@@ -228,12 +230,12 @@ static void stv06xx_dump_bridge(struct sd *sd)
 		stv06xx_write_bridge(sd, i, 0xff);
 		stv06xx_read_bridge(sd, i, &data);
 		if (data == 0xff)
-			info("Register 0x%x is read/write", i);
+			pr_info("Register 0x%x is read/write\n", i);
 		else if (data != buf)
-			info("Register 0x%x is read/write,"
-			     " but only partially", i);
+			pr_info("Register 0x%x is read/write, but only partially\n",
+				i);
 		else
-			info("Register 0x%x is read-only", i);
+			pr_info("Register 0x%x is read-only\n", i);
 
 		stv06xx_write_bridge(sd, i, buf);
 	}
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
index b815685..a8698b7 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
@@ -28,6 +28,8 @@
  * P/N 861040-0000: Sensor ST VV6410       ASIC STV0610   - QuickCam Web
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "stv06xx_hdcs.h"
 
 static const struct ctrl hdcs1x00_ctrl[] = {
@@ -428,7 +430,7 @@ static int hdcs_probe_1x00(struct sd *sd)
 	if (ret < 0 || sensor != 0x08)
 		return -ENODEV;
 
-	info("HDCS-1000/1100 sensor detected");
+	pr_info("HDCS-1000/1100 sensor detected\n");
 
 	sd->gspca_dev.cam.cam_mode = hdcs1x00_mode;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(hdcs1x00_mode);
@@ -487,7 +489,7 @@ static int hdcs_probe_1020(struct sd *sd)
 	if (ret < 0 || sensor != 0x10)
 		return -ENODEV;
 
-	info("HDCS-1020 sensor detected");
+	pr_info("HDCS-1020 sensor detected\n");
 
 	sd->gspca_dev.cam.cam_mode = hdcs1020_mode;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(hdcs1020_mode);
@@ -601,11 +603,11 @@ static int hdcs_dump(struct sd *sd)
 {
 	u16 reg, val;
 
-	info("Dumping sensor registers:");
+	pr_info("Dumping sensor registers:\n");
 
 	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH; reg++) {
 		stv06xx_read_sensor(sd, reg, &val);
-		info("reg 0x%02x = 0x%02x", reg, val);
+		pr_info("reg 0x%02x = 0x%02x\n", reg, val);
 	}
 	return 0;
 }
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
index 75a5b9c..26f14fc 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
@@ -44,6 +44,8 @@
  * PB_CFILLIN       = R5  = 0x0E (14 dec)     : Sets the frame rate
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "stv06xx_pb0100.h"
 
 static const struct ctrl pb0100_ctrl[] = {
@@ -190,7 +192,7 @@ static int pb0100_probe(struct sd *sd)
 		if (!sensor_settings)
 			return -ENOMEM;
 
-		info("Photobit pb0100 sensor detected");
+		pr_info("Photobit pb0100 sensor detected\n");
 
 		sd->gspca_dev.cam.cam_mode = pb0100_mode;
 		sd->gspca_dev.cam.nmodes = ARRAY_SIZE(pb0100_mode);
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
index 8a456de..9940e03 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "stv06xx_st6422.h"
 
 /* controls */
@@ -136,7 +138,7 @@ static int st6422_probe(struct sd *sd)
 	if (sd->bridge != BRIDGE_ST6422)
 		return -ENODEV;
 
-	info("st6422 sensor detected");
+	pr_info("st6422 sensor detected\n");
 
 	sensor_settings = kmalloc(sizeof *sensor_settings, GFP_KERNEL);
 	if (!sensor_settings)
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
index f839843..8489642 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
@@ -27,6 +27,8 @@
  * P/N 861040-0000: Sensor ST VV6410       ASIC STV0610   - QuickCam Web
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "stv06xx_vv6410.h"
 
 static struct v4l2_pix_format vv6410_mode[] = {
@@ -112,7 +114,7 @@ static int vv6410_probe(struct sd *sd)
 		return -ENODEV;
 
 	if (data == 0x19) {
-		info("vv6410 sensor detected");
+		pr_info("vv6410 sensor detected\n");
 
 		sensor_settings = kmalloc(ARRAY_SIZE(vv6410_ctrl) * sizeof(s32),
 					  GFP_KERNEL);
@@ -242,11 +244,11 @@ static int vv6410_dump(struct sd *sd)
 	u8 i;
 	int err = 0;
 
-	info("Dumping all vv6410 sensor registers");
+	pr_info("Dumping all vv6410 sensor registers\n");
 	for (i = 0; i < 0xff && !err; i++) {
 		u16 data;
 		err = stv06xx_read_sensor(sd, i, &data);
-		info("Register 0x%x contained 0x%x", i, data);
+		pr_info("Register 0x%x contained 0x%x\n", i, data);
 	}
 	return (err < 0) ? err : 0;
 }
diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
index 6ec2329..c890977 100644
--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "sunplus"
 
 #include "gspca.h"
@@ -325,7 +327,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
-		err("reg_r: buffer overflow");
+		pr_err("reg_r: buffer overflow\n");
 		return;
 	}
 #endif
@@ -340,7 +342,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			len ? gspca_dev->usb_buf : NULL, len,
 			500);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -365,7 +367,7 @@ static void reg_w_1(struct gspca_dev *gspca_dev,
 			gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_w_1 err %d", ret);
+		pr_err("reg_w_1 err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -385,7 +387,7 @@ static void reg_w_riv(struct gspca_dev *gspca_dev,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index, NULL, 0, 500);
 	if (ret < 0) {
-		err("reg_w_riv err %d", ret);
+		pr_err("reg_w_riv err %d\n", ret);
 		gspca_dev->usb_err = ret;
 		return;
 	}
diff --git a/drivers/media/video/gspca/vc032x.c b/drivers/media/video/gspca/vc032x.c
index 6caed73..7ee2c82 100644
--- a/drivers/media/video/gspca/vc032x.c
+++ b/drivers/media/video/gspca/vc032x.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "vc032x"
 
 #include "gspca.h"
@@ -3169,7 +3171,7 @@ static void reg_r_i(struct gspca_dev *gspca_dev,
 			index, gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
-		err("reg_r err %d", ret);
+		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -3210,7 +3212,7 @@ static void reg_w_i(struct gspca_dev *gspca_dev,
 			value, index, NULL, 0,
 			500);
 	if (ret < 0) {
-		err("reg_w err %d", ret);
+		pr_err("reg_w err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -3235,8 +3237,7 @@ static u16 read_sensor_register(struct gspca_dev *gspca_dev,
 
 	reg_r(gspca_dev, 0xa1, 0xb33f, 1);
 	if (!(gspca_dev->usb_buf[0] & 0x02)) {
-		err("I2c Bus Busy Wait %02x",
-			gspca_dev->usb_buf[0]);
+		pr_err("I2c Bus Busy Wait %02x\n", gspca_dev->usb_buf[0]);
 		return 0;
 	}
 	reg_w(gspca_dev, 0xa0, address, 0xb33a);
@@ -3349,7 +3350,7 @@ static void i2c_write(struct gspca_dev *gspca_dev,
 		msleep(20);
 	} while (--retry > 0);
 	if (retry <= 0)
-		err("i2c_write timeout");
+		pr_err("i2c_write timeout\n");
 }
 
 static void put_tab_to_reg(struct gspca_dev *gspca_dev,
@@ -3446,7 +3447,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	switch (sensor) {
 	case -1:
-		err("Unknown sensor...");
+		pr_err("Unknown sensor...\n");
 		return -EINVAL;
 	case SENSOR_HV7131R:
 		PDEBUG(D_PROBE, "Find Sensor HV7131R");
diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/video/gspca/vicam.c
index 84dfbab..81dd4c9 100644
--- a/drivers/media/video/gspca/vicam.c
+++ b/drivers/media/video/gspca/vicam.c
@@ -26,6 +26,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "vicam"
 #define HEADER_SIZE 64
 
@@ -117,7 +119,7 @@ static int vicam_control_msg(struct gspca_dev *gspca_dev, u8 request,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      value, index, data, len, 1000);
 	if (ret < 0)
-		err("control msg req %02X error %d", request, ret);
+		pr_err("control msg req %02X error %d\n", request, ret);
 
 	return ret;
 }
@@ -189,8 +191,8 @@ static int vicam_read_frame(struct gspca_dev *gspca_dev, u8 *data, int size)
 			   data, size, &act_len, 10000);
 	/* successful, it returns 0, otherwise  negative */
 	if (ret < 0 || act_len != size) {
-		err("bulk read fail (%d) len %d/%d",
-			ret, act_len, size);
+		pr_err("bulk read fail (%d) len %d/%d\n",
+		       ret, act_len, size);
 		return -EIO;
 	}
 	return 0;
@@ -216,7 +218,7 @@ static void vicam_dostream(struct work_struct *work)
 		   HEADER_SIZE;
 	buffer = kmalloc(frame_sz, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
-		err("Couldn't allocate USB buffer");
+		pr_err("Couldn't allocate USB buffer\n");
 		goto exit;
 	}
 
@@ -269,7 +271,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	ret = request_ihex_firmware(&fw, "vicam/firmware.fw",
 				    &gspca_dev->dev->dev);
 	if (ret) {
-		err("Failed to load \"vicam/firmware.fw\": %d\n", ret);
+		pr_err("Failed to load \"vicam/firmware.fw\": %d\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/media/video/gspca/w996Xcf.c b/drivers/media/video/gspca/w996Xcf.c
index 4a9e622..27d2cef 100644
--- a/drivers/media/video/gspca/w996Xcf.c
+++ b/drivers/media/video/gspca/w996Xcf.c
@@ -31,6 +31,8 @@
    the sensor drivers to v4l2 sub drivers, and properly split of this
    driver from ov519.c */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define W9968CF_I2C_BUS_DELAY    4 /* delay in us for I2C bit r/w operations */
 
 #define Y_QUANTABLE (&sd->jpeg_hdr[JPEG_QT0_OFFSET])
@@ -81,7 +83,7 @@ static void w9968cf_write_fsb(struct sd *sd, u16* data)
 			      USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE,
 			      value, 0x06, sd->gspca_dev.usb_buf, 6, 500);
 	if (ret < 0) {
-		err("Write FSB registers failed (%d)", ret);
+		pr_err("Write FSB registers failed (%d)\n", ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 }
@@ -108,7 +110,7 @@ static void w9968cf_write_sb(struct sd *sd, u16 value)
 	udelay(W9968CF_I2C_BUS_DELAY);
 
 	if (ret < 0) {
-		err("Write SB reg [01] %04x failed", value);
+		pr_err("Write SB reg [01] %04x failed\n", value);
 		sd->gspca_dev.usb_err = ret;
 	}
 }
@@ -135,7 +137,7 @@ static int w9968cf_read_sb(struct sd *sd)
 		ret = sd->gspca_dev.usb_buf[0] |
 		      (sd->gspca_dev.usb_buf[1] << 8);
 	} else {
-		err("Read SB reg [01] failed");
+		pr_err("Read SB reg [01] failed\n");
 		sd->gspca_dev.usb_err = ret;
 	}
 
diff --git a/drivers/media/video/gspca/xirlink_cit.c b/drivers/media/video/gspca/xirlink_cit.c
index c089a0f..3aed42a 100644
--- a/drivers/media/video/gspca/xirlink_cit.c
+++ b/drivers/media/video/gspca/xirlink_cit.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "xirlink-cit"
 
 #include <linux/input.h>
@@ -800,8 +802,8 @@ static int cit_write_reg(struct gspca_dev *gspca_dev, u16 value, u16 index)
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT,
 			value, index, NULL, 0, 1000);
 	if (err < 0)
-		err("Failed to write a register (index 0x%04X,"
-			" value 0x%02X, error %d)", index, value, err);
+		pr_err("Failed to write a register (index 0x%04X, value 0x%02X, error %d)\n",
+		       index, value, err);
 
 	return 0;
 }
@@ -816,8 +818,8 @@ static int cit_read_reg(struct gspca_dev *gspca_dev, u16 index, int verbose)
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT,
 			0x00, index, buf, 8, 1000);
 	if (res < 0) {
-		err("Failed to read a register (index 0x%04X, error %d)",
-			index, res);
+		pr_err("Failed to read a register (index 0x%04X, error %d)\n",
+		       index, res);
 		return res;
 	}
 
@@ -1587,7 +1589,7 @@ static int cit_get_packet_size(struct gspca_dev *gspca_dev)
 	intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
 	alt = usb_altnum_to_altsetting(intf, gspca_dev->alt);
 	if (!alt) {
-		err("Couldn't get altsetting");
+		pr_err("Couldn't get altsetting\n");
 		return -EIO;
 	}
 
@@ -2824,7 +2826,7 @@ static int sd_isoc_nego(struct gspca_dev *gspca_dev)
 
 	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
 	if (ret < 0)
-		err("set alt 1 err %d", ret);
+		pr_err("set alt 1 err %d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 61cdd56..9d78fb8 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "zc3xx"
 
 #include <linux/input.h>
@@ -5666,7 +5668,7 @@ static u8 reg_r_i(struct gspca_dev *gspca_dev,
 			index, gspca_dev->usb_buf, 1,
 			500);
 	if (ret < 0) {
-		err("reg_r_i err %d", ret);
+		pr_err("reg_r_i err %d\n", ret);
 		gspca_dev->usb_err = ret;
 		return 0;
 	}
@@ -5698,7 +5700,7 @@ static void reg_w_i(struct gspca_dev *gspca_dev,
 			value, index, NULL, 0,
 			500);
 	if (ret < 0) {
-		err("reg_w_i err %d", ret);
+		pr_err("reg_w_i err %d\n", ret);
 		gspca_dev->usb_err = ret;
 	}
 }
@@ -5724,7 +5726,7 @@ static u16 i2c_read(struct gspca_dev *gspca_dev,
 	msleep(20);
 	retbyte = reg_r_i(gspca_dev, 0x0091);		/* read status */
 	if (retbyte != 0x00)
-		err("i2c_r status error %02x", retbyte);
+		pr_err("i2c_r status error %02x\n", retbyte);
 	retval = reg_r_i(gspca_dev, 0x0095);		/* read Lowbyte */
 	retval |= reg_r_i(gspca_dev, 0x0096) << 8;	/* read Hightbyte */
 	PDEBUG(D_USBI, "i2c r [%02x] -> %04x (%02x)",
@@ -5748,7 +5750,7 @@ static u8 i2c_write(struct gspca_dev *gspca_dev,
 	msleep(1);
 	retbyte = reg_r_i(gspca_dev, 0x0091);		/* read status */
 	if (retbyte != 0x00)
-		err("i2c_w status error %02x", retbyte);
+		pr_err("i2c_w status error %02x\n", retbyte);
 	PDEBUG(D_USBO, "i2c w [%02x] = %02x%02x (%02x)",
 			reg, valH, valL, retbyte);
 	return retbyte;
@@ -6497,7 +6499,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 				PDEBUG(D_PROBE, "Sensor GC0303");
 				break;
 			default:
-				warn("Unknown sensor - set to TAS5130C");
+				pr_warn("Unknown sensor - set to TAS5130C\n");
 				sd->sensor = SENSOR_TAS5130C;
 			}
 			break;
@@ -6603,7 +6605,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			sd->sensor = SENSOR_OV7620;	/* same sensor (?) */
 			break;
 		default:
-			err("Unknown sensor %04x", sensor);
+			pr_err("Unknown sensor %04x\n", sensor);
 			return -EINVAL;
 		}
 	}
-- 
1.7.6.405.gc1be0

