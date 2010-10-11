Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0JKCfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 22:35:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0JKCfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 22:35:30 -0400
Date: Mon, 11 Oct 2010 13:35:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the sound-asoc tree with the s5p tree
Message-Id: <20101011133519.cf4fcaa8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/mach-s3c64xx/dev-audio.c between commit
f08269d850e4ee0cd028cf5279cc08259d0469df ("ARM: S3C64XX: Change to using
s3c_gpio_cfgpin_range()") from the s5p tree and commit
e4b6b74ffd32d114227a5dcfe814e2cecd80554b ("ARM: S3C64XX: Fix fallthrough
bug in i2sv3 gpio configuration, improve logging") from the sound-asoc
tree.

Both patches added the needed "break".  I fixed it up (see below) and can
carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/dev-audio.c
index e4bb023,3838335..0000000
--- a/arch/arm/mach-s3c64xx/dev-audio.c
+++ b/arch/arm/mach-s3c64xx/dev-audio.c
@@@ -22,19 -22,31 +22,20 @@@
  #include <plat/audio.h>
  #include <plat/gpio-cfg.h>
  
 -#include <mach/gpio-bank-c.h>
 -#include <mach/gpio-bank-d.h>
 -#include <mach/gpio-bank-e.h>
 -#include <mach/gpio-bank-h.h>
 -
  static int s3c64xx_i2sv3_cfg_gpio(struct platform_device *pdev)
  {
 +	unsigned int base;
 +
  	switch (pdev->id) {
  	case 0:
 -		s3c_gpio_cfgpin(S3C64XX_GPD(0), S3C64XX_GPD0_I2S0_CLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(1), S3C64XX_GPD1_I2S0_CDCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(2), S3C64XX_GPD2_I2S0_LRCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(3), S3C64XX_GPD3_I2S0_DI);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(4), S3C64XX_GPD4_I2S0_D0);
 +		base = S3C64XX_GPD(0);
  		break;
  	case 1:
 -		s3c_gpio_cfgpin(S3C64XX_GPE(0), S3C64XX_GPE0_I2S1_CLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(1), S3C64XX_GPE1_I2S1_CDCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(2), S3C64XX_GPE2_I2S1_LRCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(3), S3C64XX_GPE3_I2S1_DI);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(4), S3C64XX_GPE4_I2S1_D0);
 +		base = S3C64XX_GPE(0);
  		break;
  	default:
- 		printk(KERN_DEBUG "Invalid I2S Controller number!");
+ 		printk(KERN_DEBUG "Invalid I2S Controller number: %d\n",
+ 			pdev->id);
  		return -EINVAL;
  	}
  
@@@ -157,17 -170,24 +158,18 @@@ EXPORT_SYMBOL(s3c64xx_device_iisv4)
  
  static int s3c64xx_pcm_cfg_gpio(struct platform_device *pdev)
  {
 +	unsigned int base;
 +
  	switch (pdev->id) {
  	case 0:
 -		s3c_gpio_cfgpin(S3C64XX_GPD(0), S3C64XX_GPD0_PCM0_SCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(1), S3C64XX_GPD1_PCM0_EXTCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(2), S3C64XX_GPD2_PCM0_FSYNC);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(3), S3C64XX_GPD3_PCM0_SIN);
 -		s3c_gpio_cfgpin(S3C64XX_GPD(4), S3C64XX_GPD4_PCM0_SOUT);
 +		base = S3C64XX_GPD(0);
  		break;
  	case 1:
 -		s3c_gpio_cfgpin(S3C64XX_GPE(0), S3C64XX_GPE0_PCM1_SCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(1), S3C64XX_GPE1_PCM1_EXTCLK);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(2), S3C64XX_GPE2_PCM1_FSYNC);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(3), S3C64XX_GPE3_PCM1_SIN);
 -		s3c_gpio_cfgpin(S3C64XX_GPE(4), S3C64XX_GPE4_PCM1_SOUT);
 +		base = S3C64XX_GPE(0);
  		break;
  	default:
- 		printk(KERN_DEBUG "Invalid PCM Controller number!");
+ 		printk(KERN_DEBUG "Invalid PCM Controller number: %d\n",
+ 			pdev->id);
  		return -EINVAL;
  	}
  
