Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2GYTqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:46:50 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:38379 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2GYTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:46:49 -0400
Message-ID: <201207251946.q6PJklUm016228@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 25 Jul 2012 15:40:50 -0400
Subject: [PATCH] tilegx pci: fix semantic merge conflict with 3527ed81c
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu removed pci_bus.subordinate in pci-next, which meant that
the tile-next changes to add tilegx PCI support don't build.  This
was expected (seen in linux-next) and this one-line fix is along
the same lines as commit b918c62e for all other architectures.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index fa75264..0e213e3 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -853,7 +853,7 @@ int __init pcibios_init(void)
 		bus = pci_scan_root_bus(NULL, next_busno, controller->ops,
 					controller, &resources);
 		controller->root_bus = bus;
-		next_busno = bus->subordinate + 1;
+		next_busno = bus->busn_res.end + 1;
 
 	}
 
-- 
1.7.10.3

