Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IXUzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:55:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0IXUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:55:45 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.com, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ameya.palande@nokia.com, felipe.contreras@gmail.com,
        andy.shevchenko@gmail.com, Ernesto Ramos <ernesto@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging: tidspbridge: disable all peripherals at bridge_brd_stop
Date: Fri, 24 Sep 2010 16:02:03 -0500
Message-Id: <1285362123-31323-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSP Bridge needs to disable the peripheral clocks when switches to
BRD_STOPPED since that would prevent the domain to enter in OFF state.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 0e3558a..8b73ac9 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -552,7 +552,7 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	int status = 0;
 	struct bridge_dev_context *dev_context = dev_ctxt;
 	u32 dsp_pwr_state;
-	int clk_status, i;
+	int i;
 	struct bridge_ioctl_extproc *tlb = dev_context->atlb_entry;
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
@@ -621,7 +621,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK,
 		OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
-	clk_status = dsp_clk_disable(DSP_CLK_IVA2);
+	dsp_clock_disable_all(dev_context->dsp_per_clks);
+	dsp_clk_disable(DSP_CLK_IVA2);
 
 	return status;
 }
-- 
1.5.4.5

