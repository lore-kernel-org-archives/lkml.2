Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab0HYE7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17531 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0HYE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012266"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366147"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 17/24] msm: 8x60: setup correct handlers for private interrupts
Date: Tue, 24 Aug 2010 21:57:46 -0700
Message-Id: <1282712273-344-18-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
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
index c6bf8e3..e2e5a5c 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -46,7 +46,7 @@ static void __init msm8x60_init_irq(void)
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
