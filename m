Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GLG7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:59:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:44068 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab0GLG7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:59:13 -0400
Date: Mon, 12 Jul 2010 15:59:11 +0900
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci: remove unused
 HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_{SIZE|BOUNDARY}
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100712155845E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 12 Jul 2010 15:59:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.34, we transformed the PCI DMA API into the generic device
mode. The PCI DMA API is just the wrapper of the DMA API.

So we don't need HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE or
HAVE_ARCH_PCI_SET_DMA_SEGMENT_BOUNDARY (which enable architectures to
have the own implementations). Both haven't been used anyway.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/pci.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 130ed1d..7fa3cbd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2312,21 +2312,17 @@ void pci_msi_off(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_msi_off);
 
-#ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
 {
 	return dma_set_max_seg_size(&dev->dev, size);
 }
 EXPORT_SYMBOL(pci_set_dma_max_seg_size);
-#endif
 
-#ifndef HAVE_ARCH_PCI_SET_DMA_SEGMENT_BOUNDARY
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask)
 {
 	return dma_set_seg_boundary(&dev->dev, mask);
 }
 EXPORT_SYMBOL(pci_set_dma_seg_boundary);
-#endif
 
 static int pcie_flr(struct pci_dev *dev, int probe)
 {
-- 
1.6.5

