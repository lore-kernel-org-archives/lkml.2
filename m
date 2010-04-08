Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab0DHTBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:01:12 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:24553 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0DHTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:01:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/6] pci/dmar: remove the noisy print out about unmapping
Date: Thu,  8 Apr 2010 11:58:24 -0700
Message-Id: <1270753107-15881-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBE27DF.026A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it seems this one should be removed.
because map page does not have this annonyed print out.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/intel-iommu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 83ac214..7dddc7c 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2742,9 +2742,6 @@ static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
 	start_pfn = mm_to_dma_pfn(iova->pfn_lo);
 	last_pfn = mm_to_dma_pfn(iova->pfn_hi + 1) - 1;
 
-	pr_debug("Device %s unmapping: pfn %lx-%lx\n",
-		 pci_name(pdev), start_pfn, last_pfn);
-
 	/*  clear the whole page */
 	dma_pte_clear_range(domain, start_pfn, last_pfn);
 
-- 
1.6.4.2

