Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2ALJ45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:56:57 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41646 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab2ALJzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:31 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/15] drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:10 +0100
Message-Id: <1326362117-29371-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 7b1594f..1ac8324 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -62,7 +62,7 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 	priv = stmmac_dvr_probe(&(pdev->dev), plat_dat);
 	if (!priv) {
 		pr_err("%s: main drivr probe failed", __func__);
-		goto out_release_region;
+		goto out_unmap;
 	}
 
 	priv->ioaddr = addr;

