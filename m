Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1COFD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:03:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1COFB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772021"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 10/11] msm: 8960: Split out common initialization code
Date: Mon, 14 Mar 2011 22:01:13 -0700
Message-Id: <1300165274-8544-11-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Move common initialization code into a separate function in
preparation for adding devices that are common to multiple
8960 targets.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 052cb35..9511ea6 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -65,15 +65,20 @@ static struct platform_device *rumi3_devices[] __initdata = {
 	&msm8960_device_uart_gsbi5,
 };
 
-static void __init msm8960_sim_init(void)
+static void __init msm8960_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+}
+
+static void __init msm8960_sim_init(void)
+{
+	msm8960_init();
 	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
 }
 
 static void __init msm8960_rumi3_init(void)
 {
-	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	msm8960_init();
 	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

