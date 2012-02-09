Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2BIVnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:43:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58989 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2BIVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:43:08 -0500
Date: Thu, 09 Feb 2012 16:43:01 -0500 (EST)
Message-Id: <20120209.164301.1049075777681222673.davem@davemloft.net>
To: shawn.guo@linaro.org
CC: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH] Fix mc13xxx regulator build on sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Feb 2012 13:43:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since mc13xxx-regulator-core.c and the actual drivers can get built
into seperate modules, you have to export the DT support symbols
"mc13xxx_get_num_regulators_dt" and "mc13xxx_parse_regulators_dt"
otherwise the allmodconfig build fails on sparc64.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 80ecafe..62dcd0a 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -254,6 +254,7 @@ int __devinit mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 
 	return num;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
 
 struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
 	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
@@ -291,6 +292,7 @@ struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
 
 	return data;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_parse_regulators_dt);
 #endif
 
 MODULE_LICENSE("GPL v2");
