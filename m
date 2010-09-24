Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab0IXX2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:28:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab0IXX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M3woU8/SRECh2dzYR4ONax02ohnS8rI1w0s4V8AtwoNZTRuvoVB81MyzQxsPAtKIA/
         LX+Kv1ikenVll+bUGmqQmU+MedyOjAKKWXudkt5GokssxW03ixGflXBF71xcb6AdooRS
         2wYN0NnOdSxx2rzF9TCW1kjiWWnM+MB098nc8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 07/22] Staging: go7007: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:55 -0400
Message-Id: <1285370890-8984-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/go7007/Makefile |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/go7007/Makefile b/drivers/staging/go7007/Makefile
index d37b7ed..9da150d 100644
--- a/drivers/staging/go7007/Makefile
+++ b/drivers/staging/go7007/Makefile
@@ -22,13 +22,12 @@ s2250-objs += s2250-board.o
 # Uncomment when the saa7134 patches get into upstream
 #ifneq ($(CONFIG_VIDEO_SAA7134),)
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
-#EXTRA_CFLAGS += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
+#ccflags-y := -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 #endif
 
 # S2250 needs cypress ezusb loader from dvb-usb
-ifneq ($(CONFIG_VIDEO_GO7007_USB_S2250_BOARD),)
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
-endif
+ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) := -Idrivers/media/dvb/dvb-usb
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+
+ccflags-y := -Idrivers/media/dvb/frontends
+ccflags-y := -Idrivers/media/dvb/dvb-core
-- 
1.7.3

