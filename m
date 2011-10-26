Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1JZGIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:08:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47871 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1JZGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:08:03 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 3/3] Add NumaChip quirk
Date: Wed, 26 Oct 2011 14:07:10 +0800
Message-Id: <1319609230-18897-3-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Persvold <sp@numascale.com>

From: Steffen Persvold <sp@numascale.com>

Add quirk for Numascale's NumaChip to prevent resource conflicts.

v2:
 - [Daniel] rediffed and validated against 3.1-rc10

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/pci/quirks.c    |   14 ++++++++++++++
 include/linux/pci_ids.h |    4 ++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1196f61..051b793 100644
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
index ae96bbe..02e0959 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2400,6 +2400,10 @@
 
 #define PCI_VENDOR_ID_AZWAVE		0x1a3b
 
+#define PCI_VENDOR_ID_NUMASCALE		0x1b47
+#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP0 0x0601
+#define PCI_DEVICE_ID_NUMASCALE_NUMACHIP1 0x0602
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
-- 
1.7.5.4

