Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2ITHoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:44:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2ITHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:43:56 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] ARM: pci: Keep pci_common_init() around after init
Date: Thu, 20 Sep 2012 09:43:44 +0200
Message-Id: <1348127025-29461-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:BbqeNjT2yG8C6pf3QOO+Zwp3pG8KlnYkbuQG2LgEFxx
 qSWxknbZ9WOU49QLjQi0urE8agXEGKhqxMdf64s0Vh3IkeoeY5
 LtO6i+lXDXrdNc+3vllYGHPe5J7YXkMf0qwDUUUOjS0FkfoSOZ
 shX1vlZzduYA6MeeNbE2LPVJJa76wC/gTOcpxpVb714b4psTsO
 EGAb7rBhJCq8p91bW13SJeiqcpBT0f63n7ib82UhFTJgZ9eWN9
 pMVp414FcFeZxW0A0+trKdlVZ7S78hgBmvKcZm5b31vkzRoldG
 18S38BFvlLbTI4R0yfoENVXQJBCV/ABgW/7xv1oXIOGuq1b8Gt
 IqXt0jtHwwjnRF+PfsFnpspDY/RaHetrQrzWib1ObkCH0QHjKg
 gk/h6B3/oR34R27luw0KxH961qVVNrrjbq/VJCtGXqk7EpJtVf
 xQH/S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using deferred driver probing, PCI host controller drivers may
actually require this function after the init stage.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v3:
- remove __init annotation from pcibios_init_resources()

Changes in v2:
- remove __devinit annotation from pcibios_swizzle
- remove __init annotations altogether

 arch/arm/kernel/bios32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index b244696..2c80f36 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(pcibios_fixup_bus);
  * PCI standard swizzle is implemented on plug-in cards and Cardbus based
  * PCI extenders, so it can not be ignored.
  */
-static u8 __devinit pcibios_swizzle(struct pci_dev *dev, u8 *pin)
+static u8 pcibios_swizzle(struct pci_dev *dev, u8 *pin)
 {
 	struct pci_sys_data *sys = dev->sysdata;
 	int slot, oldpin = *pin;
@@ -424,7 +424,7 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static int __init pcibios_init_resources(int busnr, struct pci_sys_data *sys)
+static int pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 {
 	int ret;
 	struct pci_host_bridge_window *window;
@@ -456,7 +456,7 @@ static int __init pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 	return 0;
 }
 
-static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
+static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
 	int ret;
@@ -504,7 +504,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 	}
 }
 
-void __init pci_common_init(struct hw_pci *hw)
+void pci_common_init(struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
 	LIST_HEAD(head);
-- 
1.7.12

