Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0IZVCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:02:16 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:57768 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932424Ab0IZVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:02:12 -0400
From: matt mooney <mfm@muteddisk.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [RFC PATCH] media: consolidation of -I flags
Date: Sun, 26 Sep 2010 14:00:47 -0700
Message-Id: <1285534847-31463-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been doing cleanup of makefiles, namely replacing the older style
compilation flag variables with the newer style. While doing this, I
noticed that the majority of drivers in the media subsystem seem to rely
on a few core header files:

	-Idrivers/media/video
	-Idrivers/media/common/tuners
	-Idrivers/media/dvb/dvb-core
	-Idrivers/media/dvb/frontends

This patch removes them from the individual makefiles and puts them in
the main makefile under media. Now I realize that not all of the drivers
depend on these includes, but most do, and almost everything under video
is already being built with these as it is. I can think of a few reasons
why this might not be considered a _great_ idea; nevertheless, I still
would like to see what everyone else thinks.

As an alternative, there could be a split division that does not include
the entire media subsystem. Instead, the main makefiles under dvb and
video could be modified to handle the needed include flags.

	dvb/Makefile:
		subdir-ccflags-y += -Idrivers/media/common/tuners
		subdir-ccflags-y += -Idrivers/media/dvb/dvb-core
		subdir-ccflags-y += -Idrivers/media/dvb/frontends
		...

	video/Makefile:
		subdir-ccflags-y := -Idrivers/media/video
		subdir-ccflags-y += -Idrivers/media/common/tuners
		subdir-ccflags-y += -Idrivers/media/dvb/dvb-core
		subdir-ccflags-y += -Idrivers/media/dvb/frontends
		...

If neither idea is considered beneficial, I will go ahead and replace
the older variables with the newer ones as is.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/media/Makefile                  |    5 +++++
 drivers/media/common/tuners/Makefile    |    3 ---
 drivers/media/dvb/b2c2/Makefile         |    3 ---
 drivers/media/dvb/bt8xx/Makefile        |    3 ---
 drivers/media/dvb/dm1105/Makefile       |    2 --
 drivers/media/dvb/dvb-usb/Makefile      |    5 -----
 drivers/media/dvb/firewire/Makefile     |    1 -
 drivers/media/dvb/frontends/Makefile    |    3 ---
 drivers/media/dvb/mantis/Makefile       |    2 --
 drivers/media/dvb/ngene/Makefile        |    4 ----
 drivers/media/dvb/pluto2/Makefile       |    2 --
 drivers/media/dvb/pt1/Makefile          |    2 --
 drivers/media/dvb/siano/Makefile        |    2 --
 drivers/media/dvb/ttpci/Makefile        |    3 ---
 drivers/media/dvb/ttusb-budget/Makefile |    2 --
 drivers/media/dvb/ttusb-dec/Makefile    |    2 --
 drivers/media/video/Makefile            |    4 ----
 drivers/media/video/au0828/Makefile     |    4 ----
 drivers/media/video/bt8xx/Makefile      |    4 ----
 drivers/media/video/cx18/Makefile       |    4 ----
 drivers/media/video/cx231xx/Makefile    |    6 ------
 drivers/media/video/cx23885/Makefile    |    5 -----
 drivers/media/video/cx25840/Makefile    |    2 --
 drivers/media/video/cx88/Makefile       |    5 -----
 drivers/media/video/em28xx/Makefile     |    6 ------
 drivers/media/video/hdpvr/Makefile      |    2 --
 drivers/media/video/ivtv/Makefile       |    6 ------
 drivers/media/video/pvrusb2/Makefile    |    5 -----
 drivers/media/video/saa7134/Makefile    |    5 -----
 drivers/media/video/saa7164/Makefile    |    5 -----
 drivers/media/video/tlg2300/Makefile    |    6 ------
 drivers/media/video/usbvision/Makefile  |    3 ---
 32 files changed, 5 insertions(+), 111 deletions(-)

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 499b081..f271ea9 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,6 +2,11 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+subdir-ccflags-y := -Idrivers/media/video
+subdir-ccflags-y += -Idrivers/media/common/tuners
+subdir-ccflags-y += -Idrivers/media/dvb/dvb-core
+subdir-ccflags-y += -Idrivers/media/dvb/frontends
+
 obj-y += common/ IR/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index a543852..f6b1358 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -24,6 +24,3 @@ obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
 obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
 obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/b2c2/Makefile b/drivers/media/dvb/b2c2/Makefile
index b97cf72..bd2920e 100644
--- a/drivers/media/dvb/b2c2/Makefile
+++ b/drivers/media/dvb/b2c2/Makefile
@@ -11,6 +11,3 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 
 b2c2-flexcop-usb-objs = flexcop-usb.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
diff --git a/drivers/media/dvb/bt8xx/Makefile b/drivers/media/dvb/bt8xx/Makefile
index d98f1d4..aee7fa5 100644
--- a/drivers/media/dvb/bt8xx/Makefile
+++ b/drivers/media/dvb/bt8xx/Makefile
@@ -1,6 +1,3 @@
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/video/bt8xx
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/dm1105/Makefile b/drivers/media/dvb/dm1105/Makefile
index 8ac28b0..7a14876 100644
--- a/drivers/media/dvb/dm1105/Makefile
+++ b/drivers/media/dvb/dm1105/Makefile
@@ -1,3 +1 @@
 obj-$(CONFIG_DVB_DM1105) += dm1105.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 1a19245..ebadf24 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -87,8 +87,3 @@ obj-$(CONFIG_DVB_USB_EC168) += dvb-usb-ec168.o
 
 dvb-usb-az6027-objs = az6027.o
 obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-# due to tuner-xc3028
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-
diff --git a/drivers/media/dvb/firewire/Makefile b/drivers/media/dvb/firewire/Makefile
index da84203..d1f630d 100644
--- a/drivers/media/dvb/firewire/Makefile
+++ b/drivers/media/dvb/firewire/Makefile
@@ -5,5 +5,4 @@ firedtv-$(CONFIG_DVB_FIREDTV_FIREWIRE) += firedtv-fw.o
 firedtv-$(CONFIG_DVB_FIREDTV_IEEE1394) += firedtv-1394.o
 firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
 ccflags-$(CONFIG_DVB_FIREDTV_IEEE1394) += -Idrivers/ieee1394
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 874e8ad..b33985e 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -2,9 +2,6 @@
 # Makefile for the kernel DVB frontend device drivers.
 #
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
-
 s921-objs := s921_module.o s921_core.o
 stb0899-objs = stb0899_drv.o stb0899_algo.o
 stv0900-objs = stv0900_core.o stv0900_sw.o
diff --git a/drivers/media/dvb/mantis/Makefile b/drivers/media/dvb/mantis/Makefile
index 98dc5cd..36fab01 100644
--- a/drivers/media/dvb/mantis/Makefile
+++ b/drivers/media/dvb/mantis/Makefile
@@ -24,5 +24,3 @@ hopper-objs	:=	hopper_cards.o	\
 obj-$(CONFIG_MANTIS_CORE)	+= mantis_core.o
 obj-$(CONFIG_DVB_MANTIS)	+= mantis.o
 obj-$(CONFIG_DVB_HOPPER)	+= hopper.o
-
-EXTRA_CFLAGS = -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index 0608aab..4f00354 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -5,7 +5,3 @@
 ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 
 obj-$(CONFIG_DVB_NGENE) += ngene.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
diff --git a/drivers/media/dvb/pluto2/Makefile b/drivers/media/dvb/pluto2/Makefile
index 7ac1287..39032b7 100644
--- a/drivers/media/dvb/pluto2/Makefile
+++ b/drivers/media/dvb/pluto2/Makefile
@@ -1,3 +1 @@
 obj-$(CONFIG_DVB_PLUTO2) += pluto2.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/pt1/Makefile b/drivers/media/dvb/pt1/Makefile
index a66da17..69a3dfc 100644
--- a/drivers/media/dvb/pt1/Makefile
+++ b/drivers/media/dvb/pt1/Makefile
@@ -1,5 +1,3 @@
 earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
 
 obj-$(CONFIG_DVB_PT1) += earth-pt1.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/siano/Makefile b/drivers/media/dvb/siano/Makefile
index c54140b..eed4478 100644
--- a/drivers/media/dvb/siano/Makefile
+++ b/drivers/media/dvb/siano/Makefile
@@ -5,7 +5,5 @@ obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
 obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
 obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
 
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
index 8a4d5bb..bab68bc 100644
--- a/drivers/media/dvb/ttpci/Makefile
+++ b/drivers/media/dvb/ttpci/Makefile
@@ -16,6 +16,3 @@ obj-$(CONFIG_DVB_BUDGET_AV) += budget-av.o
 obj-$(CONFIG_DVB_BUDGET_CI) += budget-ci.o
 obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ttusb-budget/Makefile b/drivers/media/dvb/ttusb-budget/Makefile
index fbe2b95..010d056 100644
--- a/drivers/media/dvb/ttusb-budget/Makefile
+++ b/drivers/media/dvb/ttusb-budget/Makefile
@@ -1,3 +1 @@
 obj-$(CONFIG_DVB_TTUSB_BUDGET) += dvb-ttusb-budget.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends
diff --git a/drivers/media/dvb/ttusb-dec/Makefile b/drivers/media/dvb/ttusb-dec/Makefile
index 2d70a82..dde9168 100644
--- a/drivers/media/dvb/ttusb-dec/Makefile
+++ b/drivers/media/dvb/ttusb-dec/Makefile
@@ -1,3 +1 @@
 obj-$(CONFIG_DVB_TTUSB_DEC) += ttusb_dec.o ttusbdecfe.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 40f98fb..5fe337e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -179,7 +179,3 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/video/au0828/Makefile
index 5c7f2f7..da0bba7 100644
--- a/drivers/media/video/au0828/Makefile
+++ b/drivers/media/video/au0828/Makefile
@@ -2,8 +2,4 @@ au0828-objs	:= au0828-core.o au0828-i2c.o au0828-cards.o au0828-dvb.o au0828-vid
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/bt8xx/Makefile b/drivers/media/video/bt8xx/Makefile
index e415f6f..a042436 100644
--- a/drivers/media/video/bt8xx/Makefile
+++ b/drivers/media/video/bt8xx/Makefile
@@ -7,7 +7,3 @@ bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
 		       bttv-input.o bttv-audio-hook.o
 
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/video/cx18/Makefile
index 2fadd9d..cada757 100644
--- a/drivers/media/video/cx18/Makefile
+++ b/drivers/media/video/cx18/Makefile
@@ -7,7 +7,3 @@ cx18-alsa-objs := cx18-alsa-main.o cx18-alsa-pcm.o
 
 obj-$(CONFIG_VIDEO_CX18) += cx18.o
 obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
-
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index 755dd0c..ec3275d 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -6,9 +6,3 @@ cx231xx-alsa-objs := cx231xx-audio.o
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx.o
 obj-$(CONFIG_VIDEO_CX231XX_ALSA) += cx231xx-alsa.o
 obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index e2ee95f..2d374b0 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -6,9 +6,4 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/cx25840/Makefile b/drivers/media/video/cx25840/Makefile
index 2ee96d3..ac54581 100644
--- a/drivers/media/video/cx25840/Makefile
+++ b/drivers/media/video/cx25840/Makefile
@@ -2,5 +2,3 @@ cx25840-objs    := cx25840-core.o cx25840-audio.o cx25840-firmware.o \
 		   cx25840-vbi.o cx25840-ir.o
 
 obj-$(CONFIG_VIDEO_CX25840) += cx25840.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 5b7e267..6dcb10b 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -9,8 +9,3 @@ obj-$(CONFIG_VIDEO_CX88_ALSA) += cx88-alsa.o
 obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index d0f093d..96fe944 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -6,9 +6,3 @@ em28xx-alsa-objs := em28xx-audio.o
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
 obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
diff --git a/drivers/media/video/hdpvr/Makefile b/drivers/media/video/hdpvr/Makefile
index e0230fc..03f5d33 100644
--- a/drivers/media/video/hdpvr/Makefile
+++ b/drivers/media/video/hdpvr/Makefile
@@ -4,6 +4,4 @@ hdpvr-$(CONFIG_I2C) += hdpvr-i2c.o
 
 obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index 26ce0d6..e8eefd9 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -6,9 +6,3 @@ ivtv-objs	:= ivtv-routing.o ivtv-cards.o ivtv-controls.o \
 
 obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/video/pvrusb2/Makefile
index de2fc14..b8e3f43 100644
--- a/drivers/media/video/pvrusb2/Makefile
+++ b/drivers/media/video/pvrusb2/Makefile
@@ -15,8 +15,3 @@ pvrusb2-objs	:= pvrusb2-i2c-core.o \
 		   $(obj-pvrusb2-sysfs-y) $(obj-pvrusb2-debugifc-y)
 
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 604158a8..6a76920 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -8,8 +8,3 @@ obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/video/saa7164/Makefile
index 4b329fd..10fa310 100644
--- a/drivers/media/video/saa7164/Makefile
+++ b/drivers/media/video/saa7164/Makefile
@@ -4,9 +4,4 @@ saa7164-objs	:= saa7164-cards.o saa7164-core.o saa7164-i2c.o saa7164-dvb.o \
 
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
index 81bb7fd..fc8f870 100644
--- a/drivers/media/video/tlg2300/Makefile
+++ b/drivers/media/video/tlg2300/Makefile
@@ -1,9 +1,3 @@
 poseidon-objs := pd-video.o pd-alsa.o pd-dvb.o pd-radio.o pd-main.o
 
 obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-
diff --git a/drivers/media/video/usbvision/Makefile b/drivers/media/video/usbvision/Makefile
index 3387187..e8e5eda 100644
--- a/drivers/media/video/usbvision/Makefile
+++ b/drivers/media/video/usbvision/Makefile
@@ -1,6 +1,3 @@
 usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-cards.o
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
-
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-- 
1.7.2.1

