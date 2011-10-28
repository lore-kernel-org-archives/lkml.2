Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab1J1Vsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518Ab1J1Vsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:52 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 07/16] PCI: TILE: convert pcibios_set_master() to a
	non-inlined function
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:17 -0600
Message-ID: <20111028214817.20088.15009.stgit@amt.stowe>
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

This patch converts TILE's architecture-specific 'pcibios_set_master()'
routine to a non-inlined function.  This will allow follow on patches
to create a generic 'pcibios_set_master()' function using the '__weak'
attribute which can be used by all architectures as a default which,
if necessary, can then be over-ridden by architecture-specific code.

Converting 'pci_bios_set_master()' to a non-inlined function will
allow TILE's 'pcibios_set_master()' implementation to remain
architecture-specific after the generic version is introduced and
thus, not change current behavior.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/tile/include/asm/pci.h |    7 -------
 arch/tile/kernel/pci.c      |    5 +++++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 7f03cef..2a2abc7 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -76,13 +76,6 @@ static inline int pcibios_assign_all_busses(void)
 	return 1;
 }
 
-/*
- * No special bus mastering setup handling.
- */
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-}
-
 #define PCIBIOS_MIN_MEM		0
 #define PCIBIOS_MIN_IO		0
 
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 2a8014c..08b8943 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -394,6 +394,11 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 	/* Nothing needs to be done. */
 }
 
+void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling. */
+}
+
 /*
  * This can be called from the generic PCI layer, but doesn't need to
  * do anything.

