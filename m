Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab0IXX3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:29:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55484 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0IXX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DuIFXyoWhIRAZ+BVYBDTkfYMsB/lsobsBLahfC3m9TU0Havjb+RPg2Qar10acPoRga
         GA9W9tiH721uf/esrmm1+NlqoEYu57hCbkhPJaNfpchWYFsE5MAKndDMAcPpBK4i+gpO
         Hp2LoW9Zx6yLgo7steSQRfxDel444kjjA8t7w=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 21/22] Staging: wlags49_h2: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:09 -0400
Message-Id: <1285370890-8984-21-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/wlags49_h2/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h2/Makefile b/drivers/staging/wlags49_h2/Makefile
index 25d0a8a..198b823 100644
--- a/drivers/staging/wlags49_h2/Makefile
+++ b/drivers/staging/wlags49_h2/Makefile
@@ -12,8 +12,8 @@
 #  If you want to build AP support (untested), comment out -DSTA_ONLY
 
 INSTALLDIR := /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless
-EXTRA_CFLAGS += -I$(KERNELDIR)/include
-EXTRA_CFLAGS += -I$(src) \
+ccflags-y := -I$(KERNELDIR)/include
+ccflags-y := -I$(src) \
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

