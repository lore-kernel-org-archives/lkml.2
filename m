Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1EKPss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:48:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40748 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1EKPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fh838EBbYtND5fJUYhX5cBtbIkeKcW3HhC4/sqFHqyeKqgx//hBUPA1vBNrYQoVWs0
         xRf+QTP7gScVVdpNygK4MUgcfcKOmr+rN91jyHVvpcE5TIg88HauGxFRc90zhfifwFvs
         3sQuvAtZHNX3DddRRzkrxpWAkztXW73qBgSlw=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 09/12] staging: usbip: edit Kconfig and rename CONFIG options
Date: Wed, 11 May 2011 01:54:21 -0700
Message-Id: <d7a90447e6c03d9e62007325f63d0a0e70654903.1305103212.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edit configuration option help text; rename CONFIG options to use a
USBIP prefix and change COMMON to CORE in both the Kconfig and
Makefile; edit the menu entries; and edit the driver descriptions.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
I was thinking that renaming the modules would be a good idea. This patch is a
start in that direction without changing anything in userspace yet. My idea is
to change usbip_common_mod to usbip-core and usbip to usbip-host. What do you
think?

 drivers/staging/Makefile             |    2 +-
 drivers/staging/usbip/Kconfig        |   52 +++++++++++++++++----------------
 drivers/staging/usbip/Makefile       |    8 ++--
 drivers/staging/usbip/stub_main.c    |    2 +-
 drivers/staging/usbip/usbip_common.c |    4 +-
 drivers/staging/usbip/vhci_hcd.c     |    2 +-
 6 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 7d38925..e150a45 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_VIDEO_CX25821)	+= cx25821/
 obj-$(CONFIG_VIDEO_TM6000)	+= tm6000/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
-obj-$(CONFIG_USB_IP_COMMON)	+= usbip/
+obj-$(CONFIG_USBIP_CORE)	+= usbip/
 obj-$(CONFIG_W35UND)		+= winbond/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_ECHO)		+= echo/
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 466f0d3..f3f64b7 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,43 +1,45 @@
-config USB_IP_COMMON
-	tristate "USB IP support (EXPERIMENTAL)"
+config USBIP_CORE
+	tristate "USB/IP support (EXPERIMENTAL)"
 	depends on USB && NET && EXPERIMENTAL
 	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
-	  machines access to USB devices directly.  For more details,
-	  and links to the userspace utility programs to let this work
-	  properly, see http://usbip.sourceforge.net/.
+	  machines direct access to USB devices. It provides the
+	  USB/IP core that is required by both drivers.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called usbip_common_mod.
+	  For more details, and to get the userspace utility
+	  programs, please see http://usbip.sourceforge.net/.
+
+	  To compile this as a module, choose M here: the module will
+	  be called usbip_common_mod.
 
 	  If unsure, say N.
 
-config USB_IP_VHCI_HCD
-	tristate "USB IP client driver"
-	depends on USB_IP_COMMON
+config USBIP_VHCI_HCD
+	tristate "VHCI hcd"
+	depends on USBIP_CORE
 	default N
 	---help---
-	 This enables the USB IP host controller driver which will
-	 run on the client machine.
+	  This enables the USB/IP virtual host controller driver,
+	  which is run on the remote machine.
 
-	 To compile this driver as a module, choose M here: the
-	 module will be called vhci_hcd.
+	  To compile this driver as a module, choose M here: the
+	  module will be called vhci-hcd.
 
-config USB_IP_HOST
-	tristate "USB IP host driver"
-	depends on USB_IP_COMMON
+config USBIP_HOST
+	tristate "Host driver"
+	depends on USBIP_CORE
 	default N
 	---help---
-	 This enables the USB IP device driver which will run on the
-	 host machine.
+	  This enables the USB/IP host driver, which is run on the
+	  machine that is sharing the USB devices.
 
-	 To compile this driver as a module, choose M here: the
-	 module will be called usbip.
+	  To compile this driver as a module, choose M here: the
+	  module will be called usbip.
 
-config USB_IP_DEBUG
-	bool "USB/IP debug messages"
-	depends on USB_IP_COMMON
+config USBIP_DEBUG
+	bool "Debug messages for USB/IP"
+	depends on USBIP_CORE
 	default N
 	---help---
-	  This enables the debug messages from the USB-IP drivers.
+	  This enables the debug messages from the USB/IP drivers.
diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
index a43a890..6b7172f 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -1,10 +1,10 @@
-ccflags-$(CONFIG_USB_IP_DEBUG) := -DDEBUG
+ccflags-$(CONFIG_USBIP_DEBUG) := -DDEBUG
 
-obj-$(CONFIG_USB_IP_COMMON) += usbip_common_mod.o
+obj-$(CONFIG_USBIP_CORE) += usbip_common_mod.o
 usbip_common_mod-y := usbip_common.o usbip_event.o
 
-obj-$(CONFIG_USB_IP_VHCI_HCD) += vhci-hcd.o
+obj-$(CONFIG_USBIP_VHCI_HCD) += vhci-hcd.o
 vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
 
-obj-$(CONFIG_USB_IP_HOST) += usbip.o
+obj-$(CONFIG_USBIP_HOST) += usbip.o
 usbip-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index f2ce939..042d3f8 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -23,7 +23,7 @@
 #include "stub.h"
 
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
-#define DRIVER_DESC "Stub Driver for USB/IP"
+#define DRIVER_DESC "USB/IP Host Driver"
 
 struct kmem_cache *stub_priv_cache;
 /*
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index d2fb1ae..58b2049 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -27,9 +27,9 @@
 #include "usbip_common.h"
 
 #define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>"
-#define DRIVER_DESC "USB/IP Common Driver"
+#define DRIVER_DESC "USB/IP Core"
 
-#ifdef CONFIG_USB_IP_DEBUG
+#ifdef CONFIG_USBIP_DEBUG
 unsigned long usbip_debug_flag = 0xffffffff;
 #else
 unsigned long usbip_debug_flag;
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 069a7c7..f0e190c 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -28,7 +28,7 @@
 #include "vhci.h"
 
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
-#define DRIVER_DESC "Virtual Host Controller Interface Driver for USB/IP"
+#define DRIVER_DESC "USB/IP 'Virtual' Host Controller (VHCI) Driver"
 
 /*
  * TODO
-- 
1.7.5.1

