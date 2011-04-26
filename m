Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab1DZVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:18:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:58913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab1DZVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483905"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: stable@kernel.org, jan.kiszka@siemens.com, ak@linux.intel.com,
        sheng@linux.intel.com, David.Woodhouse@intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [102/106] From: intel-iommu: Fix use after release during device attach
Message-Id: <20110426211424.F35A33E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Date: Tue, 2 Nov 2010 08:05:51 +0100
Subject: [PATCH] intel-iommu: Fix use after release during device attach

Obtain the new pgd pointer before releasing the page containing this
value.

Cc: stable@kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux-2.6.35.y/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/intel-iommu.c
+++ linux-2.6.35.y/drivers/pci/intel-iommu.c
@@ -3638,9 +3638,9 @@ static int intel_iommu_attach_device(str
 
 		pte = dmar_domain->pgd;
 		if (dma_pte_present(pte)) {
-			free_pgtable_page(dmar_domain->pgd);
 			dmar_domain->pgd = (struct dma_pte *)
 				phys_to_virt(dma_pte_addr(pte));
+			free_pgtable_page(pte);
 		}
 		dmar_domain->agaw--;
 	}
