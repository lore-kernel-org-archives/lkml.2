Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab0LTXAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:00:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36002 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0LTXAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:00:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67412295"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: qsd8x50: Platform data isn't init data
Date: Mon, 20 Dec 2010 15:00:17 -0800
Message-Id: <1292886017-23511-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SMC91x platform and resource data from initdata.  These
will continue to be accessed after init, and must remain available.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-qsd8x50.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 5a557f3..c295f8a 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -45,7 +45,7 @@ static const unsigned        qsd8x50_surf_smc91x_gpio __initdata = 156;
  * at run-time: they vary from board to board, and the true
  * configuration won't be known until boot.
  */
-static struct resource smc91x_resources[] __initdata = {
+static struct resource smc91x_resources[] = {
 	[0] = {
 		.flags = IORESOURCE_MEM,
 	},
@@ -54,7 +54,7 @@ static struct resource smc91x_resources[] __initdata = {
 	},
 };
 
-static struct platform_device smc91x_device __initdata = {
+static struct platform_device smc91x_device = {
 	.name           = "smc91x",
 	.id             = 0,
 	.num_resources  = ARRAY_SIZE(smc91x_resources),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

