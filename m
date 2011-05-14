Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1ENK50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59824 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab1ENK41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BTccLrrF426ANgrkrM3uYvQp22i9if/VIArXl2JUgKH4qR58QWFS/J6F8eNYGmwXAH
         OG9AqeoYBRzYnIbHfskV0HN3+DCqIVWxIJWUZfHKxwpT9Wf+ghFYMGjKCj3e95UDxyLR
         VRH8gujKDAFPhi4zqLUCb+8zO+qroDASOfB0o=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] staging: usbip: userspace: move common cflags to configure.ac
Date: Sat, 14 May 2011 03:55:18 -0700
Message-Id: <4fa611e630974d3e6e3c71c396624f05de4dc13a.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

There are a standard set of cflags that are used in each makefile so
let's set those in EXTRA_CFLAGS and enforce them for the entire project.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac       |    2 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    2 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 7b93d29..d5f6d8e 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -18,7 +18,7 @@ LT_INIT
 # Silent build for automake >= 1.11
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-AC_SUBST([EXTRA_CFLAGS])
+AC_SUBST([EXTRA_CFLAGS], ["-Wall -W -Wstrict-prototypes -std=gnu99"])
 
 # Checks for programs.
 AC_PROG_CC
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index 6abe7fc..77ecf6b 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -1,5 +1,5 @@
 libusbip_la_CPPFLAGS := -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-libusbip_la_CFLAGS   := @EXTRA_CFLAGS@ -Wall -W -Wstrict-prototypes -std=gnu99
+libusbip_la_CFLAGS   := @EXTRA_CFLAGS@
 libusbip_la_LDFLAGS  := -version-info @LIBUSBIP_VERSION@
 
 lib_LTLIBRARIES := libusbip.la
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index a2f0ab2..05a7aa5 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -1,5 +1,5 @@
 AM_CPPFLAGS := -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-AM_CFLAGS   := @EXTRA_CFLAGS@ -Wall -W -Wstrict-prototypes -std=gnu99 @PACKAGE_CFLAGS@
+AM_CFLAGS   := @EXTRA_CFLAGS@ @PACKAGE_CFLAGS@
 LDADD       := $(top_srcdir)/libsrc/libusbip.la @PACKAGE_LIBS@
 
 sbin_PROGRAMS := usbip usbipd usbip_bind_driver
-- 
1.7.5.1

