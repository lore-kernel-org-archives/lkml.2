Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0LJWMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:12:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19762 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0LJWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:12:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6193"; a="66346967"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] msm: iommu: Use the correct memory allocation flag
Date: Fri, 10 Dec 2010 14:12:03 -0800
Message-Id: <1292019123-6044-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change msm_iommu_map to use GFP_ATOMIC instead of
GFP_KERNEL due to the fact that the call occurs within
a spinlock-protected region.

Change-Id: I7e9345a9a58811c421f9e7fae0c1ec5a759c6178
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index f651017..e2d58e4 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -386,7 +386,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 	/* Need a 2nd level table */
 	if ((len == SZ_4K || len == SZ_64K) && (*fl_pte) == 0) {
 		unsigned long *sl;
-		sl = (unsigned long *) __get_free_pages(GFP_KERNEL,
+		sl = (unsigned long *) __get_free_pages(GFP_ATOMIC,
 							get_order(SZ_4K));

 		if (!sl) {
--
1.7.0.2
 Sent by an employee of the Qualcomm Innovation Center, Inc.
 The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

