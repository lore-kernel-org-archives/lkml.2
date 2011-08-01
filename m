Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1HAQnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:43:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:54922 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HAQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:42:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux@arm.linux.org.uk, ralf@linux-mips.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: fix compile failure in orion5x/dns323-setup.c
Date: Mon,  1 Aug 2011 12:42:14 -0400
Message-Id: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit d5341942d784134f2997b3ff82cd63cf71d1f932 "PCI: Make the
struct pci_dev * argument of pci_fixup_irqs const." leaked an extra
"const" into an actual call site (vs a proto/decl) which causes this:

arch/arm/mach-orion5x/dns323-setup.c: In function 'dns323_pci_map_irq':
arch/arm/mach-orion5x/dns323-setup.c:80: error: expected expression before 'const'
arch/arm/mach-orion5x/dns323-setup.c:80: error: too few arguments to function 'orion5x_pci_map_irq'
make[3]: *** [arch/arm/mach-orion5x/dns323-setup.o] Error 1

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
index a6eddae..c105556 100644
--- a/arch/arm/mach-orion5x/dns323-setup.c
+++ b/arch/arm/mach-orion5x/dns323-setup.c
@@ -77,7 +77,7 @@ static int __init dns323_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	/*
 	 * Check for devices with hard-wired IRQs.
 	 */
-	irq = orion5x_pci_map_irq(const dev, slot, pin);
+	irq = orion5x_pci_map_irq(dev, slot, pin);
 	if (irq != -1)
 		return irq;
 
-- 
1.7.6

