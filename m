Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2ITHWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:22:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2ITHWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:22:03 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/2] ARM: pci: Keep pci_common_init() around after init
Date: Thu, 20 Sep 2012 09:21:49 +0200
Message-Id: <1348125710-28726-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348125710-28726-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348125710-28726-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:/TMVOkrbRjkMZh4qYWb+/iPTVzMkaGQDuHSlTwoArmu
 hGVCqcsIgnyFBpUZ834auogCJ0cBKr7eb0Uw97Wku4oCO3IQz9
 ZYECuVpbwDYZidfajo3mCekE8pDY8UGiBjlysWCuTXF6eTfhi6
 xCcD0Zs2Ap+vVwENiFukXvfM2GGEN11Bd6hBAwDopQTBg/50SW
 BvIkzoGmIuZplbp9djZl1Cp+n0B1/zzj7ExwmenRm39n9A/cxa
 lr3GKEXHWiulx7vLpNE5fOC70ZJ85LoYkQjqoJpOB0EZN2zMb+
 uuwMC6FpLUL5mMWhJhYJf/82vXKRqy4K6YqLJruBVvsDMUsWJO
 M4UYfgq6xiHIWkmpVlRN7eMyid0LAOkrNQs7KIbBCIw68JHLlz
 8Xbn8yACnhPXN29BXMEXnbsP/lQc0HlQsRIt0OKP0hlEcWjHJz
 wkAXv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using deferred driver probing, PCI host controller drivers may
actually require this function after the init stage.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- remove __devinit annotation from pcibios_swizzle
- remove __init annotations altogether

 arch/arm/kernel/bios32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 2b2f25e..6f1d75f 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -388,7 +388,7 @@ EXPORT_SYMBOL(pcibios_fixup_bus);
  * PCI standard swizzle is implemented on plug-in cards and Cardbus based
  * PCI extenders, so it can not be ignored.
  */
-static u8 __devinit pcibios_swizzle(struct pci_dev *dev, u8 *pin)
+static u8 pcibios_swizzle(struct pci_dev *dev, u8 *pin)
 {
 	struct pci_sys_data *sys = dev->sysdata;
 	int slot, oldpin = *pin;
@@ -423,7 +423,7 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
+static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
 	int ret;
@@ -472,7 +472,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 	}
 }
 
-void __init pci_common_init(struct hw_pci *hw)
+void pci_common_init(struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
 	LIST_HEAD(head);
-- 
1.7.12

