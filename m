Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0I2Tgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:36:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53763 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0I2Tgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=P/cPfaTpYpEhlCgcznXi2rMZbP8CukF0ijvm3RZ6Oe3lcejlyDAFuu/asRHFPAGX2W
         gYndu/gr5EspFor9N+PBL81gVwHelNcqCao+n/9651Idc3B3JeaRd3xDPVgh0shyfouo
         nfbCAzzaw34oz0ga5f0x7AI+shfxX9rjVy9mk=
Subject: [PATCH 8/9] ARM: S3C64XX: add backlight control for mach-mini6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:36:42 +0300
Message-ID: <20100929193609.25307.32546.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for platform-lcd device for mach-mini6410

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---
 arch/arm/mach-s3c64xx/mach-mini6410.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c b/arch/arm/mach-s3c64xx/mach-mini6410.c
index 331f7e0..90f1976 100644
--- a/arch/arm/mach-s3c64xx/mach-mini6410.c
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@ -40,6 +40,7 @@
 #include <plat/fb.h>
 #include <plat/nand.h>
 #include <plat/regs-serial.h>
+#include <video/platform_lcd.h>
 
 #define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
 #define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
@@ -182,6 +183,25 @@ static struct s3c_fb_platdata mini6410_lcd_pdata __initdata = {
 	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
 };
 
+static void mini6410_lcd_power_set(struct plat_lcd_data *pd,
+				   unsigned int power)
+{
+	if (power)
+		gpio_direction_output(S3C64XX_GPE(0), 1);
+	else
+		gpio_direction_output(S3C64XX_GPE(0), 0);
+}
+
+static struct plat_lcd_data mini6410_lcd_power_data = {
+	.set_power	= mini6410_lcd_power_set,
+};
+
+static struct platform_device mini6410_lcd_powerdev = {
+	.name			= "platform-lcd",
+	.dev.parent		= &s3c_device_fb.dev,
+	.dev.platform_data	= &mini6410_lcd_power_data,
+};
+
 static struct platform_device *mini6410_devices[] __initdata = {
 	&mini6410_device_eth,
 	&s3c_device_hsmmc0,
@@ -189,6 +209,7 @@ static struct platform_device *mini6410_devices[] __initdata = {
 	&s3c_device_ohci,
 	&s3c_device_nand,
 	&s3c_device_fb,
+	&mini6410_lcd_powerdev,
 };
 
 static void __init mini6410_map_io(void)

