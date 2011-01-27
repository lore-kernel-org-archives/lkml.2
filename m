Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1A0PaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:30:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46358 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1A0P3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:29:40 -0500
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/staging/msm/lcdc.c: Convert IS_ERR result to PTR_ERR
Date: Thu, 27 Jan 2011 16:49:07 +0100
Message-Id: <1296143347-17508-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code elsewhere returns a negative constant to an indicate an error,
while IS_ERR returns the result of a >= operation.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

 if (...) { ...
- return IS_ERR(x);
+ return PTR_ERR(x);
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/msm/lcdc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/staging/msm/lcdc.c b/drivers/staging/msm/lcdc.c
--- a/drivers/staging/msm/lcdc.c
+++ b/drivers/staging/msm/lcdc.c
@@ -224,12 +224,12 @@ static int __init lcdc_driver_init(void)
 	mdp_lcdc_pclk_clk = clk_get(NULL, "mdp_lcdc_pclk_clk");
 	if (IS_ERR(mdp_lcdc_pclk_clk)) {
 		printk(KERN_ERR "error: can't get mdp_lcdc_pclk_clk!\n");
-		return IS_ERR(mdp_lcdc_pclk_clk);
+		return PTR_ERR(mdp_lcdc_pclk_clk);
 	}
 	mdp_lcdc_pad_pclk_clk = clk_get(NULL, "mdp_lcdc_pad_pclk_clk");
 	if (IS_ERR(mdp_lcdc_pad_pclk_clk)) {
 		printk(KERN_ERR "error: can't get mdp_lcdc_pad_pclk_clk!\n");
-		return IS_ERR(mdp_lcdc_pad_pclk_clk);
+		return PTR_ERR(mdp_lcdc_pad_pclk_clk);
 	}
 //	pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
 //				PM_QOS_DEFAULT_VALUE);

