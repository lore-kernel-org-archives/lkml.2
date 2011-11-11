Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1KKU7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:59:17 -0500
Received: from smp.if.uj.edu.pl ([149.156.82.206]:49961 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1KKU7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:59:14 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 15:59:13 EST
Date: Fri, 11 Nov 2011 21:53:50 +0100
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Allen Kay <allen.m.kay@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH] intel-iommu: Fix __init section missmatch of
 dmar_parse_rmrr_atsr_dev
Message-ID: <20111111205350.GB23349@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmar_parse_rmrr_atsr_dev() (drivers/iommu/dmar.c)
is called from dmar_dev_scope_init() (drivers/iommu/intel-iommu.c),
but dmar_dev_scope_init() is annotated with __init,
when dmar_parse_rmrr_atsr_dev() is not, causing full section
missmatch analsysis to abort compilation.

Fix problem by adding __init annotation to dmar_parse_rmrr_atsr_dev.

Signed-off-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
---
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..a004c39 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3524,7 +3524,7 @@ found:
 	return 0;
 }
 
-int dmar_parse_rmrr_atsr_dev(void)
+int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr, *rmrr_n;
 	struct dmar_atsr_unit *atsr, *atsr_n;
