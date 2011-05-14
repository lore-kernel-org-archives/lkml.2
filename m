Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1ENK6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:58:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57264 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1ENK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GFhn4KCaIjzj44NQNa+L++RoeZZN4qSAIDzFsoAsZLOt7f9fdc9ogj9nmqdOsM1Ybl
         4czD8Vula286Affbv5lE7ij69YpdRZ9JwYAG+DE1FOdeDpeoyFBQ7RPK+g2dbn5CAsLt
         eO7lZU1fXXxmQoYfGw1QmpsPonaMEqryJLWmg=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] staging: usbip: userspace: configure.ac: major overhaul
Date: Sat, 14 May 2011 03:55:13 -0700
Message-Id: <3a05a20d3023b05611bc149c23a7eca2c58b5e7b.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

All parameters have been quoted; and autoscan was rerun so new
headers, types, and functions were added. The deprecated macros
AM_CONFIG_HEADER and AM_PROG_LIBTOOL were changed to
AC_CONFIG_HEADERS and LT_INIT, respectively. The AS_HELP_STRING
macro is used to avoid arbitrary spacing for proper help menu
alignment, and AS_CASE to avoid quoting issues. And finally, the
macros were realigned to allow mere mortals the ability to read them.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac |  144 +++++++++++++-------------
 1 files changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 144655e..0b71329 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,105 +1,109 @@
-#                                               -*- Autoconf -*-
-# Process this file with autoconf to produce a configure script.
+dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_REVISION($Id$)
-AC_INIT(usbip, 0.1.8, usbip-devel@lists.sourceforge.net)
-AC_DEFINE(USBIP_VERSION, 0x000106, Numeric version number)
+AC_INIT([usbip], [0.1.8], [usbip-devel@lists.sourceforge.net])
+AC_DEFINE([USBIP_VERSION], [0x000106], [numeric version number])
+
+AC_CONFIG_SRCDIR([src/usbipd.c])
+AC_CONFIG_HEADERS([config.h])
 
-AC_CONFIG_SRCDIR([config.h.in])
 AM_INIT_AUTOMAKE([foreign])
+LT_INIT
 
 # Silent build for automake >= 1.11
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-AM_CONFIG_HEADER(config.h)
-
-
 AC_SUBST([EXTRA_CFLAGS])
 
-AC_PROG_LIBTOOL
-
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_INSTALL
-
-# Checks for libraries.
+AC_PROG_MAKE_SET
 
 # Checks for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
-AC_CHECK_HEADERS([fcntl.h netdb.h stdint.h stdlib.h string.h strings.h sys/socket.h syslog.h unistd.h])
+AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h netinet/in.h stdint.h stdlib.h dnl
+		  string.h strings.h sys/socket.h syslog.h unistd.h])
 
 # Checks for typedefs, structures, and compiler characteristics.
-AC_C_CONST
+AC_TYPE_INT32_T
 AC_TYPE_SIZE_T
+AC_TYPE_SSIZE_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT8_T
 
 # Checks for library functions.
-AC_FUNC_MALLOC
 AC_FUNC_REALLOC
-AC_CHECK_FUNCS([bzero memset strchr strerror strstr strtoul])
-
-AC_CHECK_HEADER(sysfs/libsysfs.h,
-	[AC_CHECK_LIB(sysfs, sysfs_open_directory_list,
-		[LIBS="$LIBS -lsysfs"],
-		[AC_MSG_ERROR([Missing sysfs2 library!])])],
-	[AC_MSG_ERROR([Missing /usr/include/sysfs/libsysfs.h])])
+AC_CHECK_FUNCS([bzero memset mkdir regcomp socket strchr strerror strstr dnl
+		strtoul])
 
+AC_CHECK_HEADER([sysfs/libsysfs.h],
+		[AC_CHECK_LIB([sysfs], [sysfs_open_directory_list],
+			      [LIBS="$LIBS -lsysfs"],
+			      [AC_MSG_ERROR([Missing sysfs2 library!])])],
+		[AC_MSG_ERROR([Missing /usr/include/sysfs/libsysfs.h])])
 
-# get from stunnel
-dnl Check for libwrap library.
+# Checks for libwrap library.
 AC_MSG_CHECKING([whether to use the libwrap (TCP wrappers) library])
-
-AC_ARG_WITH(tcp-wrappers,
-[  --with-tcp-wrappers     Use the libwrap (TCP wrappers) library ],
-[saved_LIBS="$LIBS"
- if test "$withval" = "yes"; then
-      AC_MSG_RESULT([yes])
-      AC_MSG_CHECKING([for hosts_access in -lwrap])
-      LIBS="-lwrap $LIBS"
-      AC_TRY_LINK(
-	[int hosts_access(); int allow_severity, deny_severity;],
-	[hosts_access()],
-	[AC_MSG_RESULT([yes]); AC_DEFINE(HAVE_LIBWRAP, 1, use tcp wrapper) wrap_LIB="-lwrap"],
-	[AC_MSG_RESULT([not found]); exit 1])
- else
- 	     AC_MSG_RESULT([no])
- fi
- LIBS="$saved_LIBS"],
-[AC_MSG_RESULT([(default)])
- AC_MSG_CHECKING([for hosts_access in -lwrap])
- saved_LIBS="$LIBS"
- LIBS="-lwrap $saved_LIBS"
- AC_TRY_LINK(
-	[int hosts_access(); int allow_severity, deny_severity;],
- 	[hosts_access()],
- 	[AC_MSG_RESULT([yes]); AC_DEFINE(HAVE_LIBWRAP, 1, use tcp wrapper)],
- 	[AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])
-])
-
-
-
+AC_ARG_WITH([tcp-wrappers],
+	    [AS_HELP_STRING([--with-tcp-wrappers],
+			    [use the libwrap (TCP wrappers) library])],
+	    dnl [ACTION-IF-GIVEN]
+	    [saved_LIBS="$LIBS"
+	     if test "$withval" = "yes"; then
+		     AC_MSG_RESULT([yes])
+		     AC_MSG_CHECKING([for hosts_access in -lwrap])
+		     LIBS="-lwrap $LIBS"
+		     AC_TRY_LINK(
+		       [int hosts_access(); int allow_severity, deny_severity;],
+		       [hosts_access()],
+		       [AC_MSG_RESULT([yes]);
+			AC_DEFINE([HAVE_LIBWRAP], [1],
+				  [use tcp wrapper]) wrap_LIB="-lwrap"],
+		       [AC_MSG_RESULT([not found]); exit 1])
+	     else
+		     AC_MSG_RESULT([no])
+	     fi
+	     LIBS="$saved_LIBS"],
+	    dnl [ACTION-IF-NOT-GIVEN]
+	    [AC_MSG_RESULT([(default)])
+	     AC_MSG_CHECKING([for hosts_access in -lwrap])
+	     saved_LIBS="$LIBS"
+	     LIBS="-lwrap $saved_LIBS"
+	     AC_TRY_LINK(
+	       [int hosts_access(); int allow_severity, deny_severity;],
+	       [hosts_access()],
+	       [AC_MSG_RESULT([yes]);
+		AC_DEFINE([HAVE_LIBWRAP], [1], [use tcp wrapper])],
+	       [AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])])
+
+# Sets directory containing usb.ids.
 USBIDS_DIR='${datadir}/usbip'
-AC_ARG_WITH(usbids-dir, [  --with-usbids-dir=DIR   where usb.ids is found (default ${datadir}/usbip)], [USBIDS_DIR=$withval])
-AC_SUBST(USBIDS_DIR)
+AC_ARG_WITH([usbids-dir],
+	    [AS_HELP_STRING([--with-usbids-dir=DIR],
+	       [where usb.ids is found (default ${datadir}/usbip)])],
+	    [USBIDS_DIR=$withval])
+AC_SUBST([USBIDS_DIR])
 
 dnl FIXME: when disabled, empty directry is created
 usbids=install
-AC_ARG_ENABLE(usbids-install,
-[  --enable-usbids-install     install usb.ids (default)],
-[case "${enableval}" in
- yes) usbids=install ;;
- no)  usbids=notinstall ;;
- *)   AC_MSG_ERROR(bad value ${enableval} for --enable-usbids-install) ;;
- esac])
-AM_CONDITIONAL(INSTALL_USBIDS, test x$usbids = xinstall)
-
-
+AC_ARG_ENABLE([usbids-install],
+	      [AS_HELP_STRING([--enable-usbids-install],
+			      [install usb.ids (default)])],
+	      [AS_CASE([$enableval],
+		       [yes], [usbids=install],
+		       [no], [usbids=notinstall],
+		       [AC_MSG_ERROR(
+			  [bad value ${enableval} for --enable-usbids-install])]
+		      )])
+AM_CONDITIONAL([INSTALL_USBIDS], [test x$usbids = xinstall])
 
 GLIB2_REQUIRED=2.6.0
-PKG_CHECK_MODULES(PACKAGE, glib-2.0 >= $GLIB2_REQUIRED)
-AC_SUBST(PACKAGE_CFLAGS)
-AC_SUBST(PACKAGE_LIBS)
+PKG_CHECK_MODULES([PACKAGE], [glib-2.0 >= $GLIB2_REQUIRED])
+AC_SUBST([PACKAGE_CFLAGS])
+AC_SUBST([PACKAGE_LIBS])
 
 AC_CONFIG_FILES([Makefile libsrc/Makefile src/Makefile])
 AC_OUTPUT
-- 
1.7.5.1

