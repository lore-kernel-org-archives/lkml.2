Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1HOFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:09:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33968 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1HOFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:50 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/11] drivers/media: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:08 -0400
Message-Id: <1313384834-24433-6-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/common/tuners/Makefile       |    4 ++--
 drivers/media/dvb/b2c2/Makefile            |    4 ++--
 drivers/media/dvb/bt8xx/Makefile           |    8 ++++----
 drivers/media/dvb/ddbridge/Makefile        |    8 ++++----
 drivers/media/dvb/dm1105/Makefile          |    2 +-
 drivers/media/dvb/dvb-usb/Makefile         |    4 ++--
 drivers/media/dvb/frontends/Makefile       |    4 ++--
 drivers/media/dvb/mantis/Makefile          |    2 +-
 drivers/media/dvb/ngene/Makefile           |    8 ++++----
 drivers/media/dvb/pluto2/Makefile          |    2 +-
 drivers/media/dvb/pt1/Makefile             |    2 +-
 drivers/media/dvb/siano/Makefile           |    4 ++--
 drivers/media/dvb/ttpci/Makefile           |    4 ++--
 drivers/media/dvb/ttusb-budget/Makefile    |    2 +-
 drivers/media/dvb/ttusb-dec/Makefile       |    2 +-
 drivers/media/radio/Makefile               |    2 +-
 drivers/media/video/Makefile               |    6 +++---
 drivers/media/video/au0828/Makefile        |    8 ++++----
 drivers/media/video/bt8xx/Makefile         |    6 +++---
 drivers/media/video/cx18/Makefile          |    6 +++---
 drivers/media/video/cx231xx/Makefile       |   10 +++++-----
 drivers/media/video/cx23885/Makefile       |   10 +++++-----
 drivers/media/video/cx25840/Makefile       |    2 +-
 drivers/media/video/cx88/Makefile          |    8 ++++----
 drivers/media/video/em28xx/Makefile        |    8 ++++----
 drivers/media/video/gspca/gl860/Makefile   |    2 +-
 drivers/media/video/gspca/m5602/Makefile   |    2 +-
 drivers/media/video/gspca/stv06xx/Makefile |    2 +-
 drivers/media/video/hdpvr/Makefile         |    4 ++--
 drivers/media/video/ivtv/Makefile          |    8 ++++----
 drivers/media/video/omap3isp/Makefile      |    4 +---
 drivers/media/video/pvrusb2/Makefile       |    8 ++++----
 drivers/media/video/saa7134/Makefile       |    8 ++++----
 drivers/media/video/saa7164/Makefile       |   10 +++++-----
 drivers/media/video/tlg2300/Makefile       |    8 ++++----
 drivers/media/video/usbvision/Makefile     |    4 ++--
 36 files changed, 92 insertions(+), 94 deletions(-)

diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 20d24fc..196c12a 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -28,5 +28,5 @@ obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/b2c2/Makefile b/drivers/media/dvb/b2c2/Makefile
index b97cf72..3d04a8d 100644
--- a/drivers/media/dvb/b2c2/Makefile
+++ b/drivers/media/dvb/b2c2/Makefile
@@ -12,5 +12,5 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 b2c2-flexcop-usb-objs = flexcop-usb.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/media/dvb/bt8xx/Makefile b/drivers/media/dvb/bt8xx/Makefile
index d98f1d4..0713b3a 100644
--- a/drivers/media/dvb/bt8xx/Makefile
+++ b/drivers/media/dvb/bt8xx/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/video/bt8xx
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video/bt8xx
+ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/dvb/ddbridge/Makefile
index de4fe19..cf7214e 100644
--- a/drivers/media/dvb/ddbridge/Makefile
+++ b/drivers/media/dvb/ddbridge/Makefile
@@ -6,9 +6,9 @@ ddbridge-objs := ddbridge-core.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
-EXTRA_CFLAGS += -Idrivers/staging/cxd2099/
+ccflags-y += -Idrivers/staging/cxd2099/
diff --git a/drivers/media/dvb/dm1105/Makefile b/drivers/media/dvb/dm1105/Makefile
index 8ac28b0..95a008b 100644
--- a/drivers/media/dvb/dm1105/Makefile
+++ b/drivers/media/dvb/dm1105/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_DM1105) += dm1105.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 4bac13d..327613f 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -94,7 +94,7 @@ obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
 dvb-usb-technisat-usb2-objs = technisat-usb2.o
 obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 # due to tuner-xc3028
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/common/tuners
 
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 6a6ba05..ed91c01 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -2,8 +2,8 @@
 # Makefile for the kernel DVB frontend device drivers.
 #
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/common/tuners/
 
 stb0899-objs = stb0899_drv.o stb0899_algo.o
 stv0900-objs = stv0900_core.o stv0900_sw.o
diff --git a/drivers/media/dvb/mantis/Makefile b/drivers/media/dvb/mantis/Makefile
index 98dc5cd..ec8116d 100644
--- a/drivers/media/dvb/mantis/Makefile
+++ b/drivers/media/dvb/mantis/Makefile
@@ -25,4 +25,4 @@ obj-$(CONFIG_MANTIS_CORE)	+= mantis_core.o
 obj-$(CONFIG_DVB_MANTIS)	+= mantis.o
 obj-$(CONFIG_DVB_HOPPER)	+= hopper.o
 
-EXTRA_CFLAGS = -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index 2bc9687..8987361 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -6,9 +6,9 @@ ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 
 obj-$(CONFIG_DVB_NGENE) += ngene.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
-EXTRA_CFLAGS += -Idrivers/staging/cxd2099/
+ccflags-y += -Idrivers/staging/cxd2099/
diff --git a/drivers/media/dvb/pluto2/Makefile b/drivers/media/dvb/pluto2/Makefile
index 7ac1287..7008223 100644
--- a/drivers/media/dvb/pluto2/Makefile
+++ b/drivers/media/dvb/pluto2/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_PLUTO2) += pluto2.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/pt1/Makefile b/drivers/media/dvb/pt1/Makefile
index a66da17..d80d8e8 100644
--- a/drivers/media/dvb/pt1/Makefile
+++ b/drivers/media/dvb/pt1/Makefile
@@ -2,4 +2,4 @@ earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
 
 obj-$(CONFIG_DVB_PT1) += earth-pt1.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/siano/Makefile b/drivers/media/dvb/siano/Makefile
index c54140b..f233b57 100644
--- a/drivers/media/dvb/siano/Makefile
+++ b/drivers/media/dvb/siano/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
 obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/dvb-core
 
-EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
 
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
index 8a4d5bb..f6e8693 100644
--- a/drivers/media/dvb/ttpci/Makefile
+++ b/drivers/media/dvb/ttpci/Makefile
@@ -17,5 +17,5 @@ obj-$(CONFIG_DVB_BUDGET_CI) += budget-ci.o
 obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ttusb-budget/Makefile b/drivers/media/dvb/ttusb-budget/Makefile
index fbe2b95..8d6c4ac 100644
--- a/drivers/media/dvb/ttusb-budget/Makefile
+++ b/drivers/media/dvb/ttusb-budget/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_TTUSB_BUDGET) += dvb-ttusb-budget.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/ttusb-dec/Makefile b/drivers/media/dvb/ttusb-dec/Makefile
index 2d70a82..ed28b53 100644
--- a/drivers/media/dvb/ttusb-dec/Makefile
+++ b/drivers/media/dvb/ttusb-dec/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_TTUSB_DEC) += ttusb_dec.o ttusbdecfe.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb/dvb-core/
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index f484a6e..390daf9 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -27,4 +27,4 @@ obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
 obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
 obj-$(CONFIG_RADIO_WL128X) += wl128x/
 
-EXTRA_CFLAGS += -Isound
+ccflags-y += -Isound
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2723900..c06f515 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -190,6 +190,6 @@ obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/video/au0828/Makefile
index 5c7f2f7..bd22223 100644
--- a/drivers/media/video/au0828/Makefile
+++ b/drivers/media/video/au0828/Makefile
@@ -2,8 +2,8 @@ au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o au0828-vid
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
-EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/bt8xx/Makefile b/drivers/media/video/bt8xx/Makefile
index e415f6f..3f9a2b2 100644
--- a/drivers/media/video/bt8xx/Makefile
+++ b/drivers/media/video/bt8xx/Makefile
@@ -8,6 +8,6 @@ bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
 
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/video/cx18/Makefile
index 2fadd9d..a86bab5 100644
--- a/drivers/media/video/cx18/Makefile
+++ b/drivers/media/video/cx18/Makefile
@@ -8,6 +8,6 @@ cx18-alsa-objs := cx18-alsa-main.o cx18-alsa-pcm.o
 obj-$(CONFIG_VIDEO_CX18) += cx18.o
 obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index 2c24843..b334897 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -8,9 +8,9 @@ obj-$(CONFIG_VIDEO_CX231XX) += cx231xx.o
 obj-$(CONFIG_VIDEO_CX231XX_ALSA) += cx231xx-alsa.o
 obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-usb
 
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index 23293c7..185cc01 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -7,9 +7,9 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
-EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/cx25840/Makefile b/drivers/media/video/cx25840/Makefile
index 2ee96d3..dc40dde 100644
--- a/drivers/media/video/cx25840/Makefile
+++ b/drivers/media/video/cx25840/Makefile
@@ -3,4 +3,4 @@ cx25840-objs    := cx25840-core.o cx25840-audio.o cx25840-firmware.o \
 
 obj-$(CONFIG_VIDEO_CX25840) += cx25840.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
+ccflags-y += -Idrivers/media/video
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 5b7e267..c1a2785 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index 38aaa00..2abdf76 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -9,8 +9,8 @@ obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
 obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
diff --git a/drivers/media/video/gspca/gl860/Makefile b/drivers/media/video/gspca/gl860/Makefile
index 13c9403..f511ecc 100644
--- a/drivers/media/video/gspca/gl860/Makefile
+++ b/drivers/media/video/gspca/gl860/Makefile
@@ -6,5 +6,5 @@ gspca_gl860-objs := gl860.o \
 		    gl860-ov9655.o \
 		    gl860-mi2020.o
 
-EXTRA_CFLAGS += -Idrivers/media/video/gspca
+ccflags-y += -Idrivers/media/video/gspca
 
diff --git a/drivers/media/video/gspca/m5602/Makefile b/drivers/media/video/gspca/m5602/Makefile
index bf7a19a..7f52961 100644
--- a/drivers/media/video/gspca/m5602/Makefile
+++ b/drivers/media/video/gspca/m5602/Makefile
@@ -8,4 +8,4 @@ gspca_m5602-objs := m5602_core.o \
 		    m5602_s5k83a.o \
 		    m5602_s5k4aa.o
 
-EXTRA_CFLAGS += -Idrivers/media/video/gspca
+ccflags-y += -Idrivers/media/video/gspca
diff --git a/drivers/media/video/gspca/stv06xx/Makefile b/drivers/media/video/gspca/stv06xx/Makefile
index 2f3c3a6..5b318fa 100644
--- a/drivers/media/video/gspca/stv06xx/Makefile
+++ b/drivers/media/video/gspca/stv06xx/Makefile
@@ -6,5 +6,5 @@ gspca_stv06xx-objs := stv06xx.o \
 		      stv06xx_pb0100.o \
 		      stv06xx_st6422.o
 
-EXTRA_CFLAGS += -Idrivers/media/video/gspca
+ccflags-y += -Idrivers/media/video/gspca
 
diff --git a/drivers/media/video/hdpvr/Makefile b/drivers/media/video/hdpvr/Makefile
index 3baa9f6..52f057f 100644
--- a/drivers/media/video/hdpvr/Makefile
+++ b/drivers/media/video/hdpvr/Makefile
@@ -2,6 +2,6 @@ hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o hdpvr-i2c.o
 
 obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
+ccflags-y += -Idrivers/media/video
 
-EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index 26ce0d6..71ab76a 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -7,8 +7,8 @@ ivtv-objs	:= ivtv-routing.o ivtv-cards.o ivtv-controls.o \
 obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
diff --git a/drivers/media/video/omap3isp/Makefile b/drivers/media/video/omap3isp/Makefile
index b1b34477..e8847e7 100644
--- a/drivers/media/video/omap3isp/Makefile
+++ b/drivers/media/video/omap3isp/Makefile
@@ -1,8 +1,6 @@
 # Makefile for OMAP3 ISP driver
 
-ifdef CONFIG_VIDEO_OMAP3_DEBUG
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG) += -DDEBUG
 
 omap3-isp-objs += \
 	isp.o ispqueue.o ispvideo.o \
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/video/pvrusb2/Makefile
index de2fc14..c17f37d 100644
--- a/drivers/media/video/pvrusb2/Makefile
+++ b/drivers/media/video/pvrusb2/Makefile
@@ -16,7 +16,7 @@ pvrusb2-objs	:= pvrusb2-i2c-core.o \
 
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 8a5ff4d..a646ccf 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/video/saa7164/Makefile
index 6303a8e..ecd5811 100644
--- a/drivers/media/video/saa7164/Makefile
+++ b/drivers/media/video/saa7164/Makefile
@@ -4,9 +4,9 @@ saa7164-objs	:= saa7164-cards.o saa7164-core.o saa7164-i2c.o saa7164-dvb.o \
 
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
-EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
+ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
index 81bb7fd..ea09b9a 100644
--- a/drivers/media/video/tlg2300/Makefile
+++ b/drivers/media/video/tlg2300/Makefile
@@ -2,8 +2,8 @@ poseidon-objs := pd-video.o pd-alsa.o pd-dvb.o pd-radio.o pd-main.o
 
 obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
 
diff --git a/drivers/media/video/usbvision/Makefile b/drivers/media/video/usbvision/Makefile
index 3387187..aea1e3b 100644
--- a/drivers/media/video/usbvision/Makefile
+++ b/drivers/media/video/usbvision/Makefile
@@ -2,5 +2,5 @@ usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
-- 
1.7.6.153.g78432

