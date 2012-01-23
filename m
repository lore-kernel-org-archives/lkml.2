Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2AWNAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:00:41 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:31595
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab2AWNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:00:40 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY95GT-02-04U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Work around broken IVRS tables
Date: Mon, 23 Jan 2012 14:00:17 +0100
Message-ID: <1327323617-13288-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems the IVRS table does not contain all PCI
devices present in the system. In case a device not present
in the IVRS table is translated by the IOMMU no DMA is
possible from that device by default.
This patch fixes this by removing the DTE entry for every
PCI device present in the system and not covered by IVRS.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cce1f03..f75e060 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2863,6 +2863,9 @@ static unsigned device_dma_ops_init(void)
 
 	for_each_pci_dev(pdev) {
 		if (!check_device(&pdev->dev)) {
+
+			iommu_ignore_device(&pdev->dev);
+
 			unhandled += 1;
 			continue;
 		}
-- 
1.7.5.4


