Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab1J1Vtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512Ab1J1Vtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:49:47 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 15/16] PCI: x86: use generic pcibios_set_master()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:49:13 -0600
Message-ID: <20111028214913.20088.26251.stgit@amt.stowe>
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

This patch removes x86's architecture-specific 'pcibios_set_master()'
routine and lets the default PCI core based implementation handle PCI
device 'latency timer' setup.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/i386.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5663bc2..463c247 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -253,20 +253,6 @@ void __init pcibios_resource_survey(void)
  */
 fs_initcall(pcibios_assign_resources);
 
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
-	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
-}
-
 static const struct vm_operations_struct pci_mmap_ops = {
 	.access = generic_access_phys,
 };

