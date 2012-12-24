Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2LXFLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 00:11:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:60309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2LXFLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:11:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,344,1355126400"; 
   d="scan'208";a="269293219"
Subject: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: sameo@linux.intel.com, peter.ujfalusi@ti.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Dec 2012 22:19:56 +0800
Message-ID: <1356358796.1688.3.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch fix the below build error:
drivers/built-in.o: In function `twl_probe':
drivers/mfd/twl-core.c:1256: undefined reference to `devm_regmap_init_i2c'
make: *** [vmlinux] Error 1

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1c0abd4..47ad4e2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -292,6 +292,7 @@ config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select IRQ_DOMAIN
+	select REGMAP_I2C
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
-- 
1.7.0.4



