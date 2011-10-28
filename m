Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1J1Vs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:48:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab1J1Vs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:27 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 03/16] PCI: IA64: convert pcibios_set_master() to a
	non-inlined function
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:47:49 -0600
Message-ID: <20111028214749.20088.61354.stgit@amt.stowe>
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

This patch converts IA64's architecture-specific 'pcibios_set_master()'
routine to a non-inlined function.  This will allow follow on
patches to create a generic 'pcibios_set_master()' function using the
'__weak' attribute which can be used by all architectures as a default
which, if necessary, can then be over-ridden by architecture-
specific code.

Converting 'pci_bios_set_master()' to a non-inlined function will allow
IA64's 'pcibios_set_master()' implementation to remain architecture-
specific after the generic version is introduced and thus, not change
current behavior.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/ia64/include/asm/pci.h |    6 ------
 arch/ia64/pci/pci.c         |    5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 73b5f78..6e3d91e 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -43,12 +43,6 @@ extern unsigned long ia64_max_iommu_merge_mask;
 #define PCI_DMA_BUS_IS_PHYS	(ia64_max_iommu_merge_mask == ~0UL)
 
 static inline void
-pcibios_set_master (struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-
-static inline void
 pcibios_penalize_isa_irq (int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index aa2533a..8273acb 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -513,6 +513,11 @@ pcibios_fixup_bus (struct pci_bus *b)
 	return;
 }
 
+void pcibios_set_master (struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
 void __devinit
 pcibios_update_irq (struct pci_dev *dev, int irq)
 {

