Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab0JHRdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48160 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab0JHRdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:41 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/11] ppc: checking for pdn->parent is redundant
Date: Fri,  8 Oct 2010 10:33:07 -0700
Message-Id: <1286559192-10898-7-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree root is never a pci bus, and will not have a
PCI_DN(pdn), so the check for PCI_DN added in
650f7b3b2f0ead0673e90452cf3dedde97c537ba makes the check for pdn->parent
redundant and it can be removed.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 8ab32da..0ae5a60 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -530,10 +530,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 	}
 	pr_debug("  parent is %s\n", pdn->full_name);
 
-	/* Check for parent == NULL so we don't try to setup the empty EADS
-	 * slots on POWER4 machines.
-	 */
-	if (dma_window == NULL || pdn->parent == NULL) {
+	if (dma_window == NULL) {
 		pr_debug("  no dma window for device, linking to parent\n");
 		set_iommu_table_base(&dev->dev, PCI_DN(pdn)->iommu_table);
 		return;
-- 
1.7.1

