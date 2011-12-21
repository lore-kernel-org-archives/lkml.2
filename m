Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1LUQ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1LUQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:28:29 -0500
Date: Wed, 21 Dec 2011 18:30:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 16/16] alpha: drop pci_iomap/pci_iounmap from
 pci-noop.c
Message-ID: <ef92d191e2ef1a69979aba62cf7643fcad646e82.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324484752.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jenkins disables PCI so asm-generic provides inline
stubs for these, we don't need offline stubs as well.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/alpha/kernel/pci-noop.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index 246100e..04eea48 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -185,15 +185,3 @@ struct dma_map_ops alpha_noop_ops = {
 
 struct dma_map_ops *dma_ops = &alpha_noop_ops;
 EXPORT_SYMBOL(dma_ops);
-
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	return NULL;
-}
-
-void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
-{
-}
-
-EXPORT_SYMBOL(pci_iomap);
-EXPORT_SYMBOL(pci_iounmap);
-- 
1.7.8.382.g3daff
