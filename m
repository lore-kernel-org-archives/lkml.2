Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2CUUBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:01:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56085 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab2CUUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:01:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] clk: fixed-rate: Don't open code kstrdup()
Date: Wed, 21 Mar 2012 20:01:19 +0000
Message-Id: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save a little code by using the library function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/clk/clk-fixed-rate.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 90c79fb..cf84e41 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -45,7 +45,6 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 {
 	struct clk_fixed_rate *fixed;
 	char **parent_names = NULL;
-	u8 len;
 
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
 
@@ -63,14 +62,10 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		if (! parent_names)
 			goto out;
 
-		len = sizeof(char) * strlen(parent_name);
-
-		parent_names[0] = kmalloc(len, GFP_KERNEL);
+		parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
 
 		if (!parent_names[0])
 			goto out;
-
-		strncpy(parent_names[0], parent_name, len);
 	}
 
 out:
-- 
1.7.9.1

