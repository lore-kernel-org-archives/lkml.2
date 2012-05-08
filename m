Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2EHHGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:06:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:47282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab2EHHF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141277390"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@kernel.org
Cc: joro@8bytes.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] irq_remap: fix the 'sub_handle' uninitialized warning
Date: Tue,  8 May 2012 00:08:54 -0700
Message-Id: <1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336460934-23592-1-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <20120508035153.GA30652@gmail.com>
References: <20120508035153.GA30652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the uninitialized warning:
  drivers/iommu/intel_irq_remapping.c:986:12: warning: ‘sub_handle’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/intel_irq_remapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 1c0255e..6d34706 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -964,7 +964,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
-	u16 sub_handle;
+	u16 sub_handle = 0;
 	int ir_index;
 
 	cfg = irq_get_chip_data(irq);
-- 
1.7.6.5

