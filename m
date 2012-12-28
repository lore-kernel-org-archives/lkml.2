Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2L1TNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:13:35 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:40502 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2L1TNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:13:33 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, shangw@linux.vnet.ibm.com, paulus@samba.org,
        bhelgaas@google.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 1/2] EEH/OF: checking for CONFIG_EEH is not needed
Date: Fri, 28 Dec 2012 17:13:18 -0200
Message-Id: <1356721999-25159-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20121228120616.GB21831@oc0268524204.ibm.com>
References: <20121228120616.GB21831@oc0268524204.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122819-9254-0000-0000-00000B38F303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions used are already defined as empty inline functions for the
case where EEH is disabled.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/of_platform.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 2049f2d..c5fc6b2 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -71,10 +71,8 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev)
 	eeh_dev_phb_init_dynamic(phb);
 
 	/* Register devices with EEH */
-#ifdef CONFIG_EEH
 	if (dev->dev.of_node->child)
 		eeh_add_device_tree_early(dev->dev.of_node);
-#endif /* CONFIG_EEH */
 
 	/* Scan the bus */
 	pcibios_scan_phb(phb);
@@ -88,9 +86,7 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev)
 	pcibios_claim_one_bus(phb->bus);
 
 	/* Finish EEH setup */
-#ifdef CONFIG_EEH
 	eeh_add_device_tree_late(phb->bus);
-#endif
 
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
-- 
1.7.1

