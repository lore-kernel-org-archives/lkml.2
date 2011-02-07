Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1BGBvC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:51:02 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1136 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754383Ab1BGBul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:41 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 09/09] ARM: s3c2440: gta02: Add touchscreen support
Date: Mon,  7 Feb 2011 02:52:01 +0100
Message-Id: <1297043521-21903-9-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch registers the s3c touchscreen and adc devices to add touchscreen
support for the gta02.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 94456fa..2300ec5 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -79,6 +79,8 @@
 #include <mach/regs-mem.h>
 #include <mach/hardware.h>
 
+#include <plat/ts.h>
+
 #include <mach/gta02.h>
 
 #include <plat/regs-serial.h>
@@ -480,6 +482,13 @@ static struct s3c2410_hcd_info gta02_usb_info __initdata = {
 	},
 };
 
+/* Touchscreen */
+static struct s3c2410_ts_mach_info gta02_ts_info = {
+	.delay = 10000,
+	.presc = 0xff, /* slow as we can go */
+	.oversampling_shift = 2,
+};
+
 /* Buttons */
 static struct gpio_keys_button gta02_buttons[] = {
 	{
@@ -533,6 +542,8 @@ static struct platform_device *gta02_devices[] __initdata = {
 	&samsung_asoc_dma,
 	&s3c_device_i2c0,
 	&gta02_buttons_device,
+	&s3c_device_adc,
+	&s3c_device_ts,
 };
 
 /* These guys DO need to be children of PMU. */
@@ -597,6 +608,7 @@ static void __init gta02_machine_init(void)
 #endif
 
 	s3c24xx_udc_set_platdata(&gta02_udc_cfg);
+	s3c24xx_ts_set_platdata(&gta02_ts_info);
 	s3c_ohci_set_platdata(&gta02_usb_info);
 	s3c_nand_set_platdata(&gta02_nand_info);
 	s3c_i2c0_set_platdata(NULL);
-- 
1.7.2.3

