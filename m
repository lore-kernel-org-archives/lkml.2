Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab1J1VtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933586Ab1J1VtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:49:03 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 09/16] PCI: Xtensa: convert pcibios_set_master() to a
	non-inlined function
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:31 -0600
Message-ID: <20111028214831.20088.34181.stgit@amt.stowe>
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

This patch converts Xtensa's architecture-specific
'pcibios_set_master()' routine to a non-inlined function.  This will
allow follow on patches to create a generic 'pcibios_set_master()'
function using the '__weak' attribute which can be used by all
architectures as a default which, if necessary, can then be over-
ridden by architecture-specific code.

Converting 'pci_bios_set_master()' to a non-inlined function will
allow Xtensa's 'pcibios_set_master()' implementation to remain
architecture-specific after the generic version is introduced and
thus, not change current behavior.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/xtensa/include/asm/pci.h |    5 -----
 arch/xtensa/kernel/pci.c      |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/include/asm/pci.h b/arch/xtensa/include/asm/pci.h
index 4609b0f..05244f0 100644
--- a/arch/xtensa/include/asm/pci.h
+++ b/arch/xtensa/include/asm/pci.h
@@ -22,11 +22,6 @@
 
 extern struct pci_controller* pcibios_alloc_controller(void);
 
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-	/* No special bus mastering setup handling */
-}
-
 static inline void pcibios_penalize_isa_irq(int irq)
 {
 	/* We don't do dynamic PCI IRQ allocation */
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index cd10269..644b2d4 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -227,6 +227,11 @@ char __init *pcibios_setup(char *str)
 	return str;
 }
 
+void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
 /* the next one is stolen from the alpha port... */
 
 void __init

