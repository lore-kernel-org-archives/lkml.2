Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0IQNcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:32:08 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:33066 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159Ab0IQNcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:32:06 -0400
Message-ID: <4C936DD5.6050402@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:32:05 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: of: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------000309040909090300040907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309040909090300040907
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...
Looks like most of arches select OF, but 2 modules still #ifdef.





--------------000309040909090300040907
Content-Type: text/plain;
 name="mods-of.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-of.patch"

Fix lost OF modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c	2010-09-17 12:30:29.000000000 +0300
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c	2010-09-17 12:38:39.564252081 +0300
@@ -554,6 +554,9 @@ static int __init mpc52xx_lpbfifo_init(v
 	pr_debug("Registering LocalPlus bus FIFO driver\n");
 	return of_register_platform_driver(&mpc52xx_lpbfifo_driver);
 }
+
+MODULE_DEVICE_TABLE(of, mpc52xx_lpbfifo_match);
+
 module_init(mpc52xx_lpbfifo_init);
 
 static void __exit mpc52xx_lpbfifo_exit(void)
--- linux-2.6.36-rc4-git3/arch/powerpc/platforms/83xx/suspend.c	2010-09-17 12:30:29.000000000 +0300
+++ b/arch/powerpc/platforms/83xx/suspend.c	2010-09-17 12:38:39.772893481 +0300
@@ -437,4 +437,7 @@ static int pmc_init(void)
 	return of_register_platform_driver(&pmc_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, pmc_match);
+
 module_init(pmc_init);
--- linux-2.6.36-rc4-git3/arch/powerpc/sysdev/axonram.c	2010-09-17 12:30:29.000000000 +0300
+++ b/arch/powerpc/sysdev/axonram.c	2010-09-17 12:38:40.134532872 +0300
@@ -363,6 +363,9 @@ axon_ram_exit(void)
 	unregister_blkdev(azfs_major, AXON_RAM_DEVICE_NAME);
 }
 
+
+MODULE_DEVICE_TABLE(of, axon_ram_device_id);
+
 module_init(axon_ram_init);
 module_exit(axon_ram_exit);
 
--- linux-2.6.36-rc4-git3/drivers/block/swim3.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/block/swim3.c	2010-09-17 12:38:42.154345639 +0300
@@ -1203,6 +1203,9 @@ int swim3_init(void)
 	return 0;
 }
 
+
+MODULE_DEVICE_TABLE(of, swim3_match);
+
 module_init(swim3_init)
 
 MODULE_LICENSE("GPL");
--- linux-2.6.36-rc4-git3/drivers/char/hw_random/pasemi-rng.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/char/hw_random/pasemi-rng.c	2010-09-17 12:38:42.754071285 +0300
@@ -153,6 +153,9 @@ static int __init rng_init(void)
 {
 	return of_register_platform_driver(&rng_driver);
 }
+
+MODULE_DEVICE_TABLE(of, rng_match);
+
 module_init(rng_init);
 
 static void __exit rng_exit(void)
--- linux-2.6.36-rc4-git3/drivers/crypto/amcc/crypto4xx_core.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/crypto/amcc/crypto4xx_core.c	2010-09-17 12:38:43.742801898 +0300
@@ -1300,6 +1300,9 @@ static void __exit crypto4xx_exit(void)
 	of_unregister_platform_driver(&crypto4xx_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, crypto4xx_match);
+
 module_init(crypto4xx_init);
 module_exit(crypto4xx_exit);
 
--- linux-2.6.36-rc4-git3/drivers/dma/mpc512x_dma.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/dma/mpc512x_dma.c	2010-09-17 12:38:44.062590960 +0300
@@ -784,6 +784,9 @@ static int __init mpc_dma_init(void)
 {
 	return of_register_platform_driver(&mpc_dma_driver);
 }
+
+MODULE_DEVICE_TABLE(of, mpc_dma_match);
+
 module_init(mpc_dma_init);
 
 static void __exit mpc_dma_exit(void)
--- linux-2.6.36-rc4-git3/drivers/edac/ppc4xx_edac.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/edac/ppc4xx_edac.c	2010-09-17 12:38:44.741831449 +0300
@@ -1437,6 +1437,9 @@ ppc4xx_edac_exit(void)
 	of_unregister_platform_driver(&ppc4xx_edac_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, ppc4xx_edac_match);
+
 module_init(ppc4xx_edac_init);
 module_exit(ppc4xx_edac_exit);
 
--- linux-2.6.36-rc4-git3/drivers/i2c/busses/i2c-ibm_iic.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/i2c/busses/i2c-ibm_iic.c	2010-09-17 12:38:47.562542364 +0300
@@ -824,5 +824,8 @@ static void __exit iic_exit(void)
 	of_unregister_platform_driver(&ibm_iic_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, ibm_iic_match);
+
 module_init(iic_init);
 module_exit(iic_exit);
--- linux-2.6.36-rc4-git3/drivers/input/misc/sparcspkr.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/input/misc/sparcspkr.c	2010-09-17 12:38:48.854974912 +0300
@@ -370,5 +370,8 @@ static void __exit sparcspkr_exit(void)
 	of_unregister_platform_driver(&grover_beep_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, bbc_beep_match);
+
 module_init(sparcspkr_init);
 module_exit(sparcspkr_exit);
--- linux-2.6.36-rc4-git3/drivers/macintosh/rack-meter.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/macintosh/rack-meter.c	2010-09-17 12:38:50.321238921 +0300
@@ -609,6 +609,9 @@ static void __exit rackmeter_exit(void)
 	macio_unregister_driver(&rackmeter_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, rackmeter_match);
+
 module_init(rackmeter_init);
 module_exit(rackmeter_exit);
 
--- linux-2.6.36-rc4-git3/drivers/mtd/nand/fsl_elbc_nand.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/mtd/nand/fsl_elbc_nand.c	2010-09-17 12:38:53.522689282 +0300
@@ -1096,6 +1096,9 @@ static void __exit fsl_elbc_exit(void)
 	of_unregister_platform_driver(&fsl_elbc_ctrl_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, fsl_elbc_match);
+
 module_init(fsl_elbc_init);
 module_exit(fsl_elbc_exit);
 
--- linux-2.6.36-rc4-git3/drivers/mtd/nand/mpc5121_nfc.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/mtd/nand/mpc5121_nfc.c	2010-09-17 12:38:53.772581461 +0300
@@ -903,6 +903,9 @@ static int __init mpc5121_nfc_init(void)
 	return of_register_platform_driver(&mpc5121_nfc_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, mpc5121_nfc_match);
+
 module_init(mpc5121_nfc_init);
 
 static void __exit mpc5121_nfc_cleanup(void)
--- linux-2.6.36-rc4-git3/drivers/net/can/mscan/mpc5xxx_can.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/net/can/mscan/mpc5xxx_can.c	2010-09-17 12:38:54.082643029 +0300
@@ -409,6 +409,9 @@ static int __init mpc5xxx_can_init(void)
 {
 	return of_register_platform_driver(&mpc5xxx_can_driver);
 }
+
+MODULE_DEVICE_TABLE(of, __devinitdatampc52xx_cdm_ids);
+
 module_init(mpc5xxx_can_init);
 
 static void __exit mpc5xxx_can_exit(void)
--- linux-2.6.36-rc4-git3/drivers/rtc/rtc-mpc5121.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/rtc/rtc-mpc5121.c	2010-09-17 12:38:57.285620109 +0300
@@ -378,6 +378,9 @@ static int __init mpc5121_rtc_init(void)
 {
 	return of_register_platform_driver(&mpc5121_rtc_driver);
 }
+
+MODULE_DEVICE_TABLE(of, mpc5121_rtc_match);
+
 module_init(mpc5121_rtc_init);
 
 static void __exit mpc5121_rtc_exit(void)
--- linux-2.6.36-rc4-git3/drivers/serial/cpm_uart/cpm_uart_core.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c	2010-09-17 12:38:57.892664025 +0300
@@ -1415,6 +1415,9 @@ static void __exit cpm_uart_exit(void)
 	uart_unregister_driver(&cpm_reg);
 }
 
+
+MODULE_DEVICE_TABLE(of, cpm_uart_match);
+
 module_init(cpm_uart_init);
 module_exit(cpm_uart_exit);
 
--- linux-2.6.36-rc4-git3/drivers/serial/apbuart.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/serial/apbuart.c	2010-09-17 12:38:58.222634640 +0300
@@ -701,6 +701,9 @@ static void __exit grlib_apbuart_exit(vo
 	of_unregister_platform_driver(&grlib_apbuart_of_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, __initdataapbuart_match);
+
 module_init(grlib_apbuart_init);
 module_exit(grlib_apbuart_exit);
 
--- linux-2.6.36-rc4-git3/drivers/serial/of_serial.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/serial/of_serial.c	2010-09-17 12:38:58.422708279 +0300
@@ -187,6 +187,9 @@ static int __init of_platform_serial_ini
 {
 	return of_register_platform_driver(&of_platform_serial_driver);
 }
+
+MODULE_DEVICE_TABLE(of, __devinitdataof_platform_serial_table);
+
 module_init(of_platform_serial_init);
 
 static void __exit of_platform_serial_exit(void)
--- linux-2.6.36-rc4-git3/drivers/video/platinumfb.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/video/platinumfb.c	2010-09-17 12:39:06.232755519 +0300
@@ -709,6 +709,9 @@ static void __exit platinumfb_exit(void)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("framebuffer driver for Apple Platinum video");
+
+MODULE_DEVICE_TABLE(of, platinumfb_match);
+
 module_init(platinumfb_init);
 
 #ifdef MODULE
--- linux-2.6.36-rc4-git3/drivers/watchdog/gef_wdt.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/watchdog/gef_wdt.c	2010-09-17 12:39:07.232816804 +0300
@@ -322,6 +322,9 @@ static void __exit gef_wdt_exit(void)
 	of_unregister_platform_driver(&gef_wdt_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, gef_wdt_ids);
+
 module_init(gef_wdt_init);
 module_exit(gef_wdt_exit);
 
--- linux-2.6.36-rc4-git3/sound/sparc/amd7930.c	2010-09-17 12:30:32.000000000 +0300
+++ b/sound/sparc/amd7930.c	2010-09-17 12:39:08.099147434 +0300
@@ -1095,5 +1095,8 @@ static void __exit amd7930_exit(void)
 	of_unregister_platform_driver(&amd7930_sbus_driver);
 }
 
+
+MODULE_DEVICE_TABLE(of, amd7930_match);
+
 module_init(amd7930_init);
 module_exit(amd7930_exit);
--- linux-2.6.36-rc4-git3/drivers/leds/leds-gpio.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/leds/leds-gpio.c	2010-09-17 12:38:50.231069935 +0300
@@ -344,6 +344,11 @@ static void __exit gpio_led_exit(void)
 #endif
 }
 
+
+#ifdef CONFIG_OF
+MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
+#endif
+
 module_init(gpio_led_init);
 module_exit(gpio_led_exit);
 
--- linux-2.6.36-rc4-git3/drivers/mmc/host/mmc_spi.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/mmc/host/mmc_spi.c	2010-09-17 12:38:53.357999577 +0300
@@ -1521,6 +1521,11 @@ static int __init mmc_spi_init(void)
 {
 	return spi_register_driver(&mmc_spi_driver);
 }
+
+#ifdef CONFIG_OF
+MODULE_DEVICE_TABLE(of, mmc_spi_of_match_table);
+#endif
+
 module_init(mmc_spi_init);
 
 

--------------000309040909090300040907--
