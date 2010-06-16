Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0FPEvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:51:15 -0400
Received: from ozlabs.org ([203.10.76.45]:59890 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0FPEvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:51:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] pci: fix compilation when CONFIG_PCI_MSI=n
Date: Wed, 16 Jun 2010 14:21:10 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006161421.11148.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2266,6 +2266,7 @@ pci_intx(struct pci_dev *pdev, int enabl
 	}
 }
 
+#ifdef CONFIG_PCI_MSI
 /**
  * pci_msi_off - disables any msi or msix capabilities
  * @dev: the PCI device to operate on
@@ -2293,6 +2294,7 @@ void pci_msi_off(struct pci_dev *dev)
 	}
 }
 EXPORT_SYMBOL_GPL(pci_msi_off);
+#endif
 
 #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
