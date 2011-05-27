Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1E0FFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:05:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11206 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab1E0FFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:05:03 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v2 2/3] pch_gpio: Support new device ML7223
Date: Fri, 27 May 2011 14:04:50 +0900
Message-Id: <1306472691-6055-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1306472691-6055-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1306472691-6055-1-git-send-email-tomoya-linux@dsn.okisemi.com>
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
 drivers/gpio/pch_gpio.c |    1 +
 include/linux/pci_ids.h |    2 ++
 3 files changed, 10 insertions(+), 1 deletions(-)

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
index 4d1c9c6..b46c2bd 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -285,6 +285,7 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EG20TPCH_GPIO) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6322199..c249218 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1077,6 +1077,8 @@
 #define PCI_VENDOR_ID_TCONRAD		0x10da
 #define PCI_DEVICE_ID_TCONRAD_TOKENRING	0x0508
 
+#define PCI_VENDOR_ID_ROHM             0x10DB
+
 #define PCI_VENDOR_ID_NVIDIA			0x10de
 #define PCI_DEVICE_ID_NVIDIA_TNT		0x0020
 #define PCI_DEVICE_ID_NVIDIA_TNT2		0x0028
-- 
1.7.4

