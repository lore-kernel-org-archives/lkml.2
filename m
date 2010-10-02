Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab0JBQkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:40:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56995 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0JBQi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NP0zfFLBDgomD14tbUvk7NURd1y8UZ5HoKmZmBlWUIPUrxgAKZU6XXLheXipmAHx+D
         nc2ukx3RlI9+LsnvFesDKJ4zMMadeFDP9LSSp/mfMvSsfQua8o3j9UHxaJ0ynovqdk8H
         HVV/9iePf34XuX/WVRAYHV//JGcWku3Ym+rS4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 14/20] Staging: rtl8192u: ieee80211: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:03 -0400
Message-Id: <1286037489-28439-14-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/Makefile |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 71ca5d9..45704f8 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -5,22 +5,22 @@ MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/$(NIC_SELECT)
 
 CC = gcc
 ifneq ($(shell uname -r|cut -d. -f1,2), 2.4)
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/wireless
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
+ccflags-y := -I$(TOPDIR)/drivers/net/wireless
+ccflags-y += -O2
+ccflags-y += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
 
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
+ccflags-y += -DENABLE_DOT11D
 ieee80211-rsl-objs := ieee80211_rx.o \
 		      ieee80211_softmac.o \
 		      ieee80211_tx.o \
-- 
1.7.3.1.50.g1e633

