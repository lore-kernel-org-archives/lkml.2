Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1BKMga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:36:30 -0500
Received: from ni.piap.pl ([195.187.100.4]:40239 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1BKMg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:36:28 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:36:27 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m3zkq2px2s.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 6/7] Solo6x10: Stripped "solo6010-" from file names.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports both Solo-6010 and Solo-6110 chips anyway.
Renamed solo6010.h -> solo6x10.h.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/Makefile b/drivers/staging/solo6x10/Makefile
index 1616b55..72816cf 100644
--- a/drivers/staging/solo6x10/Makefile
+++ b/drivers/staging/solo6x10/Makefile
@@ -1,6 +1,3 @@
-solo6x10-y	:= solo6010-core.o solo6010-i2c.o solo6010-p2m.o \
-		   solo6010-v4l2.o solo6010-tw28.o solo6010-gpio.o \
-		   solo6010-disp.o solo6010-enc.o solo6010-v4l2-enc.o \
-		   solo6010-g723.o
+solo6x10-y := core.o i2c.o p2m.o v4l2.o tw28.o gpio.o disp.o enc.o v4l2-enc.o g723.o
 
 obj-$(CONFIG_SOLO6X10) := solo6x10.o
diff --git a/drivers/staging/solo6x10/solo6010-core.c b/drivers/staging/solo6x10/core.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-core.c
rename to drivers/staging/solo6x10/core.c
index c713a74..37e6fda 100644
--- a/drivers/staging/solo6x10/solo6010-core.c
+++ b/drivers/staging/solo6x10/core.c
@@ -22,9 +22,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
-
-#include "solo6010.h"
-#include "solo6010-tw28.h"
+#include "solo6x10.h"
+#include "tw28.h"
 
 MODULE_DESCRIPTION("Softlogic 6010 MP4 Encoder/Decoder V4L2/ALSA Driver");
 MODULE_AUTHOR("Ben Collins <bcollins@bluecherry.net>");
diff --git a/drivers/staging/solo6x10/solo6010-disp.c b/drivers/staging/solo6x10/disp.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-disp.c
rename to drivers/staging/solo6x10/disp.c
index 99d1461..1b0cfa8 100644
--- a/drivers/staging/solo6x10/solo6010-disp.c
+++ b/drivers/staging/solo6x10/disp.c
@@ -21,8 +21,7 @@
 #include <linux/module.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
-
-#include "solo6010.h"
+#include "solo6x10.h"
 
 #define SOLO_VCLK_DELAY			3
 #define SOLO_PROGRESSIVE_VSIZE		1024
diff --git a/drivers/staging/solo6x10/solo6010-enc.c b/drivers/staging/solo6x10/enc.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-enc.c
rename to drivers/staging/solo6x10/enc.c
index 7a3c4d5..755626c 100644
--- a/drivers/staging/solo6x10/solo6010-enc.c
+++ b/drivers/staging/solo6x10/enc.c
@@ -18,9 +18,8 @@
  */
 
 #include <linux/kernel.h>
-
-#include "solo6010.h"
-#include "solo6010-osd-font.h"
+#include "solo6x10.h"
+#include "osd-font.h"
 
 #define CAPTURE_MAX_BANDWIDTH		32	/* D1 4channel (D1 == 4) */
 #define OSG_BUFFER_SIZE			1024
diff --git a/drivers/staging/solo6x10/solo6010-g723.c b/drivers/staging/solo6x10/g723.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-g723.c
rename to drivers/staging/solo6x10/g723.c
index 254b46a..4aba8f3 100644
--- a/drivers/staging/solo6x10/solo6010-g723.c
+++ b/drivers/staging/solo6x10/g723.c
@@ -22,14 +22,12 @@
 #include <linux/poll.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
 #include <sound/control.h>
-
-#include "solo6010.h"
-#include "solo6010-tw28.h"
+#include "solo6x10.h"
+#include "tw28.h"
 
 #define G723_INTR_ORDER		0
 #define G723_FDMA_PAGES		32
diff --git a/drivers/staging/solo6x10/solo6010-gpio.c b/drivers/staging/solo6x10/gpio.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-gpio.c
rename to drivers/staging/solo6x10/gpio.c
index 8869b88..efd88ba 100644
--- a/drivers/staging/solo6x10/solo6010-gpio.c
+++ b/drivers/staging/solo6x10/gpio.c
@@ -20,8 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <asm/uaccess.h>
-
-#include "solo6010.h"
+#include "solo6x10.h"
 
 static void solo_gpio_mode(struct solo6010_dev *solo_dev,
 			   unsigned int port_mask, unsigned int mode)
diff --git a/drivers/staging/solo6x10/solo6010-i2c.c b/drivers/staging/solo6x10/i2c.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-i2c.c
rename to drivers/staging/solo6x10/i2c.c
index 60b69cd..fba4247 100644
--- a/drivers/staging/solo6x10/solo6010-i2c.c
+++ b/drivers/staging/solo6x10/i2c.c
@@ -26,8 +26,7 @@
  * thread context, ACK the interrupt, and move on. -- BenC */
 
 #include <linux/kernel.h>
-
-#include "solo6010.h"
+#include "solo6x10.h"
 
 u8 solo_i2c_readbyte(struct solo6010_dev *solo_dev, int id, u8 addr, u8 off)
 {
diff --git a/drivers/staging/solo6x10/solo6010-jpeg.h b/drivers/staging/solo6x10/jpeg.h
similarity index 100%
rename from drivers/staging/solo6x10/solo6010-jpeg.h
rename to drivers/staging/solo6x10/jpeg.h
diff --git a/drivers/staging/solo6x10/solo6010-offsets.h b/drivers/staging/solo6x10/offsets.h
similarity index 100%
rename from drivers/staging/solo6x10/solo6010-offsets.h
rename to drivers/staging/solo6x10/offsets.h
diff --git a/drivers/staging/solo6x10/solo6010-osd-font.h b/drivers/staging/solo6x10/osd-font.h
similarity index 100%
rename from drivers/staging/solo6x10/solo6010-osd-font.h
rename to drivers/staging/solo6x10/osd-font.h
diff --git a/drivers/staging/solo6x10/solo6010-p2m.c b/drivers/staging/solo6x10/p2m.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-p2m.c
rename to drivers/staging/solo6x10/p2m.c
index 90de963..1b88d10 100644
--- a/drivers/staging/solo6x10/solo6010-p2m.c
+++ b/drivers/staging/solo6x10/p2m.c
@@ -19,8 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
-
-#include "solo6010.h"
+#include "solo6x10.h"
 
 /* #define SOLO_TEST_P2M */
 
diff --git a/drivers/staging/solo6x10/solo6010-registers.h b/drivers/staging/solo6x10/registers.h
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-registers.h
rename to drivers/staging/solo6x10/registers.h
index db291bf..edf77e8 100644
--- a/drivers/staging/solo6x10/solo6010-registers.h
+++ b/drivers/staging/solo6x10/registers.h
@@ -20,7 +20,7 @@
 #ifndef __SOLO6010_REGISTERS_H
 #define __SOLO6010_REGISTERS_H
 
-#include "solo6010-offsets.h"
+#include "offsets.h"
 
 /* Global 6010 system configuration */
 #define SOLO_SYS_CFG				0x0000
diff --git a/drivers/staging/solo6x10/solo6010.h b/drivers/staging/solo6x10/solo6x10.h
similarity index 99%
rename from drivers/staging/solo6x10/solo6010.h
rename to drivers/staging/solo6x10/solo6x10.h
index 4532e12..1730f4d 100644
--- a/drivers/staging/solo6x10/solo6010.h
+++ b/drivers/staging/solo6x10/solo6x10.h
@@ -30,12 +30,10 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
-
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
-
-#include "solo6010-registers.h"
+#include "registers.h"
 
 #ifndef PCI_VENDOR_ID_SOFTLOGIC
 #define PCI_VENDOR_ID_SOFTLOGIC		0x9413
diff --git a/drivers/staging/solo6x10/solo6010-tw28.c b/drivers/staging/solo6x10/tw28.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-tw28.c
rename to drivers/staging/solo6x10/tw28.c
index 905a6ad..0f3d1e4 100644
--- a/drivers/staging/solo6x10/solo6010-tw28.c
+++ b/drivers/staging/solo6x10/tw28.c
@@ -18,9 +18,8 @@
  */
 
 #include <linux/kernel.h>
-
-#include "solo6010.h"
-#include "solo6010-tw28.h"
+#include "solo6x10.h"
+#include "tw28.h"
 
 /* XXX: Some of these values are masked into an 8-bit regs, and shifted
  * around for other 8-bit regs. What are the magic bits in these values? */
diff --git a/drivers/staging/solo6x10/solo6010-tw28.h b/drivers/staging/solo6x10/tw28.h
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-tw28.h
rename to drivers/staging/solo6x10/tw28.h
index a7eecfa..4862ac9 100644
--- a/drivers/staging/solo6x10/solo6010-tw28.h
+++ b/drivers/staging/solo6x10/tw28.h
@@ -20,7 +20,7 @@
 #ifndef __SOLO6010_TW28_H
 #define __SOLO6010_TW28_H
 
-#include "solo6010.h"
+#include "solo6x10.h"
 
 #define TW_NUM_CHIP				4
 #define TW_BASE_ADDR				0x28
diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/v4l2-enc.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-v4l2-enc.c
rename to drivers/staging/solo6x10/v4l2-enc.c
index 619fb9b..4c8d62d 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/v4l2-enc.c
@@ -21,14 +21,12 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-dma-sg.h>
-
-#include "solo6010.h"
-#include "solo6010-tw28.h"
-#include "solo6010-jpeg.h"
+#include "solo6x10.h"
+#include "tw28.h"
+#include "jpeg.h"
 
 #define MIN_VID_BUFFERS		4
 #define FRAME_BUF_SIZE		(128 * 1024)
diff --git a/drivers/staging/solo6x10/solo6010-v4l2.c b/drivers/staging/solo6x10/v4l2.c
similarity index 99%
rename from drivers/staging/solo6x10/solo6010-v4l2.c
rename to drivers/staging/solo6x10/v4l2.c
index 4e24e92..e9d620a 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2.c
+++ b/drivers/staging/solo6x10/v4l2.c
@@ -21,13 +21,11 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-dma-sg.h>
-
-#include "solo6010.h"
-#include "solo6010-tw28.h"
+#include "solo6x10.h"
+#include "tw28.h"
 
 #define SOLO_HW_BPL		2048
 #define SOLO_DISP_PIX_FIELD	V4L2_FIELD_INTERLACED

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
