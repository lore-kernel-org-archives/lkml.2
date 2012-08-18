Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2HRKQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 06:16:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2HRKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 06:16:34 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH] net/stmmac: fix issue of clk_get for Loongson1B.
Date: Sat, 18 Aug 2012 18:16:23 +0800
Message-Id: <1345284983-12610-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When getting clock, give a chance to the CPUs without DT support,
which use Common Clock Framework, such as Loongson1B.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fd8882f..c136162 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2077,7 +2077,7 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
-	priv->stmmac_clk = clk_get(priv->device, NULL);
+	priv->stmmac_clk = clk_get(priv->device, STMMAC_RESOURCE_NAME);
 	if (IS_ERR(priv->stmmac_clk)) {
 		pr_warning("%s: warning: cannot get CSR clock\n", __func__);
 		goto error_clk_get;
-- 
1.7.1

