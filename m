Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2ADXuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:50:22 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30694 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2ADXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:50:15 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Increase resource array mask bit size in pcim_iomap_regions()
Date: Wed,  4 Jan 2012 15:50:02 -0800
Message-Id: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F04E5B6.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEVICE_COUNT_RESOURCE will be bigger than 16 when SRIOV supported is enabled.

Let them pass with int just like pci_enable_resources().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/pci.h |    6 +++---
 lib/devres.c        |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1433,10 +1433,10 @@ static inline void pci_fixup_device(enum
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
-int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
-int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name);
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
 				   const char *name);
-void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask);
+void pcim_iounmap_regions(struct pci_dev *pdev, int mask);
 
 extern int pci_pci_problems;
 #define PCIPCI_FAIL		1	/* No PCI PCI DMA */
Index: linux-2.6/lib/devres.c
===================================================================
--- linux-2.6.orig/lib/devres.c
+++ linux-2.6/lib/devres.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL(pcim_iounmap);
  *
  * Request and iomap regions specified by @mask.
  */
-int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
+int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name)
 {
 	void __iomem * const *iomap;
 	int i, rc;
@@ -306,7 +306,7 @@ EXPORT_SYMBOL(pcim_iomap_regions);
  *
  * Request all PCI BARs and iomap regions specified by @mask.
  */
-int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
 				   const char *name)
 {
 	int request_mask = ((1 << 6) - 1) & ~mask;
@@ -330,7 +330,7 @@ EXPORT_SYMBOL(pcim_iomap_regions_request
  *
  * Unmap and release regions specified by @mask.
  */
-void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask)
+void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
 {
 	void __iomem * const *iomap;
 	int i;
