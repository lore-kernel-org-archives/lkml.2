Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2FGNxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:53:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:58655 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2FGNxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:53:11 -0400
Date: Thu, 7 Jun 2012 15:52:38 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH V2 1/3] i2c-nomadik: move header to
 <linux/platform_data/i2c-nomadik.h>
Message-ID: <52f48baafe44690c5bbcd36befb616d3df609e8b.1339076448.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1339076448.git.rubini@gnudd.com>
In-Reply-To: <cover.1339076448.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header and driver are only used by arm/mach-u8500 (and potentially
arm/mach-nomadik), but the STA2X11 I/O Hub exports on PCIe a number of
devices, including i2c-nomadik.  This patch allows compilation of the
driver under x86.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/devices-common.h               |    2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |    3 +--
 .../linux/platform_data/i2c-nomadik.h              |    6 +++---
 4 files changed, 6 insertions(+), 7 deletions(-)
 rename arch/arm/plat-nomadik/include/plat/i2c.h => include/linux/platform_data/i2c-nomadik.h (91%)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 9c74ac5..0bf24bb 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
+#include <linux/platform_data/i2c-nomadik.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
@@ -39,7 +40,6 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
 
-#include <plat/i2c.h>
 #include <plat/ste_dma40.h>
 #include <plat/gpio-nomadik.h>
 
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 6e47065..23cf734 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -12,7 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
-#include <plat/i2c.h>
+#include <linux/platform_data/i2c-nomadik.h>
 #include <mach/crypto-ux500.h>
 
 struct spi_master_cntlr;
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5267ab9..752f1fd 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -23,8 +23,7 @@
 #include <linux/io.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
-
-#include <plat/i2c.h>
+#include <linux/platform_data/i2c-nomadik.h>
 
 #define DRIVER_NAME "nmk-i2c"
 
diff --git a/arch/arm/plat-nomadik/include/plat/i2c.h b/include/linux/platform_data/i2c-nomadik.h
similarity index 91%
rename from arch/arm/plat-nomadik/include/plat/i2c.h
rename to include/linux/platform_data/i2c-nomadik.h
index 8ba70ff..c2303c3 100644
--- a/arch/arm/plat-nomadik/include/plat/i2c.h
+++ b/include/linux/platform_data/i2c-nomadik.h
@@ -5,8 +5,8 @@
  * it under the terms of the GNU General Public License version 2, as
  * published by the Free Software Foundation.
  */
-#ifndef __PLAT_I2C_H
-#define __PLAT_I2C_H
+#ifndef __PDATA_I2C_NOMADIK_H
+#define __PDATA_I2C_NOMADIK_H
 
 enum i2c_freq_mode {
 	I2C_FREQ_MODE_STANDARD,		/* up to 100 Kb/s */
@@ -36,4 +36,4 @@ struct nmk_i2c_controller {
 	enum i2c_freq_mode	sm;
 };
 
-#endif	/* __PLAT_I2C_H */
+#endif	/* __PDATA_I2C_NOMADIK_H */
-- 
1.7.7.2
