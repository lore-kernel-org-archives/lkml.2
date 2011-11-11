Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab1KKQPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:15:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1KKQOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:14:49 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, faisal.latif@intel.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH V2 6/6] infiniband/nes: Disable ASPM
Date: Fri, 11 Nov 2011 11:14:24 -0500
Message-Id: <1321028064-644-7-git-send-email-mjg@redhat.com>
In-Reply-To: <1321028064-644-1-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Windows driver .inf disables ASPM on hpsa devices. Do the same.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: faisal.latif@intel.com
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/nes/nes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 5965b3d..ea320f5 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -45,6 +45,7 @@
 #include <linux/if_arp.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
+#include <linux/pci-aspm.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -463,6 +464,9 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	printk(KERN_INFO PFX "NetEffect RNIC driver v%s loading. (%s)\n",
 			DRV_VERSION, pci_name(pcidev));
 
+	pci_disable_link_state(pcidev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	ret = pci_enable_device(pcidev);
 	if (ret) {
 		printk(KERN_ERR PFX "Unable to enable PCI device. (%s)\n", pci_name(pcidev));
-- 
1.7.7.1

