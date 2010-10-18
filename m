Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0JRR12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:27:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36038 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab0JRR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:27:27 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] microblaze: pci-common cleanup
Date: Mon, 18 Oct 2010 10:26:58 -0700
Message-Id: <1287422825-14999-2-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use set_dma_ops and remove now used-once oddly named temp pointer sd.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/microblaze/pci/pci-common.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 55ef532..9631e1d 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1075,8 +1075,6 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 		 bus->number, bus->self ? pci_name(bus->self) : "PHB");
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		struct dev_archdata *sd = &dev->dev.archdata;
-
 		/* Setup OF node pointer in archdata */
 		dev->dev.of_node = pci_device_to_OF_node(dev);
 
@@ -1086,8 +1084,8 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 		set_dev_node(&dev->dev, pcibus_to_node(dev->bus));
 
 		/* Hook up default DMA ops */
-		sd->dma_ops = pci_dma_ops;
-		sd->dma_data = (void *)PCI_DRAM_OFFSET;
+		set_dma_ops(&dev->dev, pci_dma_ops);
+		dev->dev.archdata.dma_data = (void *)PCI_DRAM_OFFSET;
 
 		/* Read default IRQs and fixup if necessary */
 		pci_read_irq_line(dev);
-- 
1.7.1

