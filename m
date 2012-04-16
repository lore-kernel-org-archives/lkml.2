Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2DPXhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:37:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39586 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2DPXhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:37:52 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH] ARM: imx: Fix imx5 idle logic bug
Date: Mon, 16 Apr 2012 18:37:48 -0500
Message-Id: <1334619468-25680-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imx5_idle() check of the tzic_eanble_wake() return value uses
incorrect (inverted) logic causing all attempt to idle to fail.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/mm-imx5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index 05250ae..e10f391 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -35,7 +35,7 @@ static void imx5_idle(void)
 	}
 	clk_enable(gpc_dvfs_clk);
 	mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
-	if (tzic_enable_wake() != 0)
+	if (!tzic_enable_wake())
 		cpu_do_idle();
 	clk_disable(gpc_dvfs_clk);
 }
-- 
1.7.10

