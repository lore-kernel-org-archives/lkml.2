Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0JHACS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0JHACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VqAQY3oMgLP1SfO/OH8jfsOXae20iQzWb5QSWyd3w2oBuAnFzkwhQE8TamWtZtiiq9
         7GqK+LWTc3S8CtHBVRlEBXLZiPxiow31nsuHR/uiUToprcVvKyie1ZCAxvHo8vkc2Obd
         m/nhCh+p3FK34rhsYggXmAo8Qxb99WSM/sDQs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 09/33] Staging: go7007: Makefile: makefile cleanup
Date: Thu,  7 Oct 2010 20:01:29 -0400
Message-Id: <1286496113-11897-9-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile. Also, Replace EXTRA_CFLAGS with ccflags-y

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/go7007/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/go7007/Makefile b/drivers/staging/go7007/Makefile
index d37b7ed..60a9185 100644
--- a/drivers/staging/go7007/Makefile
+++ b/drivers/staging/go7007/Makefile
@@ -14,10 +14,10 @@ obj-$(CONFIG_VIDEO_GO7007_UDA1342) += wis-uda1342.o
 obj-$(CONFIG_VIDEO_GO7007_SONY_TUNER) += wis-sony-tuner.o
 obj-$(CONFIG_VIDEO_GO7007_TW2804) += wis-tw2804.o
 
-go7007-objs += go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
+go7007-y := go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
 		snd-go7007.o
 
-s2250-objs += s2250-board.o
+s2250-y := s2250-board.o
 
 # Uncomment when the saa7134 patches get into upstream
 #ifneq ($(CONFIG_VIDEO_SAA7134),)
@@ -27,8 +27,8 @@ s2250-objs += s2250-board.o
 
 # S2250 needs cypress ezusb loader from dvb-usb
 ifneq ($(CONFIG_VIDEO_GO7007_USB_S2250_BOARD),)
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
+ccflags-y := -Idrivers/media/dvb/dvb-usb
 endif
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core
-- 
1.7.3.1.50.g1e633

