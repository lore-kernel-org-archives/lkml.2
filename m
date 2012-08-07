Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2HGLBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:01:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42920 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2HGLBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:01:03 -0400
Message-ID: <5020F568.5020204@linaro.org>
Date: Tue, 07 Aug 2012 16:30:56 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, patches@linaro.org
Subject: Re: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org> <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
In-Reply-To: <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 04:03 PM, Kukjin Kim wrote:
> Tushar Behera wrote:
>>
>> Commit 2663e766c56a "ARM Samsung: Move s3c pwm driver to pwm framework"
>> moved Samsung PWM driver to drivers/pwm and the config option to select
>> this driver has changed.
>>
>> This patch fixes following build-error with s3c2410_defconfig.
>> arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to
>> `pwm_config'
>>
> 
> Yes, need to fix...
> 
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_lcd_power':
> arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to `pwm_config'
> arch/arm/mach-s3c24xx/mach-rx1950.c:431: undefined reference to
> `pwm_disable'
> arch/arm/mach-s3c24xx/mach-rx1950.c:437: undefined reference to `pwm_config'
> arch/arm/mach-s3c24xx/mach-rx1950.c:438: undefined reference to `pwm_enable'
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_exit':
> arch/arm/mach-s3c24xx/mach-rx1950.c:504: undefined reference to `pwm_free'
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_init':
> arch/arm/mach-s3c24xx/mach-rx1950.c:487: undefined reference to
> `pwm_request'
> 

Yes, the patch fixes all of these errors, didn't include them in the
patch comments though as they were all similar.


>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  arch/arm/mach-s3c24xx/Kconfig |    4 ++--
>>  arch/arm/plat-samsung/Kconfig |    3 ++-
>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
>> index e249611..d56b0f7 100644
>> --- a/arch/arm/mach-s3c24xx/Kconfig
>> +++ b/arch/arm/mach-s3c24xx/Kconfig
>> @@ -483,7 +483,7 @@ config MACH_NEO1973_GTA02
>>  	select I2C
>>  	select POWER_SUPPLY
>>  	select MACH_NEO1973
>> -	select S3C2410_PWM
>> +	select S3C24XX_PWM

The above needs to be picked up as S3C2410_PWM is no longer defined.

>>  	select S3C_DEV_USB_HOST
>>  	help
>>  	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM
>> Phone
>> @@ -493,7 +493,7 @@ config MACH_RX1950
>>  	select S3C24XX_DCLK
>>  	select PM_H1940 if PM
>>  	select I2C
>> -	select S3C2410_PWM
>> +	select S3C24XX_PWM

Same as above.

>>  	select S3C_DEV_NAND
>>  	select S3C2410_IOTIMING if S3C2440_CPUFREQ
>>  	select S3C2440_XTAL_16934400
>> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
>> index 7aca31c..9c3b90c 100644
>> --- a/arch/arm/plat-samsung/Kconfig
>> +++ b/arch/arm/plat-samsung/Kconfig
>> @@ -403,7 +403,8 @@ config S5P_DEV_USB_EHCI
>>
>>  config S3C24XX_PWM
>>  	bool "PWM device support"
>> -	select HAVE_PWM
>> +	select PWM
>> +	select PWM_SAMSUNG
>>  	help
>>  	  Support for exporting the PWM timer blocks via the pwm device
>>  	  system
>> --
>> 1.7.4.1
> 
> I think, following would be better? Or ...
> 

No issues. You can pick whichever you find better.

> ---
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 7aca31c..dcdfb77 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -403,7 +403,7 @@ config S5P_DEV_USB_EHCI
>  
>  config S3C24XX_PWM
>  	bool "PWM device support"
> -	select HAVE_PWM
> +	select PWM
>  	help
>  	  Support for exporting the PWM timer blocks via the pwm device
>  	  system
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 8fc3808..34c8ec1 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -59,7 +59,7 @@ config PWM_PXA
>  
>  config PWM_SAMSUNG
>  	tristate "Samsung pwm support"
> -	depends on PLAT_SAMSUNG
> +	def_bool PLAT_SAMSUNG
>  	help
>  	  Generic PWM framework driver for Samsung.
> ---
> 
> 
> 
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 


-- 
Tushar Behera
