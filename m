Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0IXSTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:19:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51363 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0IXSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DvXs0yDY8zerPwB1pKnP/GuARxSa0+p2k3wkh3kqDphR3wdxTgeuxN7Z6yN92dhi+Y
         y/GYJuXLNRfCLiaVz/ZVXFs6g7ROAqyF5ON9gvO1sj0OkyP1UqNZKf4X7pio6s2hYeZ7
         i6wP9SYJIWp/Ow+ZD5h2TKaye8NQeAm/SfLkU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 20/21] Staging: wlags49_h2: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:33 -0400
Message-Id: <1285352314-5939-20-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/wlags49_h2/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h2/Makefile b/drivers/staging/wlags49_h2/Makefile
index 25d0a8a..1af4bc6 100644
--- a/drivers/staging/wlags49_h2/Makefile
+++ b/drivers/staging/wlags49_h2/Makefile
@@ -12,8 +12,8 @@
 #  If you want to build AP support (untested), comment out -DSTA_ONLY
 
 INSTALLDIR := /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless
-EXTRA_CFLAGS += -I$(KERNELDIR)/include
-EXTRA_CFLAGS += -I$(src) \
+ccflags-y += -I$(KERNELDIR)/include
+ccflags-y += -I$(src) \
 		-DBUS_PCMCIA \
 		-DUSE_WPA \
 		-DUSE_WEXT \
@@ -25,16 +25,16 @@ EXTRA_CFLAGS += -I$(src) \
 #		-DUSE_UIL \
 #		-DUSE_PROFILE \
 
-ifeq ($(findstring HERMES25,$(EXTRA_CFLAGS)),)
+ifeq ($(findstring HERMES25,$(ccflags-y)),)
 WLNAME := wlags49_h2_cs
 $(WLNAME)-y := sta_h2.o
-ifeq ($(findstring STA_ONLY,$(EXTRA_CFLAGS)),)
+ifeq ($(findstring STA_ONLY,$(ccflags-y)),)
 $(WLNAME)-y += ap_h2.o
 endif
 else
 WLNAME=wlags49_h25_cs
 $(WLNAME)-y := sta_h25.o
-ifeq ($(findstring STA_ONLY,$(EXTRA_CFLAGS)),)
+ifeq ($(findstring STA_ONLY,$(ccflags-y)),)
 $(WLNAME)-y += ap_h25.o
 endif
 endif
-- 
1.7.3

