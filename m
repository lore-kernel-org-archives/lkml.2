Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2HPQYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:24:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16679 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2HPQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org
Subject: [PATCH 6/6] iommu: Fixes duplicate const warning.
Date: Thu, 16 Aug 2012 12:12:38 -0400
Message-Id: <1345133558-23341-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/pci-dma.c:275:1: warning: duplicate const
arch/x86/kernel/pci-swiotlb.c:68:1: warning: duplicate const
arch/x86/kernel/pci-swiotlb.c:86:1: warning: duplicate const
arch/x86/kernel/amd_gart_64.c:899:1: warning: duplicate const
arch/x86/kernel/pci-calgary_64.c:1600:1: warning: duplicate const
arch/x86/xen/pci-swiotlb-xen.c:96:1: warning: duplicate const
drivers/iommu/amd_iommu_init.c:1831:1: warning: duplicate const
drivers/iommu/dmar.c:1350:1: warning: duplicate const

when using smatch.

CC: x86@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/iommu_table.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index f229b13..bbf8fb2 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -48,7 +48,7 @@ struct iommu_table_entry {
 
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
-	static const struct iommu_table_entry const			\
+	static const struct iommu_table_entry				\
 		__iommu_entry_##_detect __used				\
 	__attribute__ ((unused, __section__(".iommu_table"),		\
 			aligned((sizeof(void *)))))	\
-- 
1.7.7.6

