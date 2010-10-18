Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0JRR1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:27:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50878 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab0JRR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:27:28 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
        Tejun Heo <tj@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ppc/dart: iommu table cleanup
Date: Mon, 18 Oct 2010 10:27:02 -0700
Message-Id: <1287422825-14999-6-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to set the device tree device_node pci node iommu pointer, its
only used for dlpar remove.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/sysdev/dart_iommu.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index 17cf15e..8e9e06a 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -312,17 +312,10 @@ static void pci_dma_dev_setup_dart(struct pci_dev *dev)
 
 static void pci_dma_bus_setup_dart(struct pci_bus *bus)
 {
-	struct device_node *dn;
-
 	if (!iommu_table_dart_inited) {
 		iommu_table_dart_inited = 1;
 		iommu_table_dart_setup();
 	}
-
-	dn = pci_bus_to_OF_node(bus);
-
-	if (dn)
-		PCI_DN(dn)->iommu_table = &iommu_table_dart;
 }
 
 static bool dart_device_on_pcie(struct device *dev)
@@ -373,7 +366,7 @@ void __init iommu_init_early_dart(void)
 	if (dn == NULL) {
 		dn = of_find_compatible_node(NULL, "dart", "u4-dart");
 		if (dn == NULL)
-			goto bail;
+			return;	/* use default direct_dma_ops */
 		dart_is_u4 = 1;
 	}
 
-- 
1.7.1

