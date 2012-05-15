Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2EOGtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:49:45 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39783 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab2EOGtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:49:25 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCHv2 4/4] REGULATOR: regulator for Palmas Kconfig
Date: Tue, 15 May 2012 15:48:59 +0900
Message-Id: <1337064539-3014-5-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
References: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Kconfig/Makefile stuff for the palmas regulator driver

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/Kconfig  |   12 ++++++++++++
 drivers/regulator/Makefile |    1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4ad4e8d..c86b886 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -268,6 +268,18 @@ config REGULATOR_DB8500_PRCMU
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
 
+config REGULATOR_PALMAS
+	tristate "TI Palmas PMIC Regulators"
+	depends on MFD_PALMAS
+	help
+	  If you wish to control the regulators on the Palmas series of
+	  chips say Y here. This will enable support for all the software
+	  controllable SMPS/LDO regulators.
+
+	  The regulators available on Palmas series chips vary depending
+	  on the muxing. This is handled automatically in the driver by
+	  reading the mux info from OTP.
+
 config REGULATOR_TPS6105X
 	tristate "TI TPS6105X Power regulators"
 	depends on TPS6105X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index dcc56dc..977fd46 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
+obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
-- 
1.7.9.5

