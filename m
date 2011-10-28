Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab1J1Vss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518Ab1J1Vsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:45 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 06/16] PCI: SPARC: convert pcibios_set_master() to a
	non-inlined function
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:10 -0600
Message-ID: <20111028214810.20088.17628.stgit@amt.stowe>
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

This patch converts SPARC's architecture-specific
'pcibios_set_master()' routine to a non-inlined function.  This will
allow follow on patches to create a generic 'pcibios_set_master()'
function using the '__weak' attribute which can be used by all
architectures as a default which, if necessary, can then be over-
ridden by architecture-specific code.

Converting 'pci_bios_set_master()' to a non-inlined function will
allow SPARC's 'pcibios_set_master()' implementation to remain
architecture-specific after the generic version is introduced and
thus, not change current behavior.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/sparc/include/asm/pci_32.h |    5 -----
 arch/sparc/include/asm/pci_64.h |    5 -----
 arch/sparc/kernel/pci.c         |    5 +++++
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index 02939ab..6de7f7b 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -16,11 +16,6 @@
 
 #define PCI_IRQ_NONE		0xffffffff
 
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-
 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 2614d96..755a4bb 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -16,11 +16,6 @@
 
 #define PCI_IRQ_NONE		0xffffffff
 
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-
 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1e94f94..269c011 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -1082,6 +1082,11 @@ void pci_resource_to_user(const struct pci_dev *pdev, int bar,
 	*end = rp->end - offset;
 }
 
+void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
 static int __init pcibios_init(void)
 {
 	pci_dfl_cache_line_size = 64 >> 2;

