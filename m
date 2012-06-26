Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2FZDdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732Ab2FZDcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:50 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 06/16] MIPS/PCI: adjust section annotations for
	'pcibios_setup()'
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
Date: Mon, 25 Jun 2012 21:31:37 -0600
Message-ID: <20120626033137.16434.79166.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pcibios_setup() consistently use the "__init" section annotation.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mips/pci/pci.c          |    4 ++--
 arch/mips/txx9/generic/pci.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 271e8c4..0e111d2 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -348,9 +348,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot);
 }
 
-char * (*pcibios_plat_setup)(char *str) __devinitdata;
+char * (*pcibios_plat_setup)(char *str) __initdata;
 
-char *__devinit pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (pcibios_plat_setup)
 		return pcibios_plat_setup(str);
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 682efb0..f028e3d 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -398,9 +398,9 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return txx9_board_vec->pci_map_irq(dev, slot, pin);
 }
 
-char * (*txx9_board_pcibios_setup)(char *str) __devinitdata;
+char * (*txx9_board_pcibios_setup)(char *str) __initdata;
 
-char *__devinit txx9_pcibios_setup(char *str)
+char *__init txx9_pcibios_setup(char *str)
 {
 	if (txx9_board_pcibios_setup && !txx9_board_pcibios_setup(str))
 		return NULL;

