Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1AQQrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:47:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48882 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1AQQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UzfK5++Nip3wbFVDJFFsdzIv0RuHvfGulg1oVeT44WZ2FDjqn4LerOE+dmVMuIIc+1
         ShHsiGG4yJSgjrjD/9ItxGN58hM4uTGzRFsudWkPsAY4vDI0KBOxUjpEs7/rUnpLo0mx
         4y4j7u9a5yZ/YFwzitVs2Bi/i2cCgrf5HpYrI=
Subject: Re: [PATCHv2 1/2] OMAP3: Devkit8000: Change lcd power pin
From: Daniel Morsing <daniel.morsing@gmail.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>
In-Reply-To: <1295273519-6189-2-git-send-email-weber@corscience.de>
References: <1295273519-6189-1-git-send-email-weber@corscience.de>
	 <1295273519-6189-2-git-send-email-weber@corscience.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 17:47:55 +0100
Message-ID: <1295282875.2167.7.camel@morsing>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 15:11 +0100, Thomas Weber wrote:
> The reset_gpio pin for lcd is connected with TWL4030 LedA.
> TWL4030 GPIO.1 has a not connected resistor.
> 
> Fix indention issue. The comment line uses 8 whitespaces. 
> Replaced with one tabulator.
> 
> Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 451e7ff..719f4e5 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -114,9 +114,6 @@ static struct omap2_hsmmc_info mmc[] = {
>  
>  static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
>  {
> -	twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
> -	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
> -
>  	if (gpio_is_valid(dssdev->reset_gpio))
>  		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
>  	return 0;
> @@ -245,8 +242,8 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>  	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
>  	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
>  
> -        /* gpio + 1 is "LCD_PWREN" (out, active high) */
> -	devkit8000_lcd_device.reset_gpio = gpio + 1;
> +	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
> +	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
>  	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
>  	/* Disable until needed */
>  	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);

Hey Thomas.

Only real issue I can see is that fact that the commit message doesn't
mention the removal of the low level twl4030 calls. They are essentially
non-functional in their current state and mentioning that and why they
were removed would help in any future code archaeology.

Regards,
Daniel



