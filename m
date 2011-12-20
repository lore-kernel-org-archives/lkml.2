Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1LTBQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:16:17 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36781 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab1LTBPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:15:37 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Liam Girdwood <lrg@ti.com> (supporter:VOLTAGE AND CURRE...),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:VOLTAGE
	AND CURRE...)
Subject: [PATCH v4 3/4] regulator: simplify twl4030 config
Date: Tue, 20 Dec 2011 03:15:16 +0200
Message-Id: <1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have TWL4030_CORE and REGULATOR, we *obviously* want
REGULATOR_TWL4030 by default. But can be disabled if somebody wants for
some strange reason.

This decreases the defconfig from:

 CONFIG_TWL4030_CORE=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_TWL4030=y

To:

 CONFIG_TWL4030_CORE=y
 CONFIG_REGULATOR=y

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/regulator/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9713b1b..e980b2f 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -138,6 +138,7 @@ config REGULATOR_MAX8998
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
 	depends on TWL4030_CORE
+	default y
 	help
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
-- 
1.7.8.rc1.14.g248db

