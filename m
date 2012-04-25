Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2DYS7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:59:03 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:2758 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab2DYS7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:59:01 -0400
Message-Id: <201204251858.q3PIwxYW010068@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 25 Apr 2012 12:45:26 -0400
Subject: [PATCH] arch/tile: fix a couple of functions that should be __init
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 25 Apr 2012 18:59:00.0282 (UTC) FILETIME=[797839A0:01CD2315]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were marked __devinit by mistake, causing some warnings at link time.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h |    4 ++--
 arch/tile/kernel/pci.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 5d5a635..32e6cbe 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -47,8 +47,8 @@ struct pci_controller {
  */
 #define PCI_DMA_BUS_IS_PHYS     1
 
-int __devinit tile_pci_init(void);
-int __devinit pcibios_init(void);
+int __init tile_pci_init(void);
+int __init pcibios_init(void);
 
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
 
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index a1bb59e..b56d12b 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -141,7 +141,7 @@ static int __devinit tile_init_irqs(int controller_id,
  *
  * Returns the number of controllers discovered.
  */
-int __devinit tile_pci_init(void)
+int __init tile_pci_init(void)
 {
 	int i;
 
@@ -287,7 +287,7 @@ static void __devinit fixup_read_and_payload_sizes(void)
  * The controllers have been set up by the time we get here, by a call to
  * tile_pci_init.
  */
-int __devinit pcibios_init(void)
+int __init pcibios_init(void)
 {
 	int i;
 
-- 
1.6.5.2

