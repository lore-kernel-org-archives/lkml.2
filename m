Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1GGHvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:51:49 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:33800
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1GGHvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:51:48 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: usbip: userspace: fix header installation bug
Date: Thu,  7 Jul 2011 00:31:52 -0700
Message-Id: <f89e20315322d03c4ebac9a10c9af2f3e11d3e2a.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310023068.git.mfm@muteddisk.com>
References: <cover.1310023068.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug that I created due to using simply expanding variables in the
makefiles. Although only unexpanded paths are at issue here, I decided
to use recursively expanding variables on all of the parameterized
values.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/Makefile.am        |    2 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    6 +++---
 drivers/staging/usbip/userspace/src/Makefile.am    |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
index fbdeef3..9ab1949 100644
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ b/drivers/staging/usbip/userspace/Makefile.am
@@ -1,5 +1,5 @@
 SUBDIRS := libsrc src
-includedir := @includedir@/usbip
+includedir = @includedir@/usbip
 include_HEADERS := $(addprefix libsrc/, \
 		     usbip_common.h vhci_driver.h usbip_host_driver.h)
 
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index 9b663a4..4921189 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -1,6 +1,6 @@
-libusbip_la_CPPFLAGS := -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-libusbip_la_CFLAGS   := @EXTRA_CFLAGS@
-libusbip_la_LDFLAGS  := -version-info @LIBUSBIP_VERSION@
+libusbip_la_CPPFLAGS = -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+libusbip_la_CFLAGS   = @EXTRA_CFLAGS@
+libusbip_la_LDFLAGS  = -version-info @LIBUSBIP_VERSION@
 
 lib_LTLIBRARIES := libusbip.la
 libusbip_la_SOURCES := names.c names.h usbip_host_driver.c usbip_host_driver.h \
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index 44ff0ca..3f09f6a 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -1,6 +1,6 @@
-AM_CPPFLAGS := -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-AM_CFLAGS   := @EXTRA_CFLAGS@ @PACKAGE_CFLAGS@
-LDADD       := $(top_builddir)/libsrc/libusbip.la @PACKAGE_LIBS@
+AM_CPPFLAGS = -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+AM_CFLAGS   = @EXTRA_CFLAGS@ @PACKAGE_CFLAGS@
+LDADD       = $(top_builddir)/libsrc/libusbip.la @PACKAGE_LIBS@
 
 sbin_PROGRAMS := usbip usbipd
 
-- 
1.7.6

