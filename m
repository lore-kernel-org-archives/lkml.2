Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1ENK5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:36 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:50118 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab1ENK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cRC/pBYKhbvIHMIaDiPtVmVg9+SKTlN9BKAEpwa9CtYB6re3jHGHQcRv1AHIGyff7l
         B7x7dR6Y2/KO/IVePAPEfxxcy9iDBVPj/1ykQPiMJq5rll/xg6+SU0Wa5galwlAuDgmq
         oLHUfAJpFbK61iRQiNI2zcZw9QEITZOu2kKxQ=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] staging: usbip: userspace: set libusbip version in configure.ac
Date: Sat, 14 May 2011 03:55:15 -0700
Message-Id: <3ce79fed0daf33b417ddfc201221eae9be25cb0d.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Move libusbip version setting to configure.ac so that version
numbers can be found in a single location.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac       |    5 +++++
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 0b71329..7b93d29 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -4,6 +4,11 @@ AC_PREREQ(2.59)
 AC_INIT([usbip], [0.1.8], [usbip-devel@lists.sourceforge.net])
 AC_DEFINE([USBIP_VERSION], [0x000106], [numeric version number])
 
+CURRENT=0
+REVISION=1
+AGE=0
+AC_SUBST([LIBUSBIP_VERSION], [$CURRENT:$REVISION:$AGE], [library version])
+
 AC_CONFIG_SRCDIR([src/usbipd.c])
 AC_CONFIG_HEADERS([config.h])
 
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
index ed83666..6abe7fc 100644
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -1,6 +1,6 @@
 libusbip_la_CPPFLAGS := -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
 libusbip_la_CFLAGS   := @EXTRA_CFLAGS@ -Wall -W -Wstrict-prototypes -std=gnu99
-libusbip_la_LDFLAGS  := -version-info 0:1:0
+libusbip_la_LDFLAGS  := -version-info @LIBUSBIP_VERSION@
 
 lib_LTLIBRARIES := libusbip.la
 libusbip_la_SOURCES := names.c names.h stub_driver.c stub_driver.h usbip.h \
-- 
1.7.5.1

