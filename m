Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1DNEPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:15:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44458 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1DNEPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:15:33 -0400
Date: Thu, 14 Apr 2011 14:15:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the usb tree with the s5p tree
Message-Id: <20110414141526.e0d5efa1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-exynos4/mach-nuri.c between commit d2a852f78de6 ("ARM:
EXYNOS4: Add Atmel mXT touchscreen device to the NURI board") from the
s5p tree and commit 01da92f7f643 ("ARM: EXYNOS4: Add usb ehci device to
the NURI board") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos4/mach-nuri.c
index d13c5e8,bb5d12f..0000000
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@@ -31,8 -30,8 +31,10 @@@
  #include <plat/cpu.h>
  #include <plat/devs.h>
  #include <plat/sdhci.h>
 +#include <plat/gpio-cfg.h>
 +#include <plat/iic.h>
+ #include <plat/ehci.h>
+ #include <plat/clock.h>
  
  #include <mach/map.h>
  
@@@ -355,7 -282,7 +367,8 @@@ static struct platform_device *nuri_dev
  	&s3c_device_hsmmc3,
  	&s3c_device_wdt,
  	&s3c_device_timer[0],
 +	&s3c_device_i2c3,
+ 	&s5p_device_ehci,
  
  	/* NURI Devices */
  	&nuri_gpio_keys,
@@@ -373,13 -300,13 +386,16 @@@ static void __init nuri_map_io(void
  static void __init nuri_machine_init(void)
  {
  	nuri_sdhci_init();
 +	nuri_tsp_init();
  
  	i2c_register_board_info(1, i2c1_devs, ARRAY_SIZE(i2c1_devs));
 +	s3c_i2c3_set_platdata(&i2c3_data);
 +	i2c_register_board_info(3, i2c3_devs, ARRAY_SIZE(i2c3_devs));
  	i2c_register_board_info(5, i2c5_devs, ARRAY_SIZE(i2c5_devs));
  
+ 	nuri_ehci_init();
+ 	clk_xusbxti.rate = 24000000;
+ 
  	/* Last */
  	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
  }
