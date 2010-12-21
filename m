Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0LUJR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:17:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0LUJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:17:27 -0500
Message-ID: <4D10705D.1060904@corscience.de>
Date: Tue, 21 Dec 2010 10:16:13 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101104 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Daniel Morsing <daniel.morsing@gmail.com>
CC: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP2: Devkit8000: Use _cansleep GPIO functions for display
 reset lines
References: <AANLkTi=XEvW3iYLdaR_w+Mi_+Rpan+6QDC2qq8DnG_WH@mail.gmail.com>
In-Reply-To: <AANLkTi=XEvW3iYLdaR_w+Mi_+Rpan+6QDC2qq8DnG_WH@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:g1TqThkoj5IYEgiO6XJc/Vm2ywLcHpGaMO7Sv1jtgXy
 gMTx10suUksF5mo7nCfM1CfVjE+AJjjL2tfQHTRCRPFdsk9pEq
 r6s6Jpq5k7dMxC6lYJi1TEkW3vyY746YAhGJjHs9VC0GDiqaT5
 QGWYSJFMGl6V9rSmDDAju0kUjnpuM5wjyboeRgfMZ7yLtwIDWF
 uPMAxIP8I2sW1FO82r5Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.12.2010 08:47, schrieb Daniel Morsing:
> The display reset lines are connected to a TPS65930 which may sleep
> when changing GPIO values. Use the appropriate function to silence
> a nasty warning from gpiolib.
>
> Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c
> b/arch/arm/mach-omap2/board-devkit8000.c
> index 53ac762..f1f58f5 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -118,27 +118,27 @@ static int devkit8000_panel_enable_lcd(struct
> omap_dss_device *dssdev)
>  	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
>
>  	if (gpio_is_valid(dssdev->reset_gpio))
> -		gpio_set_value(dssdev->reset_gpio, 1);
> +		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
>  	return 0;
>  }
>
>  static void devkit8000_panel_disable_lcd(struct omap_dss_device *dssdev)
>  {
>  	if (gpio_is_valid(dssdev->reset_gpio))
> -		gpio_set_value(dssdev->reset_gpio, 0);
> +		gpio_set_value_cansleep(dssdev->reset_gpio, 0);
>  }
>
>  static int devkit8000_panel_enable_dvi(struct omap_dss_device *dssdev)
>  {
>  	if (gpio_is_valid(dssdev->reset_gpio))
> -		gpio_set_value(dssdev->reset_gpio, 1);
> +		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
>  	return 0;
>  }
>
>  static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
>  {
>  	if (gpio_is_valid(dssdev->reset_gpio))
> -		gpio_set_value(dssdev->reset_gpio, 0);
> +		gpio_set_value_cansleep(dssdev->reset_gpio, 0);
>  }
>
>  static struct regulator_consumer_supply devkit8000_vmmc1_supply =
Hello Daniel,

Your patch is destroyed by gmail.
Please read Documentation/email-clients.txt

I have the same patch on my list.

So you can add an

Acked-by: Thomas Weber <weber@corscience.de>


Regards,
Thomas

