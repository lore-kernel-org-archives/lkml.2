Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030955Ab2CSGU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:20:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17168 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab2CSGUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:20:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 18 Mar 2012 23:20:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1] mfd: rc5t583: Build only if I2C config is selected to y.
Date: Mon, 19 Mar 2012 11:44:55 +0530
Message-Id: <1332137695-27719-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rc5t583 driver requires the I2C and regmap apis to
link. But linking fails if I2C is selected as loadable
module, not the module link with binary.
Fixing this error as rc5t583 driver should be built only
if CONFIG_I2C=y.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Fixing build error reported by Stephen Rothwell:
After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `rc5t583_i2c_init':
rc5t583.c:(.init.text+0xb3db): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `rc5t583_i2c_probe':
rc5t583.c:(.devinit.text+0x8fa0): undefined reference to `regmap_init_i2c'
drivers/built-in.o: In function `rc5t583_i2c_exit':
rc5t583.c:(.exit.text+0x708): undefined reference to `i2c_del_driver'

Caused by commit 1b1247dd75aa ("mfd: Add support for RICOH PMIC
RC5T583"). Presumably some missing Kconfig dependency.


 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f118a31..67fdef1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -849,7 +849,7 @@ config MFD_INTEL_MSIC
 
 config MFD_RC5T583
 	bool "Ricoh RC5T583 Power Management system device"
-	depends on I2C && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	help
-- 
1.7.1.1

