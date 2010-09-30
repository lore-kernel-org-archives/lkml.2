Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0I3SnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:43:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0I3SnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:43:19 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ameya.palande@nokia.com, felipe.contreras@gmail.com,
        andy.shevchenko@gmail.com, Ernesto Ramos <ernesto@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging: tidspbridge: disable all peripherals at bridge_brd_stop
Date: Thu, 30 Sep 2010 13:49:36 -0500
Message-Id: <1285872576-31526-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSP Bridge needs to disable the peripheral clocks when switches to
BRD_STOPPED since that would prevent the domain to enter in OFF state.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index f1e59e8..e32e98a 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -625,7 +625,6 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	struct bridge_dev_context *dev_context = dev_ctxt;
 	struct pg_table_attrs *pt_attrs;
 	u32 dsp_pwr_state;
-	int clk_status;
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
 
@@ -679,7 +678,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
 			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
-	clk_status = dsp_clk_disable(DSP_CLK_IVA2);
+	dsp_clock_disable_all(dev_context->dsp_per_clks);
+	dsp_clk_disable(DSP_CLK_IVA2);
 
 	return status;
 }
-- 
1.5.4.5

