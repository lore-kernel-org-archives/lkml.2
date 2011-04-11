Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1DKENN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:13:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59096 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1DKENC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:13:02 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 6/6] pci/of: Consolidate pci_bus_to_OF_node()
Date: Mon, 11 Apr 2011 14:12:50 +1000
Message-Id: <1302495170-973-7-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
References: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic code always get the device-node in the right place now
so a single implementation will work for all archs

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/include/asm/pci-bridge.h |    5 -----
 arch/powerpc/include/asm/pci-bridge.h    |    5 -----
 arch/x86/include/asm/prom.h              |    6 ------
 include/linux/pci.h                      |    5 +++++
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 0d74d03..242be57 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -102,11 +102,6 @@ struct pci_controller {
 };
 
 #ifdef CONFIG_PCI
-static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
-{
-	return bus->dev.of_node;
-}
-
 static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 {
 	return bus->sysdata;
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 578060e..90bd3ed 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -169,11 +169,6 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 	return bus->sysdata;
 }
 
-static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
-{
-	return bus->dev.of_node;
-}
-
 #ifndef CONFIG_PPC64
 
 extern int pci_device_from_OF_node(struct device_node *node,
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index dd6066a..df12870 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -30,12 +30,6 @@ extern void add_dtb(u64 data);
 extern void x86_add_irq_domains(void);
 void __cpuinit x86_of_pci_init(void);
 void x86_dtb_init(void);
-
-static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
-{
-	return pci_device_to_OF_node(bus->self);
-}
-
 #else
 static inline void add_dtb(u64 data) { }
 static inline void x86_add_irq_domains(void) { }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 73dab8a..532c4e8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1559,6 +1559,11 @@ static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
 	return pdev ? pdev->dev.of_node : NULL;
 }
 
+static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
+{
+	return bus ? bus->dev.of_node : NULL;
+}
+
 #else /* CONFIG_OF */
 static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
-- 
1.7.1

