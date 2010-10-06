Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0JFHpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:45:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49200 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab0JFHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56772939"
X-IronPort-AV: E=Sophos;i="4.57,288,1283756400"; 
   d="scan'208";a="20252794"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 13/20 v2] msm: 8x60: setup correct handlers for private interrupts
Date: Wed,  6 Oct 2010 00:42:52 -0700
Message-Id: <1286350979-19328-14-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Private Peripheral interrupts could be edge triggered or level triggered
depending on the platform. Initialize handlers for these in board file.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index e7feb99..70087ca 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -44,7 +44,7 @@ static void __init msm8x60_init_irq(void)
 {
 	unsigned int i;
 
-	gic_dist_init(0, MSM_QGIC_DIST_BASE, 1);
+	gic_dist_init(0, MSM_QGIC_DIST_BASE, GIC_PPI_START);
 	gic_cpu_base_addr = (void *)MSM_QGIC_CPU_BASE;
 	gic_cpu_init(0, MSM_QGIC_CPU_BASE);
 
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
