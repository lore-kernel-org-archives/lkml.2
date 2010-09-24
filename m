Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0IXSTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:19:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab0IXSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u2L8smi8lGYFvKe15+YTNNGoGZ/+BtStrveYnGbl6MJ78xpcLzf1Kc3l4+ORNdIInB
         lyYP9rcjrfidZhZTbmV3dzxgs6MGwJaO/T/TwlIXGMMml6fwE4Uv0eXbkl8c8YMeUiZX
         gUW/++QC842lMgmWIU0Sp5b0Hu8LjhOLvPNSs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 15/21] Staging: rtl8192u: ieee80211: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:28 -0400
Message-Id: <1285352314-5939-15-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 71ca5d9..d19b49f 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -5,20 +5,20 @@ MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/$(NIC_SELECT)
 
 CC = gcc
 ifneq ($(shell uname -r|cut -d. -f1,2), 2.4)
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/wireless
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
+ccflags-y += -I$(TOPDIR)/drivers/net/wireless
+ccflags-y += -O2
+ccflags-y += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
 
 #it will fail to compile in suse linux enterprise 10 sp2. This flag is to solve this problem.
 ifeq ($(shell uname -r | cut -d. -f1,2,3,4), 2.6.16.60-0)
-EXTRA_CFLAGS += -DOPENSUSE_SLED
+ccflags-y += -DOPENSUSE_SLED
 endif
 
 ifeq ($(NIC_SELECT),RTL8192U)
-#EXTRA_CFLAGS += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
-#EXTRA_CFLAGS += -DUSB_RX_AGGREGATION_SUPPORT
+#ccflags-y += -DUSB_TX_DRIVER_AGGREGATION_ENABLE
+#ccflags-y += -DUSB_RX_AGGREGATION_SUPPORT
 endif
-#EXTRA_CFLAGS += -DJOHN_NOCPY
+#ccflags-y += -DJOHN_NOCPY
 #flags to enable or disble 80211D feature
 EXTRA_CFLAGS += -DENABLE_DOT11D
 ieee80211-rsl-objs := ieee80211_rx.o \
-- 
1.7.3

