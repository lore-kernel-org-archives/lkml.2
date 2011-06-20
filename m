Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1FTFwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:52:04 -0400
Received: from qmta14.westchester.pa.mail.comcast.net ([76.96.59.212]:52648
	"EHLO qmta14.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab1FTFwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:52:00 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/22] staging: usbip: userspace: libsrc: remove usbip.h
Date: Sun, 19 Jun 2011 22:44:37 -0700
Message-Id: <b36875613518a7cf5ded924cc43d254fb48968ff.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the library version of usbip.h because its sole purpose was to
include other headers, which is bad practice. Also modify include
guards for consistency.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/Makefile.am        |    2 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    2 +-
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    3 ++-
 .../staging/usbip/userspace/libsrc/stub_driver.h   |   11 ++++++-----
 drivers/staging/usbip/userspace/libsrc/usbip.h     |   19 -------------------
 .../staging/usbip/userspace/libsrc/usbip_common.c  |    2 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    4 ++--
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   13 ++++++++-----
 8 files changed, 21 insertions(+), 35 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip.h

diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
index 4b66cbe..d557fe9 100644
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ b/drivers/staging/usbip/userspace/Makefile.am
@@ -1,6 +1,6 @@
 SUBDIRS := libsrc src
 includedir := @includedir@/usbip
 include_HEADERS := $(addprefix libsrc/, \
-		     usbip.h usbip_common.h vhci_driver.h stub_driver.h)
+		     usbip_common.h vhci_driver.h stub_driver.h)
 
 dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8 usbip_bind_driver.8)
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index 77ecf6b..6696aa7 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -3,5 +3,5 @@ libusbip_la_CFLAGS   := @EXTRA_CFLAGS@
 libusbip_la_LDFLAGS  := -version-info @LIBUSBIP_VERSION@
 
 lib_LTLIBRARIES := libusbip.la
-libusbip_la_SOURCES := names.c names.h stub_driver.c stub_driver.h usbip.h \
+libusbip_la_SOURCES := names.c names.h stub_driver.c stub_driver.h \
 		       usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index b62f6b2..0f9593b 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -8,7 +8,8 @@
 #include <errno.h>
 #include <unistd.h>
 
-#include "usbip.h"
+#include "usbip_common.h"
+#include "stub_driver.h"
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.h b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
index 332ebc5..9eaf92c 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
@@ -2,11 +2,11 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#ifndef _USBIP_STUB_DRIVER_H
-#define _USBIP_STUB_DRIVER_H
-
-#include "usbip.h"
+#ifndef __USBIP_STUB_DRIVER_H
+#define __USBIP_STUB_DRIVER_H
 
+#include <stdint.h>
+#include "usbip_common.h"
 
 struct usbip_stub_driver {
 	int ndevs;
@@ -33,4 +33,5 @@ int usbip_stub_refresh_device_list(void);
 int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd);
 
 struct usbip_exported_device *usbip_stub_get_device(int num);
-#endif
+
+#endif /* __USBIP_STUB_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip.h b/drivers/staging/usbip/userspace/libsrc/usbip.h
deleted file mode 100644
index 7cb8e6f..0000000
--- a/drivers/staging/usbip/userspace/libsrc/usbip.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _USBIP_H
-#define _USBIP_H
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include "usbip_common.h"
-#include "stub_driver.h"
-#include "vhci_driver.h"
-#ifdef DMALLOC
-#include <dmalloc.h>
-#endif
-
-#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 6ac4361..e0ec23f 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -2,7 +2,7 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#include "usbip.h"
+#include "usbip_common.h"
 #include "names.h"
 
 #undef  PROGNAME
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index f10121c..e663fab 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -2,8 +2,8 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-
-#include "usbip.h"
+#include "usbip_common.h"
+#include "vhci_driver.h"
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index a2f7db1..89949aa 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -2,13 +2,15 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#ifndef _VHCI_DRIVER_H
-#define _VHCI_DRIVER_H
+#ifndef __VHCI_DRIVER_H
+#define __VHCI_DRIVER_H
 
-#include "usbip.h"
+#include <sysfs/libsysfs.h>
+#include <stdint.h>
 
-#define USBIP_VHCI_BUS_TYPE "platform"
+#include "usbip_common.h"
 
+#define USBIP_VHCI_BUS_TYPE "platform"
 #define MAXNPORT 128
 
 struct usbip_class_device {
@@ -61,4 +63,5 @@ int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
 		uint8_t devnum, uint32_t speed);
 
 int usbip_vhci_detach_device(uint8_t port);
-#endif
+
+#endif /* __VHCI_DRIVER_H */
-- 
1.7.5.2

