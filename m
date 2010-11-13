Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0KMDa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31686 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718509"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 09/14] msm: iommu: Kconfig option for cacheable page tables
Date: Fri, 12 Nov 2010 19:29:55 -0800
Message-Id: <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig option to allow the IOMMU page tables to be
coherent in the L2 cache. This generally reduces TLB miss
latencies, but may lead to cache pollution if the
multimedia core's access pattern does not benefit from fast
handling of TLB misses.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index dbbcfeb..7781920 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -122,6 +122,21 @@ config MACH_MSM8X60_FFA
 
 endmenu
 
+config IOMMU_PGTABLES_L2
+	depends on ARCH_MSM8X60
+	depends on MMU
+	depends on CPU_DCACHE_DISABLE=n
+	depends on SMP
+	bool "Cacheable IOMMU page tables"
+	default y
+	help
+	  Allows the IOMMU page tables to be brought into the L2 cache. This
+	  improves the TLB miss latency at the expense of potential pollution
+	  of the L2 cache. This option has been shown to improve multimedia
+	  performance in some cases.
+
+	  If unsure, say Y here.
+
 config MSM_DEBUG_UART
 	int
 	default 1 if MSM_DEBUG_UART1
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

