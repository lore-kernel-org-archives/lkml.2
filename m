Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2GXQfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:35:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59725 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2GXQfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:35:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 12/32] PCI/ARM: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:24 +0800
Message-Id: <1343147504-25891-13-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe ARM implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm/mach-tegra/pcie.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index 0e09137..e41e64d 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -368,16 +368,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
 static void __devinit tegra_pcie_relax_enable(struct pci_dev *dev)
 {
 	u16 val16;
-	int pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 
-	if (pos <= 0) {
+	if (!pci_is_pcie(dev)) {
 		dev_err(&dev->dev, "skipping relaxed ordering fixup\n");
 		return;
 	}
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &val16);
+	pci_pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &val16);
 	val16 |= PCI_EXP_DEVCTL_RELAX_EN;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, val16);
+	pci_pcie_capability_write_word(dev, PCI_EXP_DEVCTL, val16);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
 
-- 
1.7.9.5

