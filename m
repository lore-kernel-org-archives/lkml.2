Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1FXTGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:06:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43726 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab1FXTGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:06:09 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] dma-mapping: add get_required_mask if arch overrides default
Date: Fri, 24 Jun 2011 12:05:23 -0700
Message-Id: <1308942325-4813-3-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
References: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

If an architecture sets ARCH_HAS_DMA_GET_REQUIRED_MASK and has settable
dma_map_ops, the required mask may change by the ops implementation.
For example, a system that always has an mmu inline may only require 32
bits while a swiotlb would desire bits to cover all of memory.

Therefore add the field if the architecture does not use the generic
definition of dma_get_required_mask. The first use will by by powerpc.
Note that this does add some dependency on the order in which files are
visible here.

Signed-off-by:  Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org
---
 include/linux/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba8319a..d0e023b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -49,6 +49,9 @@ struct dma_map_ops {
 	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
 	int (*dma_supported)(struct device *dev, u64 mask);
 	int (*set_dma_mask)(struct device *dev, u64 mask);
+#ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
+	u64 (*get_required_mask)(struct device *dev);
+#endif
 	int is_phys;
 };
 
-- 
1.7.4.1

