Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2LXNT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:19:56 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59298 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LXNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:19:53 -0500
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chen Gang <gang.chen@asianux.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH] mfd: twl4030: TWL4030_CORE needs REGMAP and REGMAP_I2C
Date: Mon, 24 Dec 2012 07:12:30 -0600
Message-Id: <1356354750-22969-1-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting REGMAP_I2C defaults REGMAP to "y", no need to
explicitly select it.

This fixes:

- Because of REGMAP, a bunch of:
drivers/mfd/twl-core.c:221:29:
    error: array type has incomplete element type
drivers/mfd/twl-core.c:224:3:
    error: field name not in record or union initializer
drivers/mfd/twl-core.c:224:3:
    error: (near initialization for 'twl4030_regmap_config')

- Because of REGMAP_I2C:
drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1256:3: error: implicit declaration of function
'devm_regmap_init_i2c' [-Werror=implicit-function-declaration]

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
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
1.7.4.4

