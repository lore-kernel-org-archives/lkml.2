Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2CLRNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:13:18 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:47628 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2CLRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:13:15 -0400
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH v3 1/4] powerpc: Add GE FPGA config option
Date: Mon, 12 Mar 2012 17:12:57 +0000
Message-Id: <1331572380-1064-2-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the GE_FPGA configuration option. This is being carried
out as ground work to allow the PIC and GPIO drivers to be move from the
powerpc 86xx platform directory to more general locations to allow them to
be used on non-86xx boards and to reduce churn when further boards using
these drivers are added.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

v3: Broken out from patch moving PIC and GPIO drivers

 arch/powerpc/platforms/86xx/Kconfig  |    7 +++++++
 arch/powerpc/platforms/86xx/Makefile |    7 ++++---
 drivers/watchdog/Kconfig             |    2 +-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 8d6599d..abe2c4f 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -39,6 +39,7 @@ config GEF_PPC9A
 	select MMIO_NVRAM
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
 	help
 	  This option enables support for the GE PPC9A.
 
@@ -48,6 +49,7 @@ config GEF_SBC310
 	select MMIO_NVRAM
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
 	help
 	  This option enables support for the GE SBC310.
 
@@ -57,10 +59,15 @@ config GEF_SBC610
 	select MMIO_NVRAM
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
 	select HAS_RAPIDIO
 	help
 	  This option enables support for the GE SBC610.
 
+config GE_FPGA
+	bool
+	default n
+
 endif
 
 config MPC8641
diff --git a/arch/powerpc/platforms/86xx/Makefile b/arch/powerpc/platforms/86xx/Makefile
index 4b0d7b1..ac6a50f 100644
--- a/arch/powerpc/platforms/86xx/Makefile
+++ b/arch/powerpc/platforms/86xx/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MPC8641_HPCN)	+= mpc86xx_hpcn.o
 obj-$(CONFIG_SBC8641D)		+= sbc8641d.o
 obj-$(CONFIG_MPC8610_HPCD)	+= mpc8610_hpcd.o
 gef-gpio-$(CONFIG_GPIOLIB)	+= gef_gpio.o
-obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o gef_pic.o $(gef-gpio-y)
-obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o gef_pic.o $(gef-gpio-y)
-obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o gef_pic.o $(gef-gpio-y)
+obj-$(CONFIG_GE_FPGA)	+= gef_pic.o $(gef-gpio-y)
+obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o
+obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o
+obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..2955c3f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1039,7 +1039,7 @@ config LANTIQ_WDT
 
 config GEF_WDT
 	tristate "GE Watchdog Timer"
-	depends on GEF_SBC610 || GEF_SBC310 || GEF_PPC9A
+	depends on GE_FPGA
 	---help---
 	  Watchdog timer found in a number of GE single board computers.
 
-- 
1.7.0.4

