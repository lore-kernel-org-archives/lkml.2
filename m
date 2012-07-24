Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2GXQf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:35:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2GXQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:35:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 13/32] PCI/MIPS: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:25 +0800
Message-Id: <1343147504-25891-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe MIPS implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/mips/pci/pci-octeon.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 52a1ba7..fac6308 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -117,15 +117,14 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 	}
 
 	/* Enable the PCIe normal error reporting */
-	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
-	if (pos) {
+	if (pci_is_pcie(dev)) {
 		/* Update Device Control */
-		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &config);
+		pci_pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &config);
 		config |= PCI_EXP_DEVCTL_CERE; /* Correctable Error Reporting */
 		config |= PCI_EXP_DEVCTL_NFERE; /* Non-Fatal Error Reporting */
 		config |= PCI_EXP_DEVCTL_FERE;  /* Fatal Error Reporting */
 		config |= PCI_EXP_DEVCTL_URRE;  /* Unsupported Request */
-		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, config);
+		pci_pcie_capability_write_word(dev, PCI_EXP_DEVCTL, config);
 	}
 
 	/* Find the Advanced Error Reporting capability */
-- 
1.7.9.5

