Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1CADyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 22:54:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57573 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1CADyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 22:54:46 -0500
Date: Tue, 1 Mar 2011 14:54:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, David Jander <david@protonic.nl>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the mfd tree with the i.MX tree
Message-Id: <20110301145436.b1ae1923.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-imx/mach-mx27_3ds.c arch/arm/mach-imx/mach-pcm038.c
arch/arm/mach-mx3/mach-mx31_3ds.c arch/arm/mach-mx3/mach-mx31moboard.c
between commit 5836372e8a0ba5cc633f61bc0484ee20c86f4b36 ("ARM: imx+mx3:
convert to mc13xxx MFD") from the i.MX tree and commit
e84e545d47d26644275a79fe5ebc1797bcb80910 ("mfd: mfd_cell is now
implicitly available to mc13xxx drivers") from the mfd tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-mx27_3ds.c
index ba88417,4bf1962..0000000
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@@ -231,10 -227,13 +231,13 @@@ static struct mc13xxx_regulator_init_da
  };
  
  /* MC13783 */
 -static struct mc13783_platform_data mc13783_pdata = {
 +static struct mc13xxx_platform_data mc13783_pdata __initdata = {
- 	.regulators = mx27_3ds_regulators,
- 	.num_regulators = ARRAY_SIZE(mx27_3ds_regulators),
+ 	.regulators = {
+ 		.regulators = mx27_3ds_regulators,
+ 		.num_regulators = ARRAY_SIZE(mx27_3ds_regulators),
+ 
+ 	},
 -	.flags  = MC13783_USE_REGULATOR,
 +	.flags  = MC13XXX_USE_REGULATOR,
  };
  
  /* SPI */
diff --cc arch/arm/mach-imx/mach-pcm038.c
index 38c7708,c4c8fb1..0000000
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@@ -262,11 -262,13 +262,13 @@@ static struct mc13xxx_regulator_init_da
  	},
  };
  
 -static struct mc13783_platform_data pcm038_pmic = {
 +static struct mc13xxx_platform_data pcm038_pmic = {
- 	.regulators = pcm038_regulators,
- 	.num_regulators = ARRAY_SIZE(pcm038_regulators),
+ 	.regulators = {
+ 		.regulators = pcm038_regulators,
+ 		.num_regulators = ARRAY_SIZE(pcm038_regulators),
+ 	},
 -	.flags = MC13783_USE_ADC | MC13783_USE_REGULATOR |
 -		 MC13783_USE_TOUCHSCREEN,
 +	.flags = MC13XXX_USE_ADC | MC13XXX_USE_REGULATOR |
 +		 MC13XXX_USE_TOUCHSCREEN,
  };
  
  static struct spi_board_info pcm038_spi_board_info[] __initdata = {
diff --cc arch/arm/mach-mx3/mach-mx31_3ds.c
index b7d0953,88516af..0000000
--- a/arch/arm/mach-mx3/mach-mx31_3ds.c
+++ b/arch/arm/mach-mx3/mach-mx31_3ds.c
@@@ -152,10 -156,12 +152,13 @@@ static struct mc13xxx_regulator_init_da
  };
  
  /* MC13783 */
 +static struct mc13xxx_platform_data mc13783_pdata __initdata = {
- 	.regulators = mx31_3ds_regulators,
- 	.num_regulators = ARRAY_SIZE(mx31_3ds_regulators),
- 	.flags  = MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN
+ static struct mc13783_platform_data mc13783_pdata = {
+ 	.regulators = {
+ 		.regulators = mx31_3ds_regulators,
+ 		.num_regulators = ARRAY_SIZE(mx31_3ds_regulators),
+ 	},
 -	.flags  = MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN,
++	.flags  = MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN,
  };
  
  /* SPI */
diff --cc arch/arm/mach-mx3/mach-mx31moboard.c
index 845d0b6,3a9c589..0000000
--- a/arch/arm/mach-mx3/mach-mx31moboard.c
+++ b/arch/arm/mach-mx3/mach-mx31moboard.c
@@@ -267,12 -267,14 +267,14 @@@ static struct mc13783_leds_platform_dat
  	.tc2_period = MC13783_LED_PERIOD_10MS,
  };
  
 -static struct mc13783_platform_data moboard_pmic = {
 +static struct mc13xxx_platform_data moboard_pmic = {
- 	.regulators = moboard_regulators,
- 	.num_regulators = ARRAY_SIZE(moboard_regulators),
+ 	.regulators = {
+ 		.regulators = moboard_regulators,
+ 		.num_regulators = ARRAY_SIZE(moboard_regulators),
+ 	},
  	.leds = &moboard_leds,
 -	.flags = MC13783_USE_REGULATOR | MC13783_USE_RTC |
 -		MC13783_USE_ADC | MC13783_USE_LED,
 +	.flags = MC13XXX_USE_REGULATOR | MC13XXX_USE_RTC |
 +		MC13XXX_USE_ADC | MC13XXX_USE_LED,
  };
  
  static struct spi_board_info moboard_spi_board_info[] __initdata = {
