Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0LQAuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:50:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0LQAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160045"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 22/22] msm: clock-8x60: Don't keep IOMMU clocks on at boot
Date: Thu, 16 Dec 2010 16:50:06 -0800
Message-Id: <1292547006-19741-23-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the IOMMU driver properly handles its clocks we can stop
keeping the clocks it requires to be on during early boot.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-8x60.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 28017b7..78f33ef 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -1851,15 +1851,6 @@ static void reg_init(void)
 	/* Set the dsi_byte_clk src to the DSI PHY PLL,
 	 * dsi_esc_clk to PXO/2, and the hdmi_app_clk src to PXO */
 	rmwreg(0x400001, MISC_CC2_REG, 0x424003);
-
-	/*
-	 * Turn on clocks required by the SMMU driver until it properly
-	 * controls its own clocks.
-	 */
-	local_clk_enable(C(SMMU_P));
-	local_clk_enable(C(JPEGD_AXI));
-	local_clk_enable(C(VFE_AXI));
-	local_clk_enable(C(VCODEC_AXI));
 }
 
 /* Local clock driver initialization. */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

