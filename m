Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2BCHHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:07:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64608 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2BCHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:06:59 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/3] pch_udc: Specifies GPI port number at configuration.
Date: Fri,  3 Feb 2012 16:14:19 +0900
Message-Id: <1328253259-9343-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
 The GPIO ports used for detecting VBUS may be different
 on each platform.
 This should be easily modifiable.

Solution:
 In configuration, GPI port number is specified.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/gadget/Kconfig   |   12 ++++++++++++
 drivers/usb/gadget/pch_udc.c |    2 +-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 23a4473..cd0ec15 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -491,6 +491,18 @@ config USB_EG20T
 	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
 
+config USB_VBUS_GPIO_PORT
+	int "GPIO pin used for detecting VBUS"
+	depends on USB_EG20T
+	default "-1"
+	help
+	  Enter the GPIO port number used for detecting VBUS state.
+	  If not used, specify -1(default).
+
+	  If not used, this driver does not support USB suspend state.
+	  If the GPIO port number that VBUS is not connected to is specified,
+	  the USB device may not work.
+
 config USB_CI13XXX_MSM
 	tristate "MIPS USB CI13xxx for MSM"
 	depends on ARCH_MSM
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 942fe92..44a86fc 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -18,7 +18,7 @@
 #include <linux/gpio.h>
 
 /* GPIO port for VBUS detecting */
-static int vbus_gpio_port = -1;		/* GPIO port number (-1:Not used) */
+static int vbus_gpio_port = CONFIG_USB_VBUS_GPIO_PORT;
 
 #define PCH_VBUS_PERIOD		3000	/* VBUS polling period (msec) */
 #define PCH_VBUS_INTERVAL	10	/* VBUS polling interval (msec) */
-- 
1.7.7.6

