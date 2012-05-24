Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2EXI4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:56:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2EXI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:56:37 -0400
Message-ID: <1337849788.1028.0.camel@phoenix>
Subject: [PATCH 1/2] mfd: select REGMAP_I2C for config MFD_MAX77693
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 24 May 2012 16:56:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max77693 driver uses regmap api, thus need to select REGMAP_I2C.
This fixes below build error when CONFIG_REGMAP=y && CONFIG_REGMAP_I2C=m:

  LD      init/built-in.o
drivers/built-in.o: In function `max77693_i2c_probe':
clk-fixed-factor.c:(.text+0x541f8): undefined reference to `devm_regmap_init_i2c'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 4db63b1..e129c82 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -426,6 +426,7 @@ config MFD_MAX77693
 	bool "Maxim Semiconductor MAX77693 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
-- 
1.7.5.4



