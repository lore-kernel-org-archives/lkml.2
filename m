Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0I2Tdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:33:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61953 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0I2Tdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=K+Z1yC1rl0IVMN7vy0dRoNxghceA6gE+jcUBb5kC1awZwgZuPclgIcGl9MMt5pEyjN
         ljyCUeS/NKpXXnEk2pxOlZxkq8wmP1dZagcnwXDZgkpyIZC44Il4D+X2IclhM7klZixs
         NbC78eLVG3DBRUkCqXOwA25ld2wUgHzdQb7Rs=
Subject: [PATCH 3/9] ARM: S3C64XX: add touchscreen support for mach-real6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:33:39 +0300
Message-ID: <20100929193322.25307.67196.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add touchscreen device support for mach-real6410

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---
 arch/arm/mach-s3c64xx/Kconfig         |    2 ++
 arch/arm/mach-s3c64xx/mach-real6410.c |   11 +++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index e4aede1..b706b80 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -107,6 +107,8 @@ config MACH_REAL6410
 	select S3C_DEV_FB
 	select S3C64XX_SETUP_FB_24BPP
 	select S3C_DEV_NAND
+	select SAMSUNG_DEV_ADC
+	select SAMSUNG_DEV_TS
 	help
 	  Machine support for the CoreWind REAL6410
 
diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-s3c64xx/mach-real6410.c
index 9fd943d..bad6990 100644
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@ -36,11 +36,13 @@
 #include <mach/regs-srom.h>
 #include <mach/s3c6410.h>
 
+#include <plat/adc.h>
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/fb.h>
 #include <plat/nand.h>
 #include <plat/regs-serial.h>
+#include <plat/ts.h>
 
 #include <video/platform_lcd.h>
 
@@ -191,6 +193,14 @@ static struct platform_device *real6410_devices[] __initdata = {
 	&s3c_device_hsmmc1,
 	&s3c_device_fb,
 	&s3c_device_nand,
+	&s3c_device_adc,
+	&s3c_device_ts,
+};
+
+static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {
+	.delay			= 10000,
+	.presc			= 49,
+	.oversampling_shift	= 2,
 };
 
 static void __init real6410_map_io(void)
@@ -289,6 +299,7 @@ static void __init real6410_machine_init(void)
 
 	s3c_fb_set_platdata(&real6410_lcd_pdata);
 	s3c_nand_set_platdata(&real6410_nand_info);
+	s3c24xx_ts_set_platdata(&s3c_ts_platform);
 
 	/* configure nCS1 width to 16 bits */
 

