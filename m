Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2I1MYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:24:19 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43425
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2I1MYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-01-LKU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/16] iommu/amd: Make sure IOMMU is not considered to translate itself
Date: Fri, 28 Sep 2012 14:23:56 +0200
Message-ID: <1348835046-3262-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IVRS table usually includes the IOMMU device. But the
IOMMU does never translate itself, so make sure the IOMMU
driver knows this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 8e9d71c..202b2b7 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1018,6 +1018,13 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	ret = init_iommu_from_acpi(iommu, h);
 	if (ret)
 		return ret;
+
+	/*
+	 * Make sure IOMMU is not considered to translate itself. The IVRS
+	 * table tells us so, but this is a lie!
+	 */
+	amd_iommu_rlookup_table[iommu->devid] = NULL;
+
 	init_iommu_devices(iommu);
 
 	return 0;
-- 
1.7.9.5


