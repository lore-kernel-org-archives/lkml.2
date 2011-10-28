Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1J1Afb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:35:31 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1252 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab1J1Afa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:35:30 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] spi-topcliff-pch: Support new device LAPIS Semiconductor ML7831 IOH
Date: Fri, 28 Oct 2011 09:35:21 +0900
Message-Id: <1319762122-7019-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/spi/Kconfig            |    6 +++---
 drivers/spi/spi-topcliff-pch.c |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a1fd73d..6168516 100644
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
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 6a80749..2b1e966 100644
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
 
@@ -218,6 +220,7 @@ static struct pci_device_id pch_spi_pcidev_id[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_SPI), 1, },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_SPI), 1, },
 	{ }
 };
 
-- 
1.7.4.4

