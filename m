Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1EZNAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:00:33 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:49049 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1EZNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=v3YZoEfc5w9kGABT2gOXKuhMA8DGsuF64nCTbpYs7XqMgKoTE9aelYr75vqbDXAbHI
         aVo9ciULZYI50UVCTEC+LVxrJzJoo+TU1tibIR3z/26p4c7PsWQhkHPiKOP7jMl1eto1
         XRBWSfOem5FYrqCeTNns6+Q/NHN70/hcbPXfY=
Subject: [PATCH v2] regulator: Group TI TPSxxxxx regulators together
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 21:00:25 +0800
Message-ID: <1306414825.4042.11.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group TI TPSxxxxx regulators together and sort in alphabetical order.
This change make it easier for users to find config options.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
---
v2: also move newly added TI TPS65910 regulator to proper location in Kconfig

 drivers/regulator/Kconfig |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index d7ed20f..bcfb52c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -248,6 +248,28 @@ config REGULATOR_TPS6507X
 	  three step-down converters and two general-purpose LDO voltage regulators.
 	  It supports TI's software based Class-2 SmartReflex implementation.
 
+config REGULATOR_TPS6524X
+	tristate "TI TPS6524X Power regulators"
+	depends on SPI
+	help
+	  This driver supports TPS6524X voltage regulator chips. TPS6524X
+	  provides three step-down converters and two general-purpose LDO
+	  voltage regulators.  This device is interfaced using a customized
+	  serial interface currently supported on the sequencer serial
+	  port controller.
+
+config REGULATOR_TPS6586X
+	tristate "TI TPS6586X Power regulators"
+	depends on MFD_TPS6586X
+	help
+	  This driver supports TPS6586X voltage regulator chips.
+
+config REGULATOR_TPS65910
+	tristate "TI TPS65910 Power Regulator"
+	depends on MFD_TPS65910
+	help
+	  This driver supports TPS65910 voltage regulator chips.
+
 config REGULATOR_88PM8607
 	bool "Marvell 88PM8607 Power regulators"
 	depends on MFD_88PM860X=y
@@ -281,27 +303,5 @@ config REGULATOR_DB8500_PRCMU
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
 
-config REGULATOR_TPS6586X
-	tristate "TI TPS6586X Power regulators"
-	depends on MFD_TPS6586X
-	help
-	  This driver supports TPS6586X voltage regulator chips.
-
-config REGULATOR_TPS6524X
-	tristate "TI TPS6524X Power regulators"
-	depends on SPI
-	help
-	  This driver supports TPS6524X voltage regulator chips. TPS6524X
-	  provides three step-down converters and two general-purpose LDO
-	  voltage regulators.  This device is interfaced using a customized
-	  serial interface currently supported on the sequencer serial
-	  port controller.
-
-config REGULATOR_TPS65910
-	tristate "TI TPS65910 Power Regulator"
-	depends on MFD_TPS65910
-	help
-	  This driver supports TPS65910 voltage regulator chips.
-
 endif
 
-- 
1.7.1



