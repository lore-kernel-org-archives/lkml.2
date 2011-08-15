Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1HOFIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:08:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44899 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1HOFII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:08:08 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 09/11] drivers/staging: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:12 -0400
Message-Id: <1313384834-24433-10-git-send-email-lacombar@gmail.com>
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
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/cxd2099/Makefile   |    6 +++---
 drivers/staging/go7007/Makefile    |    8 ++------
 drivers/staging/rtl8187se/Makefile |    6 +++---
 drivers/staging/rts_pstor/Makefile |    2 +-
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/cxd2099/Makefile b/drivers/staging/cxd2099/Makefile
index 72b1455..64cfc77 100644
--- a/drivers/staging/cxd2099/Makefile
+++ b/drivers/staging/cxd2099/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
-EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+ccflags-y += -Idrivers/media/dvb/dvb-core/
+ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/staging/go7007/Makefile b/drivers/staging/go7007/Makefile
index 60a9185..6ee837c 100644
--- a/drivers/staging/go7007/Makefile
+++ b/drivers/staging/go7007/Makefile
@@ -20,15 +20,11 @@ go7007-y := go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
 s2250-y := s2250-board.o
 
 # Uncomment when the saa7134 patches get into upstream
-#ifneq ($(CONFIG_VIDEO_SAA7134),)
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
-#EXTRA_CFLAGS += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
-#endif
+#ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 
 # S2250 needs cypress ezusb loader from dvb-usb
-ifneq ($(CONFIG_VIDEO_GO7007_USB_S2250_BOARD),)
-ccflags-y := -Idrivers/media/dvb/dvb-usb
-endif
+ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/dvb/dvb-usb
 
 ccflags-y += -Idrivers/media/dvb/frontends
 ccflags-y += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index 11a9226..72db504 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -1,7 +1,7 @@
 
-#EXTRA_CFLAGS += -DCONFIG_IEEE80211_NOWEP=y
-#EXTRA_CFLAGS += -std=gnu89
-#EXTRA_CFLAGS += -O2
+#ccflags-y += -DCONFIG_IEEE80211_NOWEP=y
+#ccflags-y += -std=gnu89
+#ccflags-y += -O2
 #CC            = gcc
 
 ccflags-y := -DSW_ANTE
diff --git a/drivers/staging/rts_pstor/Makefile b/drivers/staging/rts_pstor/Makefile
index 61609ae..42533d3 100644
--- a/drivers/staging/rts_pstor/Makefile
+++ b/drivers/staging/rts_pstor/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS	:= -Idrivers/scsi
+ccflags := -Idrivers/scsi
 
 obj-$(CONFIG_RTS_PSTOR)	:= rts_pstor.o
 
-- 
1.7.6.153.g78432

