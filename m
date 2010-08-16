Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0HPIcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:32:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab0HPIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:32:03 -0400
From: Michal Simek <monstr@monstr.eu>
To: glikely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Fix of/address: Merge all of the bus translation code
Date: Mon, 16 Aug 2010 10:31:53 +0200
Message-Id: <1281947514-25319-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
References: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dbbdee94734bf6f1db7af42008a53655e77cab8f removed
of_irq_pci_swizzle but didn't use pci_swizzle_interrupt_pin
instead.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/prom_parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
index d33ba17..99d9b61 100644
--- a/arch/microblaze/kernel/prom_parse.c
+++ b/arch/microblaze/kernel/prom_parse.c
@@ -73,7 +73,7 @@ int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
 		/* We can only get here if we hit a P2P bridge with no node,
 		 * let's do standard swizzling and try again
 		 */
-		lspec = of_irq_pci_swizzle(PCI_SLOT(pdev->devfn), lspec);
+		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
 		pdev = ppdev;
 	}
 
-- 
1.5.5.6

