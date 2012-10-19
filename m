Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab2JSAEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:04:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58067 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2JSAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:04:48 -0400
From: Fabio Estevam <festevam@gmail.com>
To: rob.herring@calxeda.com
Cc: shawn.guo@linaro.org, kernel@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/2] mfd: Kconfig: Let MFD_SYSCON select REGMAP
Date: Thu, 18 Oct 2012 21:04:06 -0300
Message-Id: <1350605046-21358-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350605046-21358-1-git-send-email-festevam@gmail.com>
References: <1350605046-21358-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Building multi_v7_defconfig for mx6 causes the following build error:

  CC      drivers/mfd/syscon.o
drivers/mfd/syscon.c:94: error: variable 'syscon_regmap_config' has initializer but incomplete type
drivers/mfd/syscon.c:95: error: unknown field 'reg_bits' specified in initializer
drivers/mfd/syscon.c:95: warning: excess elements in struct initializer
drivers/mfd/syscon.c:95: warning: (near initialization for 'syscon_regmap_config')
drivers/mfd/syscon.c:96: error: unknown field 'val_bits' specified in initializer
drivers/mfd/syscon.c:96: warning: excess elements in struct initializer
drivers/mfd/syscon.c:96: warning: (near initialization for 'syscon_regmap_config')
drivers/mfd/syscon.c:97: error: unknown field 'reg_stride' specified in initializer
drivers/mfd/syscon.c:97: warning: excess elements in struct initializer
drivers/mfd/syscon.c:97: warning: (near initialization for 'syscon_regmap_config')
drivers/mfd/syscon.c: In function 'syscon_probe':
drivers/mfd/syscon.c:124: error: invalid use of undefined type 'struct regmap_config'
drivers/mfd/syscon.c:125: error: implicit declaration of function 'devm_regmap_init_mmio'
drivers/mfd/syscon.c:126: warning: assignment makes pointer from integer without a cast

Fix it by selecting REGMAP option.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- No changes. Newly introduced in this series

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acab3ef..ef56515 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1030,6 +1030,7 @@ config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
 	depends on OF
 	select REGMAP_MMIO
+	select REGMAP
 	help
 	  Select this option to enable accessing system control registers
 	  via regmap.
-- 
1.7.9.5

