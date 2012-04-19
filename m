Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab2DSVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:18:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253Ab2DSVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:18:05 -0400
Message-Id: <20120419210823.860295342@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 61/68] spi-topcliff-pch: Support new device LAPIS Semiconductor
 ML7831 IOH
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 92b3a5c1bc3c7da1ae4675d014124f4a97ddb632 upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/Kconfig            |    6 +++---
 drivers/spi/spi-topcliff-pch.c |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -346,14 +346,14 @@ config SPI_TI_SSP
 	  serial port.
 
 config SPI_TOPCLIFF_PCH
-	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI controller"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) SPI"
 	depends on PCI
 	help
 	  SPI driver for the Topcliff PCH (Platform Controller Hub) SPI bus
 	  used in some x86 embedded processors.
 
-	  This driver also supports the ML7213, a companion chip for the
-	  Atom E6xx series and compatible with the Intel EG20T PCH.
+	  This driver also supports the ML7213/ML7223/ML7831, a companion chip
+	  for the Atom E6xx series and compatible with the Intel EG20T PCH.
 
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -95,16 +95,18 @@
 #define PCH_CLOCK_HZ		50000000
 #define PCH_MAX_SPBR		1023
 
-/* Definition for ML7213 by OKI SEMICONDUCTOR */
+/* Definition for ML7213/ML7831 by OKI SEMICONDUCTOR */
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_SPI	0x802c
 #define PCI_DEVICE_ID_ML7223_SPI	0x800F
+#define PCI_DEVICE_ID_ML7831_SPI	0x8816
 
 /*
  * Set the number of SPI instance max
  * Intel EG20T PCH :		1ch
  * OKI SEMICONDUCTOR ML7213 IOH :	2ch
  * OKI SEMICONDUCTOR ML7223 IOH :	1ch
+ * OKI SEMICONDUCTOR ML7831 IOH :	1ch
 */
 #define PCH_SPI_MAX_DEV			2
 
@@ -218,6 +220,7 @@ static struct pci_device_id pch_spi_pcid
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_SPI), 1, },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_SPI), 1, },
 	{ }
 };
 


