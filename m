Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2JOIWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:22:44 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:8340
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab2JOIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:22:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1d1ah1d2ah1082kzz8275ch8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <fengguang.wu@intel.com>, <rdunlap@xenotime.net>,
        <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
Subject: [PATCH 1/1] regmap: select REGMAP if REGMAP_MMIO and REGMAP_IRQ enabled
Date: Mon, 15 Oct 2012 15:50:25 +0800
Message-ID: <1350287425-19181-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The regmap_mmio and regmap_irq depend on regmap core, if not select,
we may not compile regmap core and meet compiling errors as follows
if REGMAP_MMIO is selected by client drivers:
drivers/mfd/syscon.c:94:15: error: variable 'syscon_regmap_config' has initializer but incomplete type
drivers/mfd/syscon.c:95:2: error: unknown field 'reg_bits' specified in initializer
drivers/mfd/syscon.c:95:2: warning: excess elements in struct initializer [enabled by default]
drivers/mfd/syscon.c:95:2: warning: (near initialization for 'syscon_regmap_config') [enabled by default]
drivers/mfd/syscon.c:96:2: error: unknown field 'val_bits' specified in initializer
drivers/mfd/syscon.c:96:2: warning: excess elements in struct initializer [enabled by default]
drivers/mfd/syscon.c:96:2: warning: (near initialization for 'syscon_regmap_config') [enabled by default]
drivers/mfd/syscon.c:97:2: error: unknown field 'reg_stride' specified in initializer
drivers/mfd/syscon.c:97:2: warning: excess elements in struct initializer [enabled by default]
drivers/mfd/syscon.c:97:2: warning: (near initialization for 'syscon_regmap_config') [enabled by default]
drivers/mfd/syscon.c: In function 'syscon_probe':
drivers/mfd/syscon.c:124:2: error: invalid use of undefined type 'struct regmap_config'
drivers/mfd/syscon.c:125:2: error: implicit declaration of function 'devm_regmap_init_mmio' [-Werror=implicit-function-declaration]
drivers/mfd/syscon.c:125:17: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors

drivers/mfd/Kconfig:
config MFD_SYSCON
        bool "System Controller Register R/W Based on Regmap"
	depends on OF
	select REGMAP_MMIO
	help
	  Select this option to enable accessing system control registers
	    via regmap.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/base/regmap/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 6be390b..f0d3054 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,7 +3,7 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_MMIO || REGMAP_IRQ)
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	select IRQ_DOMAIN if REGMAP_IRQ
-- 
1.7.0.4


