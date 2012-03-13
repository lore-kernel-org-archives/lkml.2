Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2CMRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:16:56 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:52432 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757823Ab2CMRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:16:54 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Chris Ball <cjb@laptop.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 3/3] mmc: sdhci-pci: allow 8-bit bus width for Intel PCH
Date: Tue, 13 Mar 2012 18:16:42 +0100
Message-Id: <1331659002-13743-3-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/mmc/host/sdhci-pci.c |   27 +++++++++++++++++++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 9382f27..0218cb2 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -172,6 +172,12 @@ static int mrst_hc_probe(struct sdhci_pci_chip *chip)
 	return 0;
 }
 
+static int pch_hc_probe_slot(struct sdhci_pci_slot *slot)
+{
+	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
+	return 0;
+}
+
 #ifdef CONFIG_PM_RUNTIME
 
 static irqreturn_t sdhci_pci_sd_cd(int irq, void *dev_id)
@@ -281,6 +287,11 @@ static const struct sdhci_pci_fixes sdhci_intel_mfd_emmc = {
 	.probe_slot	= mfd_emmc_probe_slot,
 };
 
+static const struct sdhci_pci_fixes sdhci_intel_pch_sdio = {
+	.quirks		= SDHCI_QUIRK_BROKEN_ADMA,
+	.probe_slot	= pch_hc_probe_slot,
+};
+
 /* O2Micro extra registers */
 #define O2_SD_LOCK_WP		0xD3
 #define O2_SD_MULTI_VCC3V	0xEE
@@ -817,6 +828,22 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_PCH_SDIO0,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_pch_sdio,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_PCH_SDIO1,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_pch_sdio,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_O2,
 		.device		= PCI_DEVICE_ID_O2_8120,
 		.subvendor	= PCI_ANY_ID,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 31d77af..28cd019 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2800,6 +2800,8 @@
 #define PCI_DEVICE_ID_INTEL_82454NX     0x84cb
 #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
+#define PCI_DEVICE_ID_INTEL_PCH_SDIO0	0x8809
+#define PCI_DEVICE_ID_INTEL_PCH_SDIO1	0x880a
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
-- 
1.7.3.4

