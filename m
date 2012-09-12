Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab2ILCVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:21:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21817 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2ILCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:21:07 -0400
X-AuditID: cbfee61a-b7fba6d000007d5f-00-504ff18beb10
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Jeff Garzik'" <jgarzik@pobox.com>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Wolfram Sang (embedded platforms)'" <w.sang@pengutronix.de>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Bryan Wu'" <bryan.wu@canonical.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>, "'Liam Girdwood'" <lrg@ti.com>,
        linux-samsung-soc@vger.kernel.org
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368559-31329-1-git-send-email-arnd@arndb.de>
 <1347368559-31329-3-git-send-email-arnd@arndb.de>
In-reply-to: <1347368559-31329-3-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 15/16] ARM: samsung: move platform_data definitions
Date: Wed, 12 Sep 2012 11:20:54 +0900
Message-id: <010001cd908d$3e7a3fc0$bb6ebf40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2QHdcMrmrO3xZcSGWGgcXnY9ME5gAY/42w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd3uj/4BBq/3cFlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcfXCVreB/ccWVhllMDYxdoV2MnBwSAiYSW1edYIaw
	xSQu3FvP1sXIxSEksIhRYu7HXiYI5y+jxNnWD+wgVWwCGhKH3z8Ds0UEPCXOnFzAAmIzCyxh
	l9jeKQLRsJRR4uqcz2wgCU4BO4lTXdcYQWxhAXeJEze/MIHYLAKqEie+vgJr5hWwlVjx9T0r
	hC0o8WPyPaihWhLrdx5ngrDlJTaveQt0KgfQqeoSj/7qQtxgJNF75C9UiYjEvhfvGCcwCs1C
	MmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgoH4mtYNxZYPFIUYB
	DkYlHt4Tlf4BQqyJZcWVuYcYJTiYlUR4062AQrwpiZVVqUX58UWlOanFhxilOViUxHmdztkF
	CAmkJ5akZqemFqQWwWSZODilGhgVMm9PsEt/+yQmMFA8gCNj4cHfav+m7JLs1epbqXvxIqNX
	+exnXAzMj3UeFi5mnnvvUJLNBb3IvF9Gy+z1HFb8fbN/Qjjr6z33o3jY7jAGREUm1fEHph66
	GRu/0WJzVOult2kloor6Xvsy0zS3iz9m/uHcOCnJ81Vgpu8p08JdV5yve2YnTlViKc5INNRi
	LipOBADi3OMVZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the samsung include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Yeah, basically looks OK on this.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

BTW, how about re-ordering inclusion <linux/platform_data/xxx.h> after
<linux/xxx.h> rather than just replacing like following?

---
#include <linux/xxx.h>
...
#include <linux/platform_data/xxx.h>
...
#include <mach/xxx.h>
...
#include <plat/xxx.h>
...
---

And there are small comments...

> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: linux-samsung-soc@vger.kernel.org
> ---
>  arch/arm/mach-exynos/dev-audio.c                   |    2 +-
>  arch/arm/mach-exynos/dev-ohci.c                    |    2 +-
>  arch/arm/mach-exynos/mach-nuri.c                   |    6 +++---
>  arch/arm/mach-exynos/mach-origen.c                 |    6 +++---
>  arch/arm/mach-exynos/mach-smdk4x12.c               |    2 +-
>  arch/arm/mach-exynos/mach-smdkv310.c               |    6 +++---
>  arch/arm/mach-exynos/mach-universal_c210.c         |    4 ++--
>  arch/arm/mach-exynos/setup-i2c0.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c1.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c2.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c3.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c4.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c5.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c6.c                  |    2 +-
>  arch/arm/mach-exynos/setup-i2c7.c                  |    2 +-
>  arch/arm/mach-s3c24xx/common-smdk.c                |    4 ++--
>  arch/arm/mach-s3c24xx/mach-amlm5900.c              |    2 +-
>  arch/arm/mach-s3c24xx/mach-anubis.c                |    6 +++---
>  arch/arm/mach-s3c24xx/mach-at2440evb.c             |    6 +++---
>  arch/arm/mach-s3c24xx/mach-bast.c                  |    8 ++++----
>  arch/arm/mach-s3c24xx/mach-gta02.c                 |   10 +++++-----
>  arch/arm/mach-s3c24xx/mach-h1940.c                 |    8 ++++----
>  arch/arm/mach-s3c24xx/mach-jive.c                  |    6 +++---
>  arch/arm/mach-s3c24xx/mach-mini2440.c              |   10 +++++-----
>  arch/arm/mach-s3c24xx/mach-n30.c                   |    8 ++++----
>  arch/arm/mach-s3c24xx/mach-nexcoder.c              |    2 +-
>  arch/arm/mach-s3c24xx/mach-osiris.c                |    4 ++--
>  arch/arm/mach-s3c24xx/mach-otom.c                  |    2 +-
>  arch/arm/mach-s3c24xx/mach-qt2410.c                |    8 ++++----
>  arch/arm/mach-s3c24xx/mach-rx1950.c                |   10 +++++-----
>  arch/arm/mach-s3c24xx/mach-rx3715.c                |    2 +-
>  arch/arm/mach-s3c24xx/mach-smdk2410.c              |    2 +-
>  arch/arm/mach-s3c24xx/mach-smdk2413.c              |    4 ++--
>  arch/arm/mach-s3c24xx/mach-smdk2416.c              |    8 ++++----
>  arch/arm/mach-s3c24xx/mach-smdk2440.c              |    2 +-
>  arch/arm/mach-s3c24xx/mach-smdk2443.c              |    2 +-
>  arch/arm/mach-s3c24xx/mach-tct_hammer.c            |    2 +-
>  arch/arm/mach-s3c24xx/mach-vr1000.c                |    6 +++---
>  arch/arm/mach-s3c24xx/mach-vstms.c                 |    4 ++--
>  arch/arm/mach-s3c24xx/setup-i2c.c                  |    2 +-
>  arch/arm/mach-s3c24xx/simtec-audio.c               |    2 +-
>  arch/arm/mach-s3c24xx/simtec-usb.c                 |    2 +-
>  arch/arm/mach-s3c64xx/dev-audio.c                  |    2 +-
>  arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
>  arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
>  arch/arm/mach-s3c64xx/mach-crag6410.c              |    4 ++--
>  arch/arm/mach-s3c64xx/mach-hmt.c                   |    4 ++--
>  arch/arm/mach-s3c64xx/mach-mini6410.c              |    4 ++--
>  arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
>  arch/arm/mach-s3c64xx/mach-real6410.c              |    4 ++--
>  arch/arm/mach-s3c64xx/mach-smartq.c                |    8 ++++----
>  arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 +-
>  arch/arm/mach-s3c64xx/mach-smdk6410.c              |    6 +++---
>  arch/arm/mach-s3c64xx/setup-i2c0.c                 |    2 +-
>  arch/arm/mach-s3c64xx/setup-i2c1.c                 |    2 +-
>  arch/arm/mach-s3c64xx/setup-ide.c                  |    2 +-
>  arch/arm/mach-s5p64x0/dev-audio.c                  |    2 +-
>  arch/arm/mach-s5p64x0/mach-smdk6440.c              |    4 ++--
>  arch/arm/mach-s5p64x0/mach-smdk6450.c              |    4 ++--
>  arch/arm/mach-s5p64x0/setup-i2c0.c                 |    2 +-
>  arch/arm/mach-s5p64x0/setup-i2c1.c                 |    2 +-
>  arch/arm/mach-s5pc100/dev-audio.c                  |    2 +-
>  arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 ++++----
>  arch/arm/mach-s5pc100/setup-i2c0.c                 |    2 +-
>  arch/arm/mach-s5pc100/setup-i2c1.c                 |    2 +-
>  arch/arm/mach-s5pv210/dev-audio.c                  |    2 +-
>  arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
>  arch/arm/mach-s5pv210/mach-smdkc110.c              |    4 ++--
>  arch/arm/mach-s5pv210/mach-smdkv210.c              |    6 +++---
>  arch/arm/mach-s5pv210/mach-torbreck.c              |    2 +-
>  arch/arm/mach-s5pv210/setup-i2c0.c                 |    2 +-
>  arch/arm/mach-s5pv210/setup-i2c1.c                 |    2 +-
>  arch/arm/mach-s5pv210/setup-i2c2.c                 |    2 +-
>  arch/arm/plat-samsung/devs.c                       |   20
++++++++++----------
>  drivers/ata/pata_samsung_cf.c                      |    2 +-
>  drivers/hwmon/s3c-hwmon.c                          |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c                   |    2 +-
>  drivers/input/touchscreen/s3c2410_ts.c             |    2 +-
>  drivers/leds/leds-s3c24xx.c                        |    2 +-
>  drivers/media/video/s5p-fimc/mipi-csis.c           |    2 +-
>  drivers/mmc/host/s3cmci.c                          |    2 +-
>  drivers/mtd/nand/s3c2410.c                         |    2 +-
>  drivers/spi/spi-s3c64xx.c                          |    2 +-
>  drivers/usb/gadget/s3c2410_udc.c                   |    2 +-
>  drivers/usb/host/ehci-s5p.c                        |    2 +-
>  drivers/usb/host/ohci-exynos.c                     |    2 +-
>  drivers/usb/host/ohci-s3c2410.c                    |    2 +-
>  .../linux/platform_data/asoc-s3c.h                 |    0
>  .../linux/platform_data/asoc-s3c24xx_simtec.h      |    0
>  .../linux/platform_data/ata-samsung_cf.h           |    0
>  .../linux/platform_data/hwmon-s3c.h                |    0
>  .../linux/platform_data/i2c-s3c2410.h              |    0
>  .../linux/platform_data/leds-s3c24xx.h             |    0
>  .../linux/platform_data/mipi-csis.h                |    0
>  .../linux/platform_data/mmc-s3cmci.h               |    0
>  .../linux/platform_data/mtd-nand-s3c2410.h         |    0
>  .../linux/platform_data/spi-s3c64xx.h              |    0
>  .../linux/platform_data/touchscreen-s3c2410.h      |    0
>  .../linux/platform_data/usb-ehci-s5p.h             |    0
>  .../linux/platform_data/usb-exynos.h               |    0
>  .../linux/platform_data/usb-ohci-s3c2410.h         |    0
>  .../linux/platform_data/usb-s3c2410_udc.h          |    0
>  sound/soc/samsung/ac97.c                           |    2 +-
>  sound/soc/samsung/i2s.c                            |    2 +-
>  sound/soc/samsung/pcm.c                            |    2 +-
>  sound/soc/samsung/s3c24xx_simtec.c                 |    2 +-
>  sound/soc/samsung/spdif.c                          |    2 +-
>  107 files changed, 164 insertions(+), 164 deletions(-)
>  rename arch/arm/plat-samsung/include/plat/audio.h =>
> include/linux/platform_data/asoc-s3c.h (100%)

I'd prefer asoc-samsung.h and...

>  rename arch/arm/plat-samsung/include/plat/audio-simtec.h =>
> include/linux/platform_data/asoc-s3c24xx_simtec.h (100%)

This will be merged into above header.


arch/arm/plat-samsung/include/plat/audio-simtec.h  |   34 ----------------
 .../linux/platform_data/asoc-samsung.h             |   42
++++++++++++++++---
 2 files changed, 35 insertions(+), 41 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/include/plat/audio-simtec.h
 rename arch/arm/plat-samsung/include/plat/audio.h =>
include/linux/platform_data/asoc-samsung.h (63%)

diff --git a/arch/arm/plat-samsung/include/plat/audio-simtec.h
b/arch/arm/plat-samsung/include/plat/audio-simtec.h
deleted file mode 100644
index 376af52..0000000
--- a/arch/arm/plat-samsung/include/plat/audio-simtec.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* arch/arm/plat-samsung/include/plat/audio-simtec.h
- *
- * Copyright 2008 Simtec Electronics
- *	http://armlinux.simtec.co.uk/
- *	Ben Dooks <ben@simtec.co.uk>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Simtec Audio support.
-*/
-
-/**
- * struct s3c24xx_audio_simtec_pdata - platform data for simtec audio
- * @use_mpllin: Select codec clock from MPLLin
- * @output_cdclk: Need to output CDCLK to the codec
- * @have_mic: Set if we have a MIC socket
- * @have_lout: Set if we have a LineOut socket
- * @amp_gpio: GPIO pin to enable the AMP
- * @amp_gain: Option GPIO to control AMP gain
- */
-struct s3c24xx_audio_simtec_pdata {
-	unsigned int	use_mpllin:1;
-	unsigned int	output_cdclk:1;
-
-	unsigned int	have_mic:1;
-	unsigned int	have_lout:1;
-
-	int		amp_gpio;
-	int		amp_gain[2];
-
-	void	(*startup)(void);
-};
diff --git a/arch/arm/plat-samsung/include/plat/audio.h
b/include/linux/platform_data/asoc-samsung.h
similarity index 63%
rename from arch/arm/plat-samsung/include/plat/audio.h
rename to include/linux/platform_data/asoc-samsung.h
index aa9875f..6b1d947 100644
--- a/arch/arm/plat-samsung/include/plat/audio.h
+++ b/include/linux/platform_data/asoc-samsung.h
@@ -1,5 +1,4 @@
-/* arch/arm/plat-samsung/include/plat/audio.h
- *
+/*
  * Copyright (c) 2009 Samsung Electronics Co. Ltd
  * Author: Jaswinder Singh <jassi.brar@samsung.com>
  *
@@ -8,12 +7,13 @@
  * published by the Free Software Foundation.
  */
 
-/* The machine init code calls s3c*_ac97_setup_gpio with
+/*
+ * The machine init code calls s3c*_ac97_setup_gpio with
  * one of these defines in order to select appropriate bank
  * of GPIO for AC97 pins
  */
-#define S3C64XX_AC97_GPD  0
-#define S3C64XX_AC97_GPE  1
+#define S3C64XX_AC97_GPD	0
+#define S3C64XX_AC97_GPE	1
 extern void s3c64xx_ac97_setup_gpio(int);
 
 /*
@@ -21,8 +21,8 @@ extern void s3c64xx_ac97_setup_gpio(int);
  * one of these defines in order to select appropriate bank
  * of GPIO for S/PDIF pins
  */
-#define S5PC100_SPDIF_GPD  0
-#define S5PC100_SPDIF_GPG3 1
+#define S5PC100_SPDIF_GPD	0
+#define S5PC100_SPDIF_GPG3	1
 extern void s5pc100_spdif_setup_gpio(int);
 
 struct samsung_i2s {
@@ -57,3 +57,31 @@ struct s3c_audio_pdata {
 		struct samsung_i2s i2s;
 	} type;
 };
+
+/**
+ * Simtec Audio support
+ 
+ * Copyright 2008 Simtec Electronics
+ *	http://armlinux.simtec.co.uk/
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * struct s3c24xx_audio_simtec_pdata - platform data for simtec audio
+ * @use_mpllin: Select codec clock from MPLLin
+ * @output_cdclk: Need to output CDCLK to the codec
+ * @have_mic: Set if we have a MIC socket
+ * @have_lout: Set if we have a LineOut socket
+ * @amp_gpio: GPIO pin to enable the AMP
+ * @amp_gain: Option GPIO to control AMP gain
+ */
+struct s3c24xx_audio_simtec_pdata {
+	unsigned int	use_mpllin:1;
+	unsigned int	output_cdclk:1;
+
+	unsigned int	have_mic:1;
+	unsigned int	have_lout:1;
+
+	int		amp_gpio;
+	int		amp_gain[2];
+
+	void	(*startup)(void);
+};
--

And I think, need to check what header name is better like following?...But
if any policy on the naming, I'm OK :-)

>  rename arch/arm/plat-samsung/include/plat/ata.h =>
> include/linux/platform_data/ata-samsung_cf.h (100%)

ata-samsung.h?

>  rename arch/arm/plat-samsung/include/plat/hwmon.h =>
> include/linux/platform_data/hwmon-s3c.h (100%)

s3c-hwmon.h? 

>  rename arch/arm/plat-samsung/include/plat/iic.h =>
> include/linux/platform_data/i2c-s3c2410.h (100%)
>  rename arch/arm/mach-s3c24xx/include/mach/leds-gpio.h =>
> include/linux/platform_data/leds-s3c24xx.h (100%)
>  rename arch/arm/plat-samsung/include/plat/mipi_csis.h =>
> include/linux/platform_data/mipi-csis.h (100%)
>  rename arch/arm/plat-samsung/include/plat/mci.h =>
> include/linux/platform_data/mmc-s3cmci.h (100%)
>  rename arch/arm/plat-samsung/include/plat/nand.h =>
> include/linux/platform_data/mtd-nand-s3c2410.h (100%)
>  rename arch/arm/plat-samsung/include/plat/s3c64xx-spi.h =>
> include/linux/platform_data/spi-s3c64xx.h (100%)
>  rename arch/arm/plat-samsung/include/plat/ts.h =>
> include/linux/platform_data/touchscreen-s3c2410.h (100%)

s3c2410-ts.h?

>  rename arch/arm/plat-samsung/include/plat/ehci.h =>
> include/linux/platform_data/usb-ehci-s5p.h (100%)
>  rename arch/arm/mach-exynos/include/mach/ohci.h =>
> include/linux/platform_data/usb-exynos.h (100%)

usb-ohci-exynos.h?

>  rename arch/arm/plat-samsung/include/plat/usb-control.h =>
> include/linux/platform_data/usb-ohci-s3c2410.h (100%)
>  rename arch/arm/plat-samsung/include/plat/udc.h =>
> include/linux/platform_data/usb-s3c2410_udc.h (100%)
> 

And just note that conflicts will be happened when merge this into Samsung
tree.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

