Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1JMAdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:33:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36853 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1JMAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:33:14 -0400
From: Olof Johansson <olof@lixom.net>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, swarren@nvidia.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] i2c: tegra: __iomem annotation fix
Date: Wed, 12 Oct 2011 17:33:00 -0700
Message-Id: <1318465980-625-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/i2c/busses/i2c-tegra.c:585:7: warning: incorrect type in assignment (different address spaces)
drivers/i2c/busses/i2c-tegra.c:585:7:    expected void *base
drivers/i2c/busses/i2c-tegra.c:585:7:    got void [noderef] <asn:2>*
drivers/i2c/busses/i2c-tegra.c:619:16: warning: incorrect type in assignment (different address spaces)
drivers/i2c/busses/i2c-tegra.c:619:16:    expected void [noderef] <asn:2>*base
drivers/i2c/busses/i2c-tegra.c:619:16:    got void *base
drivers/i2c/busses/i2c-tegra.c:689:10: warning: incorrect type in argument 1 (different address spaces)
drivers/i2c/busses/i2c-tegra.c:689:10:    expected void volatile [noderef] <asn:2>*addr
drivers/i2c/busses/i2c-tegra.c:689:10:    got void *base

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b402435..46b6500 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -567,7 +567,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct clk *i2c_clk;
 	const unsigned int *prop;
-	void *base;
+	void __iomem *base;
 	int irq;
 	int ret = 0;
 
-- 
1.7.4.1

