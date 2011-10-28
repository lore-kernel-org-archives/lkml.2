Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab1J1Vtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512Ab1J1Vti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:49:38 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 14/16] PCI: sh: use generic pcibios_set_master()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:49:06 -0600
Message-ID: <20111028214906.20088.7056.stgit@amt.stowe>
In-Reply-To: <20111028214726.20088.30551.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

This patch removes sh's architecture-specific 'pcibios_set_master()'
routine and lets the default PCI core based implementation handle PCI
device 'latency timer' setup.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/sh/drivers/pci/pci.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index a0c92fd..280e2a1 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -242,21 +242,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void pcibios_set_master(struct pci_dev *dev)
-{
-	u8 lat;
-	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
-	if (lat < 16)
-		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;
-	else if (lat > pcibios_max_latency)
-		lat = pcibios_max_latency;
-	else
-		return;
-	printk(KERN_INFO "PCI: Setting latency timer of device %s to %d\n",
-	       pci_name(dev), lat);
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
-}
-
 void __init pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);

