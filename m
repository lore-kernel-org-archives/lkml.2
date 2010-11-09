Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0KITym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:54:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38880 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0KITyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IRhPxNdGTUHhoITA93wQGrWAeBtVnAl3fL5nIXVDoPryRzB42MmQFv2aH/igRxOnFX
         DXNr/MHMFnTWj2LpzYsTDJsgjextMCbj8Od4zrf8Zt4lFf3Rbif5Z9D7Xy2B3wnpJAxU
         jXA5iU+rIkX0m4SX05utGkrBQk3mDWvj3Ly/0=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, x86@kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 5/6] x86: ce4100: Add reboot_fixup() for CE4100
Date: Tue,  9 Nov 2010 12:08:08 -0800
Message-Id: <5bdcfb4f0206fa721570504e95659a03b815bc5e.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289331834.git.dirk.brandewie@gmail.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds the CE4100 reboot fixup to reboot_fixups_32.c

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/kernel/reboot_fixups_32.c |   11 +++++++++++
 include/linux/pci_ids.h            |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 84236c9..d9f3fcf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -383,6 +383,7 @@ config X86_INTEL_CE
 	depends on PCI_GODIRECT
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	select X86_REBOOTFIXUPS
 	---help---
 	  Select for the Intel CE media processor (CE4100) SOC.
 	  This option compiles in support for the CE4100 SOC for settop
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index fda313e..1bb5531 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -43,6 +43,16 @@ static void rdc321x_reset(struct pci_dev *dev)
 	outb(1, 0x92);
 }
 
+static void ce4100_reset(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		outb(0x2, 0xcf9);
+		udelay(50);
+	}
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -54,6 +64,7 @@ static const struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 { PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE, cs5530a_warm_reset },
 { PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
+{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100, ce4100_reset },
 };
 
 /*
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8fc40b6..84f7130 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2434,6 +2434,7 @@
 #define PCI_DEVICE_ID_INTEL_82375	0x0482
 #define PCI_DEVICE_ID_INTEL_82424	0x0483
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
+#define PCI_DEVICE_ID_INTEL_CE4100	0x0708
 #define PCI_DEVICE_ID_INTEL_MRST_SD0	0x0807
 #define PCI_DEVICE_ID_INTEL_MRST_SD1	0x0808
 #define PCI_DEVICE_ID_INTEL_MFD_SD	0x0820
-- 
1.7.2.3

