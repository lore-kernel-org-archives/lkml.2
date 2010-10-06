Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab0JFVWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:22:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab0JFVWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:22:05 -0400
From: pavan-savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/2] drivers:bluetooth: Kconfig & Makefile for TI BT
Date: Wed,  6 Oct 2010 18:34:53 -0400
Message-Id: <1286404493-23816-3-git-send-email-pavan-savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Kconfig and Makefile modifications to enable the Bluetooth
driver for Texas Instrument's WiLink 7 chipset.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/bluetooth/Kconfig      |   11 +++++++++++
 drivers/bluetooth/Makefile     |    1 +
 drivers/staging/ti-st/Kconfig  |   14 --------------
 drivers/staging/ti-st/Makefile |    5 -----
 4 files changed, 12 insertions(+), 19 deletions(-)
 delete mode 100644 drivers/staging/ti-st/Kconfig
 delete mode 100644 drivers/staging/ti-st/Makefile

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 02deef4..91a18b3 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -219,4 +219,15 @@ config BT_ATH3K
 	  Say Y here to compile support for "Atheros firmware download driver"
 	  into the kernel or say M to compile it as module (ath3k).
 
+config BT_TI
+	tristate "BlueZ bluetooth driver for TI ST"
+	depends on BT && RFKILL
+	select TI_ST
+	help
+	  This enables the Bluetooth driver for Texas Instrument's BT/FM/GPS
+	  combo devices. This makes use of shared transport line discipline
+	  core driver to communicate with the BT core of the combo chip.
+
+	  Say Y here to compile support for Texas Instrument's WiLink7 driver
+	  into the kernel or say M to compile it as module.
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 71bdf13..63156da 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -28,3 +28,4 @@ hci_uart-$(CONFIG_BT_HCIUART_BCSP)	+= hci_bcsp.o
 hci_uart-$(CONFIG_BT_HCIUART_LL)	+= hci_ll.o
 hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
 hci_uart-objs				:= $(hci_uart-y)
+obj-$(CONFIG_BT_TI)			:= bt_ti.o
diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
deleted file mode 100644
index 074b8e8..0000000
--- a/drivers/staging/ti-st/Kconfig
+++ /dev/null
@@ -1,14 +0,0 @@
-#
-# TI's shared transport line discipline and the protocol
-# drivers (BT, FM and GPS)
-#
-menu "Texas Instruments shared transport line discipline"
-config ST_BT
-	tristate "BlueZ bluetooth driver for ST"
-	depends on BT && RFKILL
-	select TI_ST
-	help
-	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
-	  This makes use of shared transport line discipline core driver to
-	  communicate with the BT core of the combo chip.
-endmenu
diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
deleted file mode 100644
index 5f11b82..0000000
--- a/drivers/staging/ti-st/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for TI's shared transport line discipline
-# and its protocol drivers (BT, FM, GPS)
-#
-obj-$(CONFIG_ST_BT) 		+= bt_drv.o
-- 
1.6.5

