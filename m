Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1EKW1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:27:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56583 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1EKWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:11 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] dma-mapping: add get_required_mask if arch overrides default
Date: Wed, 11 May 2011 15:25:02 -0700
Message-Id: <1305152704-4864-7-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
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

