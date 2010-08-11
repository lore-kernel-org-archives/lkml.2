Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0HKBJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:09:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49510 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab0HKBJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:09:38 -0400
Date: Wed, 11 Aug 2010 11:09:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the samsung tree with Linus' and the
 arm tree
Message-Id: <20100811110933.de205605.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-s3c64xx/mach-smdk6410.c between commits
85b14a3fc4036473ec6776d8e5d92c022155d581 ("ARM: S3C64XX: Add Touchscreen
support for S3C64XX") from Linus' tree,
290d0983b86f6243beffaa3ddb02c14adc30f02a ("ARM: S3C64XX: Add keypad device to the SMDK6410 board"), 0ab0b6d226caa4a0268ecbce76a7376c3f40ee6b ("ARM: S3C64XX: Add support for Compact Flash driver on SMDK6410") from the arm tree and
commit 96e9d908a7b5b5be774ba26aca0d6633e7c97f63 ("ARM: SMDK6410: Register
AC97 controller") from the samsung tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/mach-smdk6410.c
index b5d7861,6878fbd..0000000
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@@ -66,9 -64,7 +66,10 @@@
  #include <plat/clock.h>
  #include <plat/devs.h>
  #include <plat/cpu.h>
 +#include <plat/adc.h>
 +#include <plat/ts.h>
 +#include <plat/keypad.h>
+ #include <plat/audio.h>
  
  #define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
  #define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
@@@ -282,8 -255,8 +283,9 @@@ static struct platform_device *smdk6410
  	&s3c_device_fb,
  	&s3c_device_ohci,
  	&s3c_device_usb_hsotg,
+ 	&s3c64xx_device_ac97,
  	&s3c64xx_device_iisv4,
 +	&samsung_device_keypad,
  
  #ifdef CONFIG_REGULATOR
  	&smdk6410_b_pwr_5v,
@@@ -696,8 -654,9 +698,11 @@@ static void __init smdk6410_machine_ini
  	i2c_register_board_info(0, i2c_devs0, ARRAY_SIZE(i2c_devs0));
  	i2c_register_board_info(1, i2c_devs1, ARRAY_SIZE(i2c_devs1));
  
 +	s3c_ide_set_platdata(&smdk6410_ide_pdata);
 +
+ 	/* Board defualt with CFG2.1 off */
+ 	s3c64xx_ac97_setup_gpio(S3C64XX_AC97_GPD);
+ 
  	platform_add_devices(smdk6410_devices, ARRAY_SIZE(smdk6410_devices));
  }
  
