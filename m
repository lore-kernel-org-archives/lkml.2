Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1EKP4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:56:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39229 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1EKP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VUyuMOcUGFxRdYIDvTAg6CBXPLs4uqAdKB7mGH140Ix8Pda4x6N3CuLBZ8l2Hakm7D
         /b4jWqY1eEBg/BOfNzUilw2S+J75/5Pm1EiMLoKe7Z+0QWNWpjN/SdcGB5gjrvKi3jzM
         2fdMNQRcuXCB7dzwu6FttiOXBqERRlSDPEY1o=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 01/12] staging: usbip: change debug configuration option
Date: Wed, 11 May 2011 01:54:13 -0700
Message-Id: <805d4e38e30c6a9032df1fb73a258ba5aff70089.1305103212.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change CONFIG_USB_IP_DEBUG_ENABLE to CONFIG_USB_IP_DEBUG, and move
ccflags- to the head of the makefile.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/Kconfig        |    4 ++--
 drivers/staging/usbip/Makefile       |    5 ++---
 drivers/staging/usbip/usbip_common.c |    2 +-
 drivers/staging/usbip/usbip_common.h |    8 ++++----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 2c1d10a..466f0d3 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -35,8 +35,8 @@ config USB_IP_HOST
 	 To compile this driver as a module, choose M here: the
 	 module will be called usbip.
 
-config USB_IP_DEBUG_ENABLE
-	bool "USB-IP Debug Enable"
+config USB_IP_DEBUG
+	bool "USB/IP debug messages"
 	depends on USB_IP_COMMON
 	default N
 	---help---
diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
index 279f3cc..a43a890 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -1,3 +1,5 @@
+ccflags-$(CONFIG_USB_IP_DEBUG) := -DDEBUG
+
 obj-$(CONFIG_USB_IP_COMMON) += usbip_common_mod.o
 usbip_common_mod-y := usbip_common.o usbip_event.o
 
@@ -6,6 +8,3 @@ vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
 
 obj-$(CONFIG_USB_IP_HOST) += usbip.o
 usbip-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
-
-ccflags-$(CONFIG_USB_IP_DEBUG_ENABLE) := -DDEBUG
-
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index b46e9b5..279cad4 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -30,7 +30,7 @@
 #define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>"
 #define DRIVER_DESC "USB/IP Common Driver"
 
-#ifdef CONFIG_USB_IP_DEBUG_ENABLE
+#ifdef CONFIG_USB_IP_DEBUG
 unsigned long usbip_debug_flag = 0xffffffff;
 #else
 unsigned long usbip_debug_flag;
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 0b61d71..c84bed9 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -27,11 +27,11 @@
 #include <net/sock.h>
 
 /**
- * usbip_udbg - print debug messages if CONFIG_USB_IP_DEBUG_ENABLE is defined
+ * usbip_udbg - print debug messages if CONFIG_USB_IP_DEBUG is defined
  * @fmt:
  * @args:
  */
-#ifdef CONFIG_USB_IP_DEBUG_ENABLE
+#ifdef CONFIG_USB_IP_DEBUG
 
 #define usbip_udbg(fmt, args...)					\
 	do {								\
@@ -40,11 +40,11 @@
 		       __FILE__, __LINE__, __func__, ##args);		\
 	} while (0)
 
-#else  /* CONFIG_USB_IP_DEBUG_ENABLE */
+#else
 
 #define usbip_udbg(fmt, args...)	do { } while (0)
 
-#endif /* CONFIG_USB_IP_DEBUG_ENABLE */
+#endif /* CONFIG_USB_IP_DEBUG */
 
 enum {
 	usbip_debug_xmit	= (1 << 0),
-- 
1.7.5.1

