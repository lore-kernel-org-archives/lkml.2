Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1I0FEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 01:04:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38217 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1I0FEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 01:04:08 -0400
Date: Tue, 27 Sep 2011 15:03:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: linux-next: manual merge of the tip tree with the iommu tree
Message-Id: <20110927150357.8e1bb98b8185361cc4072f1e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/iommu/Makefile between commit fcf3a6ef4a58 ("omap: iommu/iovmm:
move to dedicated iommu folder") from the iommu tree and commit
d3f138106b4b ("iommu: Rename the DMAR and INTR_REMAP config options")
from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iommu/Makefile
index f798cdd,6394994..0000000
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@@ -1,8 -1,6 +1,9 @@@
  obj-$(CONFIG_IOMMU_API) += iommu.o
  obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
  obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
- obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
- obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+ obj-$(CONFIG_DMAR_TABLE) += dmar.o
+ obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
+ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
 +obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 +obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 +obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
