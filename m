Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab1J1Vvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502Ab1J1Vva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:51:30 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 12/16] PCI: MIPS: use generic pcibios_set_master()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:52 -0600
Message-ID: <20111028214852.20088.56654.stgit@amt.stowe>
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

This patch removes mip's architecture-specific 'pcibios_set_master()'
routine and lets the default PCI core based implementation handle PCI
device 'latency timer' setup.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mips/pci/pci.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index a6de9b8..19cce25 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -204,21 +204,6 @@ static int pcibios_enable_resources(struct pci_dev *dev, int mask)
 	return 0;
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
-	printk(KERN_DEBUG "PCI: Setting latency timer of device %s to %d\n",
-	       pci_name(dev), lat);
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
-}
-
 unsigned int pcibios_assign_all_busses(void)
 {
 	return (pci_probe & PCI_ASSIGN_ALL_BUSSES) ? 1 : 0;

