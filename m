Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2IQIQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:16:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41626 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2IQIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:15:41 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: svenkatr@ti.com
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/4] drivers/mmc/host/omap_hsmmc.c: fix error return code
Date: Mon, 17 Sep 2012 10:15:27 +0200
Message-Id: <1347869728-2696-3-git-send-email-peter.senna@gmail.com>
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
 drivers/mmc/host/omap_hsmmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e59ac62..c8a2b36 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1893,6 +1893,7 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
 		if (pdata->init(&pdev->dev) != 0) {
 			dev_dbg(mmc_dev(host->mmc),
 				"Unable to configure MMC IRQs\n");
+			ret = -ENXIO;
 			goto err_irq_cd_init;
 		}
 	}
-- 
1.7.11.4

