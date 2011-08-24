Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1HXAt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:49:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:64483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1HXAtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195056"
Message-Id: <20110824001456.334878686@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/8] iommu: no need to set dmar_disabled in check_zero_address()
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=remove_dmar_disabled_in_check_address.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the restructruing of the x86 IOMMU code, intel_iommu_init()
was getting called directly from pci_iommu_init() and hence needed
to explicitly set dmar_disabled to 1 for the failure conditions of
check_zero_address().

Recent changes don't call intel_iommu_init() if the intel iommu
detection fails as a result of failure in check_zero_address().

So no need for this ifdef and the code inside it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/iommu/dmar.c |    3 ---
 1 file changed, 3 deletions(-)

Index: tree/drivers/iommu/dmar.c
===================================================================
--- tree.orig/drivers/iommu/dmar.c
+++ tree/drivers/iommu/dmar.c
@@ -540,9 +540,6 @@ int __init check_zero_address(void)
 	return 1;
 
 failed:
-#ifdef CONFIG_DMAR
-	dmar_disabled = 1;
-#endif
 	return 0;
 }
 


