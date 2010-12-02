Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0LBWMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:12:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60728 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0LBWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:12:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6185"; a="65043787"
X-IronPort-AV: E=Sophos;i="4.59,288,1288594800"; 
   d="scan'208";a="14957975"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@marvell.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] arm: dma-mapping: move consistent_init to early_initcall
Date: Thu,  2 Dec 2010 14:11:18 -0800
Message-Id: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines require the use of coherent memory to bring up auxillary
cpus, and thus want to use dma_alloc_coherent prior to smp_init
completing.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index ac6a361..d46ce8d 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -177,7 +177,7 @@ static int __init consistent_init(void)
 	return ret;
 }
 
-core_initcall(consistent_init);
+early_initcall(consistent_init);
 
 static void *
 __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

