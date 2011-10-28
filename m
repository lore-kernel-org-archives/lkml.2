Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1J1AX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:23:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6771 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab1J1AX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:23:56 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] pch_gpio: Support new device LAPIS Semiconductor ML7831 IOH
Date: Fri, 28 Oct 2011 09:23:32 +0900
Message-Id: <1319761413-6438-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/gpio/Kconfig    |   11 ++++++-----
 drivers/gpio/gpio-pch.c |    1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a107d44..82c4496 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -387,7 +387,7 @@ config GPIO_LANGWELL
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
-	bool "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
+	bool "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7223/ML7831) GPIO"
 	depends on PCI && X86
 	select GENERIC_IRQ_CHIP
 	help
@@ -395,11 +395,12 @@ config GPIO_PCH
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  This driver can access PCH GPIO device.
 
-	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
-	  Output Hub), ML7223.
+	  This driver also can be used for LAPIS Semiconductor IOH(Input/
+	  Output Hub), ML7223 and ML7831.
 	  ML7223 IOH is for MP(Media Phone) use.
-	  ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7223 is completely compatible for Intel EG20T PCH.
+	  ML7831 IOH is for general purpose use.
+	  ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 config GPIO_ML_IOH
 	bool "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 64b0e39..8d9116f 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -524,6 +524,7 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8043) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8803) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
-- 
1.7.4.4

