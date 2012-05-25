Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab2EYXPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:15:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44508 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab2EYXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:15:14 -0400
From: Fabio Estevam <festevam@gmail.com>
To: kernel@pengutronix.de
Cc: shawn.guo@freescale.com, Fabio Estevam <fabio.estevam@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/15] hw_random: mxc-rnga: Use clk_prepare_enable/clk_disable_unprepare
Date: Fri, 25 May 2012 20:14:44 -0300
Message-Id: <1337987696-31728-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337987696-31728-1-git-send-email-festevam@gmail.com>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Prepare the clock before enabling it.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 187c6be..6f20f56 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -154,7 +154,7 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -196,7 +196,7 @@ err_ioremap:
 	release_mem_region(res->start, resource_size(res));
 
 err_region:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	clk_put(clk);
 
 out:
-- 
1.7.1

