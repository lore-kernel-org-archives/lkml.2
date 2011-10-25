Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1JYSyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:54:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1JYSyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:54:05 -0400
Date: Tue, 25 Oct 2011 14:54:00 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: wm8400-core: select REGMAP_I2C in kconfig
Message-ID: <20111025185359.GA21019@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8400-core.c is using the regmap I2C API, so needs to select it.

ERROR: "regmap_write" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_raw_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_init_i2c" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_bulk_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_exit" [drivers/mfd/wm8400-core.ko] undefined!

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a67adcb..67a6126 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -389,6 +389,7 @@ config MFD_MAX8998
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
+	select REGMAP_I2C
 	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
