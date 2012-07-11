Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2GKNkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:40:55 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:33049
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757694Ab2GKNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LM-02-1PN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/27] iommu/amd: Make sure IOMMU is not considered to translate itself
Date: Wed, 11 Jul 2012 15:39:02 +0200
Message-ID: <1342013952-10174-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
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
index 0b4093c..820f688 100644
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


