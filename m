Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0DCB3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:29:32 -0400
Received: from sous-sol.org ([216.99.217.87]:45708 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755111Ab0DCB3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:29:04 -0400
Message-Id: <20100403012823.099077735@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 18:27:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: nhorman@tuxdriver.com, nhorman@redhat.com, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com,
       iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86/amd-iommu: use for_each_pci_dev
References: <20100403012751.834020949@sous-sol.org>
Content-Disposition: inline; filename=amd-iommu-use-for_each_pci_dev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open coded version with for_each_pci_dev

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2187,7 +2187,7 @@ static void prealloc_protection_domains(
 	struct dma_ops_domain *dma_dom;
 	u16 devid;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 
 		/* Do we handle this device? */
 		if (!check_device(&dev->dev))

