Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2GRGmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:42:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55729 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2GRGl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:41:56 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <rdunlap@xenotime.net>
CC: <sfr@canb.auug.org.au>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH] regulator: tps65217: fix build error if REGULATOR is not enabled
Date: Wed, 18 Jul 2012 12:11:03 +0530
Message-ID: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes below build error if CONFIG_REGULATOR is not enabled.

drivers/built-in.o: In function `tps65217_probe':
tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_match'

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..01c929a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -159,6 +159,7 @@ config TPS6507X
 config MFD_TPS65217
 	tristate "TPS65217 Power Management / White LED chips"
 	depends on I2C
+	depends on REGULATOR
 	select MFD_CORE
 	select REGMAP_I2C
 	help
-- 
1.7.9.5

