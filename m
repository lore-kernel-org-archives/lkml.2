Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1J1AjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:39:10 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40099 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab1J1AjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:39:08 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] pch_uart: Support new device LAPIS Semiconductor ML7831 IOH
Date: Fri, 28 Oct 2011 09:38:49 +0900
Message-Id: <1319762330-7134-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/tty/serial/Kconfig    |   14 +++++++-------
 drivers/tty/serial/pch_uart.c |    8 ++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 956f2f0..13e5f51 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1560,7 +1560,7 @@ config SERIAL_IFX6X60
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
 config SERIAL_PCH_UART
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223) UART"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) UART"
 	depends on PCI
 	select SERIAL_CORE
 	help
@@ -1568,12 +1568,12 @@ config SERIAL_PCH_UART
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  Enabling PCH_DMA, this PCH UART works as DMA mode.
 
-	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
-	  Output Hub), ML7213 and ML7223.
-	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
-	  for MP(Media Phone) use.
-	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
+	  This driver also can be used for LAPIS Semiconductor IOH(Input/
+	  Output Hub), ML7213, ML7223 and ML7831.
+	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use, ML7223 IOH is
+	  for MP(Media Phone) use and ML7831 IOH is for general purpose use.
+	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 config SERIAL_PCH_UART_CONSOLE
 	bool "Support for console on Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 1a076cd..6405dd1 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -265,6 +265,8 @@ enum pch_uart_num_t {
 	pch_ml7213_uart2,
 	pch_ml7223_uart0,
 	pch_ml7223_uart1,
+	pch_ml7831_uart0,
+	pch_ml7831_uart1,
 };
 
 static struct pch_uart_driver_data drv_dat[] = {
@@ -277,6 +279,8 @@ static struct pch_uart_driver_data drv_dat[] = {
 	[pch_ml7213_uart2] = {PCH_UART_2LINE, 2},
 	[pch_ml7223_uart0] = {PCH_UART_8LINE, 0},
 	[pch_ml7223_uart1] = {PCH_UART_2LINE, 1},
+	[pch_ml7831_uart0] = {PCH_UART_8LINE, 0},
+	[pch_ml7831_uart1] = {PCH_UART_2LINE, 1},
 };
 
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
@@ -1712,6 +1716,10 @@ static DEFINE_PCI_DEVICE_TABLE(pch_uart_pci_id) = {
 	 .driver_data = pch_ml7223_uart0},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x800D),
 	 .driver_data = pch_ml7223_uart1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8811),
+	 .driver_data = pch_ml7831_uart0},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8812),
+	 .driver_data = pch_ml7831_uart1},
 	{0,},
 };
 
-- 
1.7.4.4

