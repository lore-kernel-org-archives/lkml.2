Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0JRSz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:55:28 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57342 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab0JRSz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:55:26 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ppc/cell: beat dma ops cleanup
Date: Mon, 18 Oct 2010 10:27:01 -0700
Message-Id: <1287422825-14999-5-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

direct_dma_ops is the default pci dma ops.

No need to call a function to get the pci dma ops, we know they are the
dma_direct_ops.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/platforms/cell/beat_iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/beat_iommu.c b/arch/powerpc/platforms/cell/beat_iommu.c
index beec405..3ce6855 100644
--- a/arch/powerpc/platforms/cell/beat_iommu.c
+++ b/arch/powerpc/platforms/cell/beat_iommu.c
@@ -76,7 +76,7 @@ static void __init celleb_init_direct_mapping(void)
 
 static void celleb_dma_dev_setup(struct device *dev)
 {
-	dev->archdata.dma_ops = get_pci_dma_ops();
+	set_dma_ops(dev, &dma_direct_ops);
 	set_dma_offset(dev, celleb_dma_direct_offset);
 }
 
@@ -106,7 +106,6 @@ static struct notifier_block celleb_of_bus_notifier = {
 static int __init celleb_init_iommu(void)
 {
 	celleb_init_direct_mapping();
-	set_pci_dma_ops(&dma_direct_ops);
 	ppc_md.pci_dma_dev_setup = celleb_pci_dma_dev_setup;
 	bus_register_notifier(&platform_bus_type, &celleb_of_bus_notifier);
 
-- 
1.7.1

