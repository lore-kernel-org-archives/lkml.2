Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1GVLTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:19:47 -0400
Received: from [119.75.36.222] ([119.75.36.222]:42632 "EHLO m.1degreenorth.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260Ab1GVLTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:19:45 -0400
X-Greylist: delayed 2040 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 07:19:45 EDT
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>
Cc: Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 3/3] Add NumaChip quirk
Date: Fri, 22 Jul 2011 18:44:36 +0800
Message-Id: <1311331476-8820-3-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311331476-8820-1-git-send-email-daniel@numascale-asia.com>
References: <1311331476-8820-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add quirk for Numascale's NumaChip to prevent resource conflicts.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/pci/quirks.c    |   14 ++++++++++++++
 include/linux/pci_ids.h |    4 ++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 02145e9..4db74e0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2679,6 +2679,20 @@ static void __devinit quirk_hotplug_bridge(struct pci_dev *dev)
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_HINT, 0x0020, quirk_hotplug_bridge);
 
+/* Clear all resources on NumaChip to avoid conflicts */
+static void __devinit numachip_resource_fixup(struct pci_dev *pdev)
+{
+	int i;
+
+	for (i = PCI_STD_RESOURCES; i <= PCI_ROM_RESOURCE; i++)
+		memset(&pdev->resource[i], 0, sizeof(pdev->resource[i]));
+
+	dev_notice(&pdev->dev, "Disabled all PCI resources for NumaChip\n");
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NUMASCALE,
+	PCI_DEVICE_ID_NUMASCALE_NUMACHIP0, numachip_resource_fixup);
+
 /*
  * This is a quirk for the Ricoh MMC controller found as a part of
  * some mulifunction chips.
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f8910e1..50d7319 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2390,6 +2390,10 @@
 
 #define PCI_VENDOR_ID_AZWAVE		0x1a3b
 
+#define PCI_VENDOR_ID_NUMASCALE		0x1b47
+#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP0 0x0601
+#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP1 0x0602
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
-- 
1.7.4.1


