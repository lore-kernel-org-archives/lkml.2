Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2KVSkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab2KVSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Thode <prometheanfire@gentoo.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 79/83] intel-iommu: Fix lookup in add device
Date: Wed, 21 Nov 2012 16:42:41 -0800
Message-Id: <20121122004221.099407721@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 3da4af0affbb797e8ac4c2b4598da0c34b8cc52a upstream.

We can't assume this device exists, fall back to the bridge itself.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Matthew Thode <prometheanfire@gentoo.org>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4108,7 +4108,7 @@ static void swap_pci_ref(struct pci_dev
 static int intel_iommu_add_device(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_dev *bridge, *dma_pdev;
+	struct pci_dev *bridge, *dma_pdev = NULL;
 	struct iommu_group *group;
 	int ret;
 
@@ -4122,7 +4122,7 @@ static int intel_iommu_add_device(struct
 			dma_pdev = pci_get_domain_bus_and_slot(
 						pci_domain_nr(pdev->bus),
 						bridge->subordinate->number, 0);
-		else
+		if (!dma_pdev)
 			dma_pdev = pci_dev_get(bridge);
 	} else
 		dma_pdev = pci_dev_get(pdev);


