Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab0KPBqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:46:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0KPBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:46:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62976617"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 09/14 v2] msm: iommu: Kconfig item for cacheable page tables
Date: Mon, 15 Nov 2010 17:46:10 -0800
Message-Id: <1289871970-18393-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig item to allow the IOMMU page tables to be
coherent in the L2 cache. This generally reduces IOTLB miss
latencies and has been shown to improve multimedia
performance.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index dbbcfeb..1c6f76b 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -122,6 +122,10 @@ config MACH_MSM8X60_FFA

 endmenu

+config IOMMU_PGTABLES_L2
+	def_bool y
+	depends on ARCH_MSM8X60 && MMU && SMP && CPU_DCACHE_DISABLE=n
+
 config MSM_DEBUG_UART
 	int
 	default 1 if MSM_DEBUG_UART1
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

