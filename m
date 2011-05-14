Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1ENK5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:41 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:52496 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1ENK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DJhd1eD963VTjkffBbTakdEVHVuBSLwRQ8+zHtRhctlMm4yJk1MkvlMDkbpbXiW4+S
         Q9sJbPOYMJ113xz3DRQEiTRLAfG6Mbs2FvWoJ4Ue7hKLXWRRy1HydoCkKHuvJWjxnsMA
         3jbdOeDmirPwND5zyBTByrokmDRsut2JAN9s4=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] staging: usbip: userspace: cleanup makefiles
Date: Sat, 14 May 2011 03:55:14 -0700
Message-Id: <1507919be2602128c61fc9a76820da2c0dd91a49.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Remove unneeded comments; change deprecated flag INCLUDE to
AM_CPPFLAGS and put -D option in *_CPPFLAGS; and use "simply
expanded variables" in assignments.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/Makefile.am        |    8 +++---
 drivers/staging/usbip/userspace/libsrc/Makefile.am |   15 ++++-------
 drivers/staging/usbip/userspace/src/Makefile.am    |   25 ++++++-------------
 3 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
index 3be3060..83f51b8 100644
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ b/drivers/staging/usbip/userspace/Makefile.am
@@ -1,11 +1,11 @@
-SUBDIRS = libsrc src
-includedir=@includedir@/usbip
+SUBDIRS := libsrc src
+includedir := @includedir@/usbip
 include_HEADERS := $(addprefix libsrc/, \
 		     usbip.h usbip_common.h vhci_driver.h stub_driver.h)
 
 dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8 usbip_bind_driver.8)
 
 if INSTALL_USBIDS
-pkgdata_DATA = usb.ids
-EXTRA_DIST = $(pkgdata_DATA)
+pkgdata_DATA := usb.ids
+EXTRA_DIST := $(pkgdata_DATA)
 endif
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index 10b919d..ed83666 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -1,10 +1,7 @@
-# AM_CFLAGS = -Wall -std=gnu99
-lib_LTLIBRARIES = libusbip.la
-libusbip_la_SOURCES = names.c names.h stub_driver.c stub_driver.h usbip.h usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h
-#libusbip_la_SOURCES = names.c names.h stub_driver.c usbip_common.c vhci_driver.c
-#INCLUDES = -I../include
-#AM_CPPFLAGS = -I../include -Wall -std=gnu99
-libusbip_la_LDFLAGS = -version-info 0:1:0
-EXTRA_CFLAGS = @EXTRA_CFLAGS@
-libusbip_la_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+libusbip_la_CPPFLAGS := -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+libusbip_la_CFLAGS   := @EXTRA_CFLAGS@ -Wall -W -Wstrict-prototypes -std=gnu99
+libusbip_la_LDFLAGS  := -version-info 0:1:0
 
+lib_LTLIBRARIES := libusbip.la
+libusbip_la_SOURCES := names.c names.h stub_driver.c stub_driver.h usbip.h \
+		       usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index 3717fc5..a2f0ab2 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -1,19 +1,10 @@
-# $Id$
+AM_CPPFLAGS := -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+AM_CFLAGS   := @EXTRA_CFLAGS@ -Wall -W -Wstrict-prototypes -std=gnu99 @PACKAGE_CFLAGS@
+LDADD       := $(top_srcdir)/libsrc/libusbip.la @PACKAGE_LIBS@
 
-sbin_PROGRAMS = usbip usbipd usbip_bind_driver
-
-usbip_SOURCES = usbip.c usbip_network.c usbip_network.h
-usbipd_SOURCES = usbipd.c usbip_network.c usbip_network.h
-usbip_bind_driver_SOURCES = bind-driver.c \
-		utils.c utils.h \
-		usbip_network.h usbip_network.c
-
-#usbip_bind_driver_CFLAGS = -Wall -W -Wstrict-prototypes @PACKAGE_CFLAGS@
-#usbip_bind_driver_LDADD = @PACKAGE_LIBS@
-
-#AM_CPPFLAGS = -I../include -Wall -std=gnu99
-INCLUDES = -I$(top_srcdir)/libsrc
-LDADD = ../libsrc/libusbip.la @PACKAGE_LIBS@
-EXTRA_CFLAGS = @EXTRA_CFLAGS@
-AM_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) @PACKAGE_CFLAGS@ -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+sbin_PROGRAMS := usbip usbipd usbip_bind_driver
 
+usbip_SOURCES := usbip.c usbip_network.c usbip_network.h
+usbipd_SOURCES := usbipd.c usbip_network.c usbip_network.h
+usbip_bind_driver_SOURCES := bind-driver.c utils.c utils.h \
+			     usbip_network.h usbip_network.c
-- 
1.7.5.1

