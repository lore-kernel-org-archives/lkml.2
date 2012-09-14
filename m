Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2INUpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:45:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2INUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:45:06 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/2] PCI: Annotate pci_fixup_irqs with __devinit
Date: Fri, 14 Sep 2012 22:44:15 +0200
Message-Id: <1347655456-2542-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:Nom7qgQWtfUTmgDSmVNYlmmvP9AxgzwH/qrwOy7eCMz
 patGWO1MF3YdfI0U6+I20HshBj73o08NLfjOhLOZF6OYJkflk2
 42y+hd/25nIP+6K3/YROuzb5xFlOeXsUEVmlHdPpGyG7M7EIJu
 R5qG+Ri5cXdRiYMcLXqHRljqpottpzl4LL1dJWtYeGB6FJ0wsF
 UItkdTl0SPIMC6Pwq1C0a7OJKkXufei6XKpZc6hDfNsmBERfRy
 FaqxiCgx8ud7GlKEiPVMLCt0Gp3Ap9+M73Oa9Nmhv/X4W5PHJk
 /JcZTM7ywLVAwgRvy5cCM2h9n6HaOnWmR4rNTBEZYVJpurQy7j
 hL7szTDcDTp5JgX2CDK50J7R+kgG78RZEWWLS7n0mMJYl6EoAh
 1nkMHQRPdyfq79Q0NQ7GHuWCj/Ioel0Imsa9ZF/8cLlDtsTr+O
 CqWKh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep pci_fixup_irqs() around after init (e.g. for hotplug),
mark it __devinit instead of __init. This requires the same change for
the implementation of the pcibios_update_irq() function on all
architectures.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note: Ideally these annotations should go away completely in order to
be independent of the HOTPLUG symbol. However, there is work underway
to get rid of HOTPLUG altogether, so I've kept the __devinit for now.

 arch/alpha/kernel/pci.c   | 2 +-
 arch/mips/pci/pci.c       | 2 +-
 arch/sh/drivers/pci/pci.c | 2 +-
 arch/x86/pci/visws.c      | 2 +-
 arch/xtensa/kernel/pci.c  | 2 +-
 drivers/pci/setup-irq.c   | 4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 9816d5a..6192b35 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -256,7 +256,7 @@ pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-void __init
+void __devinit
 pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 6903568..af3dc05 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -313,7 +313,7 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-void __init
+void __devinit
 pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 40db2d0..d16fabe 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -192,7 +192,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void __init pcibios_update_irq(struct pci_dev *dev, int irq)
+void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 6f2f8ee..15bdfbf 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -62,7 +62,7 @@ out:
 	return irq;
 }
 
-void __init pcibios_update_irq(struct pci_dev *dev, int irq)
+void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 69759e9..efc3369 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -212,7 +212,7 @@ void pcibios_set_master(struct pci_dev *dev)
 
 /* the next one is stolen from the alpha port... */
 
-void __init
+void __devinit
 pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index eb219a1..f0bcd56 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -18,7 +18,7 @@
 #include <linux/cache.h>
 
 
-static void __init
+static void __devinit
 pdev_fixup_irq(struct pci_dev *dev,
 	       u8 (*swizzle)(struct pci_dev *, u8 *),
 	       int (*map_irq)(const struct pci_dev *, u8, u8))
@@ -54,7 +54,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 	pcibios_update_irq(dev, irq);
 }
 
-void __init
+void __devinit
 pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
 	       int (*map_irq)(const struct pci_dev *, u8, u8))
 {
-- 
1.7.12

