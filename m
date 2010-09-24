Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0IXXdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:33:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab0IXXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W6ntXeTqH4oE9Qxtl6TM047ObH3+MA0kPPJnP266T/ftxqnrQryIEfAOTZ5wddRFXz
         kI8EIOvqQMtxZho/TFZoKGfsdUIQLVSzljB8i/6F81u74c6YCXRotdhjlV8d4LWZ7Q/E
         +A2xdsPPoZZ20coH62/UsHhDtvO/Xiq5t21EQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 16/22] Staging: rtl8192u: ieee80211: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:33:33 -0400
Message-Id: <1285371213-9097-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed yo use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/Makefile |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 71ca5d9..c45ebf9 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -5,22 +5,22 @@ MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/$(NIC_SELECT)
 
 CC = gcc
 ifneq ($(shell uname -r|cut -d. -f1,2), 2.4)
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/wireless
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
+ccflags-y := -I$(TOPDIR)/drivers/net/wireless
+ccflags-y := -O2
+ccflags-y := -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
 
 #it will fail to compile in suse linux enterprise 10 sp2. This flag is to solve this problem.
 ifeq ($(shell uname -r | cut -d. -f1,2,3,4), 2.6.16.60-0)
-EXTRA_CFLAGS += -DOPENSUSE_SLED
+ccflags-y := -DOPENSUSE_SLED
 endif
 
 ifeq ($(NIC_SELECT),RTL8192U)
-#EXTRA_CFLAGS += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
-#EXTRA_CFLAGS += -DUSB_RX_AGGREGATION_SUPPORT
+#ccflags-y := -DUSB_TX_DRIVER_AGGREGATION_ENABLE
+#ccflags-y := -DUSB_RX_AGGREGATION_SUPPORT
 endif
-#EXTRA_CFLAGS += -DJOHN_NOCPY
+#ccflags-y := -DJOHN_NOCPY
 #flags to enable or disble 80211D feature
-EXTRA_CFLAGS += -DENABLE_DOT11D
+ccflags-y := -DENABLE_DOT11D
 ieee80211-rsl-objs := ieee80211_rx.o \
 		      ieee80211_softmac.o \
 		      ieee80211_tx.o \
-- 
1.7.3

