Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2IQIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:16:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39088 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2IQIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:15:42 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: cjb@laptop.org
Cc: shawn.guo@linaro.org, marex@denx.de, broonie@opensource.wolfsonmicro.com,
        vinod.koul@linux.intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 4/4] drivers/mmc/host/mxs-mmc.c: fix error return code
Date: Mon, 17 Sep 2012 10:15:28 +0200
Message-Id: <1347869728-2696-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/mmc/host/mxs-mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 80d1e6d..afd8fdd 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -674,6 +674,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	if (!ssp->dmach) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: failed to request dma\n", __func__);
+		ret = -ENODEV;
 		goto out_clk_put;
 	}
 
-- 
1.7.11.4

