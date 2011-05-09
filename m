Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1EIK66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:58:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22188 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab1EIK65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:58:57 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_gpio: Support new device ML7223
Date: Mon,  9 May 2011 19:58:49 +0900
Message-Id: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
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
 drivers/gpio/Kconfig    |    8 +++++++-
 drivers/gpio/pch_gpio.c |    2 ++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..c0326da 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -329,13 +329,19 @@ config GPIO_LANGWELL
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
-	tristate "PCH GPIO of Intel Topcliff"
+	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
 	depends on PCI && X86
 	help
 	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  This driver can access PCH GPIO device.
 
+	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
+	  Output Hub), ML7223.
+	  ML7223 IOH is for MP(Media Phone) use.
+	  ML7223 is companion chip for Intel Atom E6xx series.
+	  ML7223 is completely compatible for Intel EG20T PCH.
+
 config GPIO_ML_IOH
 	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
 	depends on PCI
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index f970a5f..36919e7 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -283,8 +283,10 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 #define pch_gpio_resume NULL
 #endif
 
+#define PCI_VENDOR_ID_ROHM             0x10DB
 static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
-- 
1.7.4

