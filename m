Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1L1IB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:01:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46758 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1L1IBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:01:54 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-81-4efaccf11f80
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rajeshwari Shinde'" <rajeshwari.s@samsung.com>,
        "'Padmavathi Venna'" <padma.v@samsung.com>
References: <20111228100741.5a6a6f36055d2ea06c1d4014@canb.auug.org.au>
In-reply-to: <20111228100741.5a6a6f36055d2ea06c1d4014@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the s5p tree with the arm tree
Date: Wed, 28 Dec 2011 17:01:53 +0900
Message-id: <01ea01ccc536$f6584e70$e308eb50$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczE7JzdLpi4+V9uRdSSVJYoenvonAAAzeDQ
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi Stephen :)

> Today's linux-next merge of the s5p tree got a conflict in
> arch/arm/mach-s3c64xx/Makefile between commit b024043b6d0d ("ARM: 7245/1:
> S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]") from the arm tree
> and commits 8f8a8d269bb4 ("ARM: S3C64XX: Add basic cpuidle driver"),
> a60879e7ca17 ("ARM: SAMSUNG: Remove SDHCI bus clocks from platform
> data"), 875a59374cd1 ("ARM: SAMSUNG: Consolidation of SPI platform
> devices to plat-samsung") and 4566c7f7612f ("ARM: S3C64XX: Modified files
> for SPI consolidation work") from the s5p tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.
> 

Looks good to me.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-s3c64xx/Makefile
> index f37016c,2244c42..0000000
> --- a/arch/arm/mach-s3c64xx/Makefile
> +++ b/arch/arm/mach-s3c64xx/Makefile
> @@@ -19,29 -19,29 +19,29 @@@ obj-y				+= common.o
> clock.
>   obj-$(CONFIG_CPU_S3C6400)	+= s3c6400.o
>   obj-$(CONFIG_CPU_S3C6410)	+= s3c6410.o
> 
>  -obj-y				+= irq.o
>  -obj-y				+= irq-eint.o
>  +# PM
>  +
>  +obj-$(CONFIG_PM)		+= pm.o irq-pm.o sleep.o
> ++obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
> 
>   # DMA support
> 
>   obj-$(CONFIG_S3C64XX_DMA)	+= dma.o
> 
>  -# Device setup
>  +# Device support
> 
>  -obj-$(CONFIG_S3C64XX_SETUP_I2C0) += setup-i2c0.o
>  -obj-$(CONFIG_S3C64XX_SETUP_I2C1) += setup-i2c1.o
>  -obj-$(CONFIG_S3C64XX_SETUP_IDE) += setup-ide.o
>  -obj-$(CONFIG_S3C64XX_SETUP_KEYPAD) += setup-keypad.o
>  -obj-$(CONFIG_S3C64XX_SETUP_FB_24BPP) += setup-fb-24bpp.o
>  -obj-$(CONFIG_S3C64XX_SETUP_SDHCI_GPIO) += setup-sdhci-gpio.o
>  -obj-$(CONFIG_S3C64XX_SETUP_SPI) += setup-spi.o
>  +obj-y				+= dev-uart.o
>  +obj-y				+= dev-audio.o
> - obj-$(CONFIG_S3C64XX_DEV_SPI)	+= dev-spi.o
> 
>  -# PM
>  +# Device setup
> 
>  -obj-$(CONFIG_PM)		+= pm.o
>  -obj-$(CONFIG_PM)		+= sleep.o
>  -obj-$(CONFIG_PM)		+= irq-pm.o
>  -obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
>  +obj-$(CONFIG_S3C64XX_SETUP_FB_24BPP)	+= setup-fb-24bpp.o
>  +obj-$(CONFIG_S3C64XX_SETUP_I2C0)	+= setup-i2c0.o
>  +obj-$(CONFIG_S3C64XX_SETUP_I2C1)	+= setup-i2c1.o
>  +obj-$(CONFIG_S3C64XX_SETUP_IDE)		+= setup-ide.o
>  +obj-$(CONFIG_S3C64XX_SETUP_KEYPAD)	+= setup-keypad.o
> - obj-$(CONFIG_S3C64XX_SETUP_SDHCI)	+= setup-sdhci.o
>  +obj-$(CONFIG_S3C64XX_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
> ++obj-$(CONFIG_S3C64XX_SETUP_SPI)		+= setup-spi.o
> 
>   # Machine support
> 

