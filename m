Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2CVVBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:01:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2CVVBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:01:13 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Julian Wollrath <jwollrath@web.de>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] usb: Put USB Kconfig items back under USB.
Date: Thu, 22 Mar 2012 14:01:07 -0700
Message-Id: <1332450067-16600-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

commit 53c6bc24fdc8db87109a5760579cbb060fa644cf (usb: Don't make
USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.)  Removed the
dependency of the USB_ARCH_HAS_* symbols on USB_SUPPORT.  However the
resulting Kconfig somehow caused many of the USB configuration items
to appear under the top level devices menu.

To fix this we reunite the 'menuconfig USB_SUPPORT' with the 'if
USB_SUPPORT', and the config items magically go back to their desired
location.

Reported-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/usb/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index e4405e0..437a77e 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -2,14 +2,6 @@
 # USB device configuration
 #
 
-menuconfig USB_SUPPORT
-	bool "USB support"
-	depends on HAS_IOMEM
-	default y
-	---help---
-	  This option adds core support for Universal Serial Bus (USB).
-	  You will also need drivers from the following menu to make use of it.
-
 # many non-PCI SOC chips embed OHCI
 config USB_ARCH_HAS_OHCI
 	boolean
@@ -63,6 +55,14 @@ config USB_ARCH_HAS_XHCI
 	boolean
 	default PCI
 
+menuconfig USB_SUPPORT
+	bool "USB support"
+	depends on HAS_IOMEM
+	default y
+	---help---
+	  This option adds core support for Universal Serial Bus (USB).
+	  You will also need drivers from the following menu to make use of it.
+
 if USB_SUPPORT
 
 config USB_COMMON
-- 
1.7.2.3

