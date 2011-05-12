Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1ELFeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:34:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39895 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab1ELFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GtetEfL5SP7BqxRgjK1hu8+L8kB8/DqZApPkw4Mr72ijDpOmv1L6fYKnPQNqzJ+THB
         YEjweRwt6NdTXHIVKKSKzQ+rGPjwSFP6NbPpb8/JQUxHUE2CnfiPzOsuTlQvXtA29pAM
         vNx1N+TIT87KabNy6deHyytTPJoI7JWCvX39I=
From: mfmooney@gmail.com
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] staging: usbip: edit Kconfig and rename CONFIG options
Date: Wed, 11 May 2011 22:33:44 -0700
Message-Id: <b6b196f84ae6b8f3c74ae20f4096b556e96503ee.1305178390.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <d889ac7da74d0a6d438b2e0855a76fc5e5299362.1305178390.git.mfm@muteddisk.com>
References: <d889ac7da74d0a6d438b2e0855a76fc5e5299362.1305178390.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Change modules usbip_common_mod to usbip-core and usbip to usbip-host;
edit configuration option help text; rename CONFIG options to use a
USBIP prefix and change COMMON to CORE in both the Kconfig and
Makefiles; edit the menu entries; and edit the driver descriptions.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/Makefile             |    2 +-
 drivers/staging/usbip/Kconfig        |   52 +++++++++++++++++----------------
 drivers/staging/usbip/Makefile       |   12 ++++----
 drivers/staging/usbip/stub_main.c    |    2 +-
 drivers/staging/usbip/usbip_common.c |    4 +-
 drivers/staging/usbip/vhci_hcd.c     |    2 +-
 6 files changed, 38 insertions(+), 36 deletions(-)

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
index 466f0d3..dd13c02 100644
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
+	  be called usbip-core.
 
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
+	  module will be called usbip-host.
 
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
index a43a890..9ecd615 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -1,10 +1,10 @@
-ccflags-$(CONFIG_USB_IP_DEBUG) := -DDEBUG
+ccflags-$(CONFIG_USBIP_DEBUG) := -DDEBUG
 
-obj-$(CONFIG_USB_IP_COMMON) += usbip_common_mod.o
-usbip_common_mod-y := usbip_common.o usbip_event.o
+obj-$(CONFIG_USBIP_CORE) += usbip-core.o
+usbip-core-y := usbip_common.o usbip_event.o
 
-obj-$(CONFIG_USB_IP_VHCI_HCD) += vhci-hcd.o
+obj-$(CONFIG_USBIP_VHCI_HCD) += vhci-hcd.o
 vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
 
-obj-$(CONFIG_USB_IP_HOST) += usbip.o
-usbip-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
+obj-$(CONFIG_USBIP_HOST) += usbip-host.o
+usbip-host-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 1f8fc5e..5568110 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -23,7 +23,7 @@
 #include "stub.h"
 
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
-#define DRIVER_DESC "Stub Driver for USB/IP"
+#define DRIVER_DESC "USB/IP Host Driver"
 
 /* stub_priv is allocated from stub_priv_cache */
 struct kmem_cache *stub_priv_cache;
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index fb95edf..0f2cd97 100644
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
index facd58e..fad10c5 100644
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

