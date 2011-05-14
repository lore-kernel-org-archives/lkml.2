Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1ENK4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:56:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53107 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1ENK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U2B+I5Fvcq3tzWtwxarSL7hQ3KUo5A/4B4t9l0cyYCjZAZXl6+ocJmaRDim3epreAt
         OaDFmdlr+8j7DV9DQQiyJjNk9UbsiBRz33Us6RO2f9Pa5Wgkrm/Kn8RzAtlWpLdsHngN
         xmZFKSTVlnEj+mYrdJJ0rn+4I2SEomb1HnH9Q=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] staging: usbip: userspace: move manpages to separate directory
Date: Sat, 14 May 2011 03:55:08 -0700
Message-Id: <489f742995f2b84fa51d6e00d4d3f952cc0c647a.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>


Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/Makefile.am        |    2 +
 drivers/staging/usbip/userspace/cmd/Makefile.am    |    2 -
 drivers/staging/usbip/userspace/cmd/usbip.8        |   71 --------------------
 .../usbip/userspace/cmd/usbip_bind_driver.8        |   42 ------------
 drivers/staging/usbip/userspace/cmd/usbipd.8       |   62 -----------------
 drivers/staging/usbip/userspace/doc/usbip.8        |   71 ++++++++++++++++++++
 .../usbip/userspace/doc/usbip_bind_driver.8        |   42 ++++++++++++
 drivers/staging/usbip/userspace/doc/usbipd.8       |   62 +++++++++++++++++
 8 files changed, 177 insertions(+), 177 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbip.8
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbip_bind_driver.8
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbipd.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbipd.8

diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
index 964f005..c076952 100644
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ b/drivers/staging/usbip/userspace/Makefile.am
@@ -2,6 +2,8 @@ SUBDIRS = lib cmd
 includedir=@includedir@/usbip
 include_HEADERS = lib/usbip.h lib/usbip_common.h lib/vhci_driver.h lib/stub_driver.h
 
+dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8 usbip_bind_driver.8)
+
 if INSTALL_USBIDS
 pkgdata_DATA = usb.ids
 EXTRA_DIST = $(pkgdata_DATA)
diff --git a/drivers/staging/usbip/userspace/cmd/Makefile.am b/drivers/staging/usbip/userspace/cmd/Makefile.am
index c923e49..5cc50fc 100644
--- a/drivers/staging/usbip/userspace/cmd/Makefile.am
+++ b/drivers/staging/usbip/userspace/cmd/Makefile.am
@@ -8,8 +8,6 @@ usbip_bind_driver_SOURCES = bind-driver.c \
 		utils.c utils.h \
 		usbip_network.h usbip_network.c
 
-dist_man_MANS = usbip.8 usbipd.8 usbip_bind_driver.8
-
 #usbip_bind_driver_CFLAGS = -Wall -W -Wstrict-prototypes @PACKAGE_CFLAGS@
 #usbip_bind_driver_LDADD = @PACKAGE_LIBS@
 
diff --git a/drivers/staging/usbip/userspace/cmd/usbip.8 b/drivers/staging/usbip/userspace/cmd/usbip.8
deleted file mode 100644
index 1653bb2..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbip.8
+++ /dev/null
@@ -1,71 +0,0 @@
-.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
-.SH NAME
-usbip \- manage USB/IP devices
-.SH SYNOPSIS
-.B usbip
-[\fIoptions\fR]
-
-.SH DESCRIPTION
-Devices exported by USB/IP servers can be listed, attached and
-detached using this program.
-
-.SH OPTIONS
-.HP
-\fB\-a\fR, \fB\-\-attach\fR <host> <bus_id>
-.IP
-Attach a remote USB device.
-.PP
-
-.HP
-\fB\-x\fR, \fB\-\-attachall\fR <host>
-.IP
-Attach all remote USB devices on the specific host.
-.PP
-
-.HP
-\fB\-d\fR, \fB\-\-detach\fR <ports>
-.IP
-Detach an imported USB device.
-.PP
-
-.HP
-\fB\-l\fR, \fB\-\-list\fR <hosts>
-.IP
-List exported USB devices.
-.PP
-
-.HP
-\fB\-p\fR, \fB\-\-port\fR
-.IP
-List virtual USB port status.
-.PP
-
-.HP
-\fB\-D\fR, \fB\-\-debug\fR
-.IP
-Print debugging information.
-.PP
-
-.HP
-\fB\-v\fR, \fB\-\-version\fR
-.IP
-Show version.
-.PP
-
-.SH EXAMPLES
-
-    client:# usbip --list server
-        - List exportable usb devices on the server.
-
-    client:# usbip --attach server 1-2
-        - Connect the remote USB device.
-
-    client:# usbip --port
-        - Show virtual port status.
-
-    client:# usbip --detach 0
-        - Detach the usb device.
-
-.SH "SEE ALSO"
-\fBusbipd\fP\fB(8)\fB\fP,
-\fBusbip_attach_driver\fP\fB(8)\fB\fP
diff --git a/drivers/staging/usbip/userspace/cmd/usbip_bind_driver.8 b/drivers/staging/usbip/userspace/cmd/usbip_bind_driver.8
deleted file mode 100644
index 8a8972d..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbip_bind_driver.8
+++ /dev/null
@@ -1,42 +0,0 @@
-.TH USBIP_BIND_DRIVER "8" "February 2009" "usbip" "System Administration Utilities"
-.SH NAME
-usbip_bind_driver \- change driver binding for USB/IP
-
-.SH SYNOPSIS
-.B usbip_bind_driver
-[\fIoptions\fR]
-
-.SH DESCRIPTION
-Driver bindings for USB devices can be changed using 
-this program. It is used to export and unexport USB 
-devices over USB/IP.
-
-.SH OPTIONS
-.TP
-\fB\-u\fR, \fB\-\-usbip\fR <busid>
-Make a device exportable
-.TP
-\fB\-o\fR, \fB\-\-other\fR <busid>
-Use a device by a local driver
-.TP
-\fB\-l\fR, \fB\-\-list\fR
-Print usb devices and their drivers
-.TP
-\fB\-L\fR, \fB\-\-list2\fR
-Print usb devices and their drivers in parseable mode
-
-.SH EXAMPLES
-
-    server:# usbip_bind_driver --list
-        - List driver assignments for usb devices.
-
-    server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip.ko to the device of busid 1-2.
-        - A usb device 1-2 is now exportable to other hosts!
-
-    server:# usbip_bind_driver --other 1-2 
-        - Shutdown exporting and use the device locally.
-
-.SH "SEE ALSO"
-\fBusbip\fP\fB(8)\fB\fP,
-\fBusbipd\fP\fB(8)\fB\fP
diff --git a/drivers/staging/usbip/userspace/cmd/usbipd.8 b/drivers/staging/usbip/userspace/cmd/usbipd.8
deleted file mode 100644
index 3c39520..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbipd.8
+++ /dev/null
@@ -1,62 +0,0 @@
-.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
-.SH NAME
-usbipd \- USB/IP server daemon
-.SH SYNOPSIS
-.B usbipd
-[\fIoptions\fR]
-
-.SH DESCRIPTION
-.B usbipd
-provides USB/IP clients access to exported USB devices.
-
-Devices have to explicitly be exported using
-.B usbip_bind_driver
-before usbipd makes them available to other hosts.
-
-The daemon accepts connections from USB/IP clients
-on TCP port 3240.
-
-.SH OPTIONS
-.HP
-\fB\-D\fR, \fB\-\-daemon\fR
-.IP
-Run as a daemon process.
-.PP
-
-.HP
-\fB\-d\fR, \fB\-\-debug\fR
-.IP
-Print debugging information.
-.PP
-
-.HP
-\fB\-v\fR, \fB\-\-version\fR
-.IP
-Show version.
-.PP
-
-.SH LIMITATIONS
-
-.B usbipd
-offers no authentication or authorization for USB/IP. Any
-USB/IP client can connect and use exported devices.
-
-.SH EXAMPLES
-
-    server:# modprobe usbip
-
-    server:# usbipd -D
-        - Start usbip daemon.
-
-    server:# usbip_bind_driver --list
-        - List driver assignments for usb devices.
-
-    server:# usbip_bind_driver --usbip 1-2
-        - Bind usbip.ko to the device of busid 1-2.
-        - A usb device 1-2 is now exportable to other hosts!
-        - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting and use the device locally.
-
-.SH "SEE ALSO"
-\fBusbip\fP\fB(8)\fB\fP,
-\fBusbip_attach_driver\fP\fB(8)\fB\fP
-
diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/drivers/staging/usbip/userspace/doc/usbip.8
new file mode 100644
index 0000000..1653bb2
--- /dev/null
+++ b/drivers/staging/usbip/userspace/doc/usbip.8
@@ -0,0 +1,71 @@
+.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
+.SH NAME
+usbip \- manage USB/IP devices
+.SH SYNOPSIS
+.B usbip
+[\fIoptions\fR]
+
+.SH DESCRIPTION
+Devices exported by USB/IP servers can be listed, attached and
+detached using this program.
+
+.SH OPTIONS
+.HP
+\fB\-a\fR, \fB\-\-attach\fR <host> <bus_id>
+.IP
+Attach a remote USB device.
+.PP
+
+.HP
+\fB\-x\fR, \fB\-\-attachall\fR <host>
+.IP
+Attach all remote USB devices on the specific host.
+.PP
+
+.HP
+\fB\-d\fR, \fB\-\-detach\fR <ports>
+.IP
+Detach an imported USB device.
+.PP
+
+.HP
+\fB\-l\fR, \fB\-\-list\fR <hosts>
+.IP
+List exported USB devices.
+.PP
+
+.HP
+\fB\-p\fR, \fB\-\-port\fR
+.IP
+List virtual USB port status.
+.PP
+
+.HP
+\fB\-D\fR, \fB\-\-debug\fR
+.IP
+Print debugging information.
+.PP
+
+.HP
+\fB\-v\fR, \fB\-\-version\fR
+.IP
+Show version.
+.PP
+
+.SH EXAMPLES
+
+    client:# usbip --list server
+        - List exportable usb devices on the server.
+
+    client:# usbip --attach server 1-2
+        - Connect the remote USB device.
+
+    client:# usbip --port
+        - Show virtual port status.
+
+    client:# usbip --detach 0
+        - Detach the usb device.
+
+.SH "SEE ALSO"
+\fBusbipd\fP\fB(8)\fB\fP,
+\fBusbip_attach_driver\fP\fB(8)\fB\fP
diff --git a/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8 b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
new file mode 100644
index 0000000..8a8972d
--- /dev/null
+++ b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
@@ -0,0 +1,42 @@
+.TH USBIP_BIND_DRIVER "8" "February 2009" "usbip" "System Administration Utilities"
+.SH NAME
+usbip_bind_driver \- change driver binding for USB/IP
+
+.SH SYNOPSIS
+.B usbip_bind_driver
+[\fIoptions\fR]
+
+.SH DESCRIPTION
+Driver bindings for USB devices can be changed using 
+this program. It is used to export and unexport USB 
+devices over USB/IP.
+
+.SH OPTIONS
+.TP
+\fB\-u\fR, \fB\-\-usbip\fR <busid>
+Make a device exportable
+.TP
+\fB\-o\fR, \fB\-\-other\fR <busid>
+Use a device by a local driver
+.TP
+\fB\-l\fR, \fB\-\-list\fR
+Print usb devices and their drivers
+.TP
+\fB\-L\fR, \fB\-\-list2\fR
+Print usb devices and their drivers in parseable mode
+
+.SH EXAMPLES
+
+    server:# usbip_bind_driver --list
+        - List driver assignments for usb devices.
+
+    server:# usbip_bind_driver --usbip 1-2
+        - Bind usbip.ko to the device of busid 1-2.
+        - A usb device 1-2 is now exportable to other hosts!
+
+    server:# usbip_bind_driver --other 1-2 
+        - Shutdown exporting and use the device locally.
+
+.SH "SEE ALSO"
+\fBusbip\fP\fB(8)\fB\fP,
+\fBusbipd\fP\fB(8)\fB\fP
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/drivers/staging/usbip/userspace/doc/usbipd.8
new file mode 100644
index 0000000..3c39520
--- /dev/null
+++ b/drivers/staging/usbip/userspace/doc/usbipd.8
@@ -0,0 +1,62 @@
+.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
+.SH NAME
+usbipd \- USB/IP server daemon
+.SH SYNOPSIS
+.B usbipd
+[\fIoptions\fR]
+
+.SH DESCRIPTION
+.B usbipd
+provides USB/IP clients access to exported USB devices.
+
+Devices have to explicitly be exported using
+.B usbip_bind_driver
+before usbipd makes them available to other hosts.
+
+The daemon accepts connections from USB/IP clients
+on TCP port 3240.
+
+.SH OPTIONS
+.HP
+\fB\-D\fR, \fB\-\-daemon\fR
+.IP
+Run as a daemon process.
+.PP
+
+.HP
+\fB\-d\fR, \fB\-\-debug\fR
+.IP
+Print debugging information.
+.PP
+
+.HP
+\fB\-v\fR, \fB\-\-version\fR
+.IP
+Show version.
+.PP
+
+.SH LIMITATIONS
+
+.B usbipd
+offers no authentication or authorization for USB/IP. Any
+USB/IP client can connect and use exported devices.
+
+.SH EXAMPLES
+
+    server:# modprobe usbip
+
+    server:# usbipd -D
+        - Start usbip daemon.
+
+    server:# usbip_bind_driver --list
+        - List driver assignments for usb devices.
+
+    server:# usbip_bind_driver --usbip 1-2
+        - Bind usbip.ko to the device of busid 1-2.
+        - A usb device 1-2 is now exportable to other hosts!
+        - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting and use the device locally.
+
+.SH "SEE ALSO"
+\fBusbip\fP\fB(8)\fB\fP,
+\fBusbip_attach_driver\fP\fB(8)\fB\fP
+
-- 
1.7.5.1

