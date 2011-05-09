Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1EIIZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:25:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30648 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab1EIIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:25:41 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_uart: Support new device ML7223 IOH
Date: Mon,  9 May 2011 17:25:20 +0900
Message-Id: <1304929520-5798-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
The ML7223 IOH is for MP(Media Phone) use.
The ML7223 is companion chip for Intel Atom E6xx series.
The ML7223 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/Kconfig    |   12 +++++++-----
 drivers/tty/serial/pch_uart.c |    8 ++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 80484af..2b9f47b 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1577,7 +1577,7 @@ config SERIAL_IFX6X60
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
 config SERIAL_PCH_UART
-	tristate "Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
+	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223) UART"
 	depends on PCI
 	select SERIAL_CORE
 	help
@@ -1585,10 +1585,12 @@ config SERIAL_PCH_UART
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  Enabling PCH_DMA, this PCH UART works as DMA mode.
 
-	  This driver also can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/
-	  Output Hub) which is for IVI(In-Vehicle Infotainment) use.
-	  ML7213 is companion chip for Intel Atom E6xx series.
-	  ML7213 is completely compatible for Intel EG20T PCH.
+	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
+	  Output Hub), ML7213 and ML7223.
+	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
+	  for MP(Media Phone) use.
+	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 26403b8..c63d0d1 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -253,6 +253,8 @@ enum pch_uart_num_t {
 	pch_ml7213_uart0,
 	pch_ml7213_uart1,
 	pch_ml7213_uart2,
+	pch_ml7223_uart0,
+	pch_ml7223_uart1,
 };
 
 static struct pch_uart_driver_data drv_dat[] = {
@@ -263,6 +265,8 @@ static struct pch_uart_driver_data drv_dat[] = {
 	[pch_ml7213_uart0] = {PCH_UART_8LINE, 0},
 	[pch_ml7213_uart1] = {PCH_UART_2LINE, 1},
 	[pch_ml7213_uart2] = {PCH_UART_2LINE, 2},
+	[pch_ml7223_uart0] = {PCH_UART_8LINE, 0},
+	[pch_ml7223_uart1] = {PCH_UART_2LINE, 1},
 };
 
 static unsigned int default_baud = 9600;
@@ -1534,6 +1538,10 @@ static DEFINE_PCI_DEVICE_TABLE(pch_uart_pci_id) = {
 	 .driver_data = pch_ml7213_uart1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8029),
 	 .driver_data = pch_ml7213_uart2},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x800C),
+	 .driver_data = pch_ml7223_uart0},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x800D),
+	 .driver_data = pch_ml7223_uart1},
 	{0,},
 };
 
-- 
1.7.4

