Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992703Ab2JYUWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:22:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52499 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992646Ab2JYUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:22:22 -0400
Message-ID: <201210252022.q9PKMK9Q011000@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 25 Oct 2012 16:19:09 -0400
Subject: [PATCH] tilegx: move fixup hook from __init to __devinit
To: Bjorn Helgaas <bhelgaas@google.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support having the PCI bus be removed at runtime and rediscovered.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: stable@vger.kernel.org [v3.6]
---
 arch/tile/kernel/pci_gx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 2ba6d05..248d08a 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1047,7 +1047,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 }
 
 /* Called for each device after PCI setup is done. */
-static void __init
+static void __devinit
 pcibios_fixup_final(struct pci_dev *pdev)
 {
 	set_dma_ops(&pdev->dev, gx_pci_dma_map_ops);
-- 
1.7.10.3

