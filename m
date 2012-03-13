Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab2CMW6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:58:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37366 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513Ab2CMW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:58:11 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] usb: Don't make USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.
Date: Tue, 13 Mar 2012 15:58:05 -0700
Message-Id: <1331679485-6159-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The fact that an architecture/board has XHCI, OHCI or EHCI does not
depend on the fact that the kernel is configured with USB_SUPPORT.

Make the Kconfig reflect this fact thus avoiding ugly messages like:

warning: (MIPS_ALCHEMY && CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X && SOC_AR933X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT)

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---

Changes from v1: Add USB_ARCH_HAS_XHCI to the set.

 drivers/usb/Kconfig |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 0b0afc8..e4405e0 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -10,27 +10,6 @@ menuconfig USB_SUPPORT
 	  This option adds core support for Universal Serial Bus (USB).
 	  You will also need drivers from the following menu to make use of it.
 
-if USB_SUPPORT
-
-config USB_COMMON
-	tristate
-	default y
-	depends on USB || USB_GADGET
-
-# Host-side USB depends on having a host controller
-# NOTE:  dummy_hcd is always an option, but it's ignored here ...
-# NOTE:  SL-811 option should be board-specific ...
-config USB_ARCH_HAS_HCD
-	boolean
-	default y if USB_ARCH_HAS_OHCI
-	default y if USB_ARCH_HAS_EHCI
-	default y if USB_ARCH_HAS_XHCI
-	default y if PCMCIA && !M32R			# sl811_cs
-	default y if ARM				# SL-811
-	default y if BLACKFIN				# SL-811
-	default y if SUPERH				# r8a66597-hcd
-	default PCI
-
 # many non-PCI SOC chips embed OHCI
 config USB_ARCH_HAS_OHCI
 	boolean
@@ -84,6 +63,27 @@ config USB_ARCH_HAS_XHCI
 	boolean
 	default PCI
 
+if USB_SUPPORT
+
+config USB_COMMON
+	tristate
+	default y
+	depends on USB || USB_GADGET
+
+# Host-side USB depends on having a host controller
+# NOTE:  dummy_hcd is always an option, but it's ignored here ...
+# NOTE:  SL-811 option should be board-specific ...
+config USB_ARCH_HAS_HCD
+	boolean
+	default y if USB_ARCH_HAS_OHCI
+	default y if USB_ARCH_HAS_EHCI
+	default y if USB_ARCH_HAS_XHCI
+	default y if PCMCIA && !M32R			# sl811_cs
+	default y if ARM				# SL-811
+	default y if BLACKFIN				# SL-811
+	default y if SUPERH				# r8a66597-hcd
+	default PCI
+
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
 config USB
 	tristate "Support for Host-side USB"
-- 
1.7.2.3

