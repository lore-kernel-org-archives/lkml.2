Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab0JGRe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:34:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60284 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0JGReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:34:23 -0400
From: pavan_savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/2] drivers:bluetooth: Kconfig & Makefile for TI BT
Date: Thu,  7 Oct 2010 14:47:17 -0400
Message-Id: <1286477237-7526-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
References: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
 <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Kconfig and Makefile modifications to enable the Bluetooth
driver for Texas Instrument's WiLink 7 chipset.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/bluetooth/Kconfig  |   10 ++++++++++
 drivers/bluetooth/Makefile |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 02deef4..936d8ce 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -219,4 +219,14 @@ config BT_ATH3K
 	  Say Y here to compile support for "Atheros firmware download driver"
 	  into the kernel or say M to compile it as module (ath3k).
 
+config BT_TI
+	tristate "BlueZ bluetooth driver for TI ST"
+	depends on TI_ST
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
-- 
1.6.5

