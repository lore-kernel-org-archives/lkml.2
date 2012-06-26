Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2FZDdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260Ab2FZDdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:49 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 15/16] xtensa/PCI: Factor 'pcibios_setup()' out of xtensa
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:32:39 -0600
Message-ID: <20120626033239.16434.8338.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core provides a generic (__weak) 'pcibios_setup()' routine 
that can be used by all architectures as a default.  Drop xtensa's
architecture specific version in favor of that as it does not need to be 
over-ridden.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/xtensa/kernel/pci.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index eb30e35..3a2cae4 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -46,7 +46,6 @@
  * pcibios_fixups
  * pcibios_align_resource
  * pcibios_fixup_bus
- * pcibios_setup
  * pci_bus_add_device
  * pci_mmap_page_range
  */
@@ -206,11 +205,6 @@ void __init pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-char __init *pcibios_setup(char *str)
-{
-	return str;
-}
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	/* No special bus mastering setup handling */

