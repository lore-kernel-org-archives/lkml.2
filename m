Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2HGKdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:33:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48905 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2HGKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:33:16 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-fe-5020eeeb5d85
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.hauer@pengutronix.de, patches@linaro.org
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
In-reply-to: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
Subject: RE: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
Date: Tue, 07 Aug 2012 19:33:15 +0900
Message-id: <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10g32T4AWU0Y5rSSmDrnk9nuMJqgAAjOnA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jQd3X7xQCDNbekbC4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MroOj2bteCzVMXOxzOZGxiXiHUxcnJICJhITP+5mw3C
	FpO4cG89kM3FISQwnVFi8oOXUM5fRonWWY3sIFVsAhoSh98/A7NFBAolXp/qYQWxmQX0JKZv
	/gtmCwl4SMyd8I4FxOYU8JR48KOTsYuRg0NYwF/iUWcBiMkioCpx4oEmSAWvgK3E2XuNbBC2
	oMSPyfdYICZqSazfeZwJwpaX2LzmLTNIq4SAusSjv7ogpoiAkcSfBkGIChGJfS/eMU5gFJqF
	ZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBwfxMagfjygaLQ4wC
	HIxKPLwTZBUChFgTy4orcw8xSnAwK4nwHt4JFOJNSaysSi3Kjy8qzUktPsQozcGiJM5r7P3V
	X0ggPbEkNTs1tSC1CCbLxMEp1cDYmsrm+yjV/LLNtBPpk4Q8DydGLgiZnF4tsPGzyhMxvqr3
	/DxLrp4VOldRw5RruPf8KY2tTzJ/M/z+u0wiJWiDRWfXuaTd756uyv668ElD5pfSWZMf7akO
	qXvwJfHnnAWGH2znuctsuM3NvMfk5+QTm2PT2WsdlnZJ3NfVfV+/6Ni2RIOfUQ9slViKMxIN
	tZiLihMBJCehFWICAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera wrote:
> 
> Commit 2663e766c56a "ARM Samsung: Move s3c pwm driver to pwm framework"
> moved Samsung PWM driver to drivers/pwm and the config option to select
> this driver has changed.
> 
> This patch fixes following build-error with s3c2410_defconfig.
> arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to
> `pwm_config'
> 

Yes, need to fix...

arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_lcd_power':
arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to `pwm_config'
arch/arm/mach-s3c24xx/mach-rx1950.c:431: undefined reference to
`pwm_disable'
arch/arm/mach-s3c24xx/mach-rx1950.c:437: undefined reference to `pwm_config'
arch/arm/mach-s3c24xx/mach-rx1950.c:438: undefined reference to `pwm_enable'
arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_exit':
arch/arm/mach-s3c24xx/mach-rx1950.c:504: undefined reference to `pwm_free'
arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_init':
arch/arm/mach-s3c24xx/mach-rx1950.c:487: undefined reference to
`pwm_request'

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  arch/arm/mach-s3c24xx/Kconfig |    4 ++--
>  arch/arm/plat-samsung/Kconfig |    3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index e249611..d56b0f7 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -483,7 +483,7 @@ config MACH_NEO1973_GTA02
>  	select I2C
>  	select POWER_SUPPLY
>  	select MACH_NEO1973
> -	select S3C2410_PWM
> +	select S3C24XX_PWM
>  	select S3C_DEV_USB_HOST
>  	help
>  	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM
> Phone
> @@ -493,7 +493,7 @@ config MACH_RX1950
>  	select S3C24XX_DCLK
>  	select PM_H1940 if PM
>  	select I2C
> -	select S3C2410_PWM
> +	select S3C24XX_PWM
>  	select S3C_DEV_NAND
>  	select S3C2410_IOTIMING if S3C2440_CPUFREQ
>  	select S3C2440_XTAL_16934400
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 7aca31c..9c3b90c 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -403,7 +403,8 @@ config S5P_DEV_USB_EHCI
> 
>  config S3C24XX_PWM
>  	bool "PWM device support"
> -	select HAVE_PWM
> +	select PWM
> +	select PWM_SAMSUNG
>  	help
>  	  Support for exporting the PWM timer blocks via the pwm device
>  	  system
> --
> 1.7.4.1

I think, following would be better? Or ...

---
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 7aca31c..dcdfb77 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -403,7 +403,7 @@ config S5P_DEV_USB_EHCI
 
 config S3C24XX_PWM
 	bool "PWM device support"
-	select HAVE_PWM
+	select PWM
 	help
 	  Support for exporting the PWM timer blocks via the pwm device
 	  system
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 8fc3808..34c8ec1 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -59,7 +59,7 @@ config PWM_PXA
 
 config PWM_SAMSUNG
 	tristate "Samsung pwm support"
-	depends on PLAT_SAMSUNG
+	def_bool PLAT_SAMSUNG
 	help
 	  Generic PWM framework driver for Samsung.
---



Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

