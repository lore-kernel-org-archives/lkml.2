Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab1KWAk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:40:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab1KWAks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.486745749@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [20/53] pch_uart: Support new device LAPIS Semiconductor ML7831 IOH
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 8249f743f732ccbc3056428945ab1d9bd36d46bf upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/Kconfig    |   14 +++++++-------
 drivers/tty/serial/pch_uart.c |    8 ++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1585,7 +1585,7 @@ config SERIAL_IFX6X60
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
 config SERIAL_PCH_UART
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223) UART"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) UART"
 	depends on PCI
 	select SERIAL_CORE
 	help
@@ -1593,12 +1593,12 @@ config SERIAL_PCH_UART
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
 
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -256,6 +256,8 @@ enum pch_uart_num_t {
 	pch_ml7213_uart2,
 	pch_ml7223_uart0,
 	pch_ml7223_uart1,
+	pch_ml7831_uart0,
+	pch_ml7831_uart1,
 };
 
 static struct pch_uart_driver_data drv_dat[] = {
@@ -268,6 +270,8 @@ static struct pch_uart_driver_data drv_d
 	[pch_ml7213_uart2] = {PCH_UART_2LINE, 2},
 	[pch_ml7223_uart0] = {PCH_UART_8LINE, 0},
 	[pch_ml7223_uart1] = {PCH_UART_2LINE, 1},
+	[pch_ml7831_uart0] = {PCH_UART_8LINE, 0},
+	[pch_ml7831_uart1] = {PCH_UART_2LINE, 1},
 };
 
 static unsigned int default_baud = 9600;
@@ -1546,6 +1550,10 @@ static DEFINE_PCI_DEVICE_TABLE(pch_uart_
 	 .driver_data = pch_ml7223_uart0},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x800D),
 	 .driver_data = pch_ml7223_uart1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8811),
+	 .driver_data = pch_ml7831_uart0},
+	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8812),
+	 .driver_data = pch_ml7831_uart1},
 	{0,},
 };
 


