Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab1FARLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:11:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38649 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045Ab1FARKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:10:24 -0400
From: Julia Lawall <julia@diku.dk>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] drivers/video/imxfb.c: add missing clk_put
Date: Wed,  1 Jun 2011 19:10:11 +0200
Message-Id: <1306948213-20767-8-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Reorder the labels at the end of the function to correspond to the order in
which the resources are allocated.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/imxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index d2ccfd6..f135dbe 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -856,10 +856,10 @@ failed_platform_init:
 		dma_free_writecombine(&pdev->dev,fbi->map_size,fbi->map_cpu,
 			fbi->map_dma);
 failed_map:
-	clk_put(fbi->clk);
-failed_getclock:
 	iounmap(fbi->regs);
 failed_ioremap:
+	clk_put(fbi->clk);
+failed_getclock:
 	release_mem_region(res->start, resource_size(res));
 failed_req:
 	kfree(info->pseudo_palette);

