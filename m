Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab0JBQjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:39:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab0JBQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DWn5xmzFzQsnALHvarBUM+n4SbVY+HP0IRF7aZLsZqu0THdo+vwIFsIAMQiZxmUGk4
         mP3L/F34SA+j4d/mnjxY3iXCLE+++ZMkygv4Zxq2J9ULIY2N2Xak7oY7d3EqrpGpuyEp
         dhupAKeXzYWejhUVCZj6w8m8NVEegBz1mO6L4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 19/20] Staging: wlags49_h2: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:08 -0400
Message-Id: <1286037489-28439-19-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/wlags49_h2/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h2/Makefile b/drivers/staging/wlags49_h2/Makefile
index 25d0a8a..e604ebd 100644
--- a/drivers/staging/wlags49_h2/Makefile
+++ b/drivers/staging/wlags49_h2/Makefile
@@ -12,8 +12,8 @@
 #  If you want to build AP support (untested), comment out -DSTA_ONLY
 
 INSTALLDIR := /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless
-EXTRA_CFLAGS += -I$(KERNELDIR)/include
-EXTRA_CFLAGS += -I$(src) \
+ccflags-y := -I$(KERNELDIR)/include
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
1.7.3.1.50.g1e633

