Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1ASJBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:01:07 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55232 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab1ASJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:01:05 -0500
Date: Wed, 19 Jan 2011 14:30:12 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com
Subject: Re: [PATCHv4 3/4] OMAP3: Devkit8000: Check return value of
 gpio_request
Message-ID: <20110119090011.GD6197@m-desktop>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
 <1295425166-25540-4-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295425166-25540-4-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:19:25AM +0100, Thomas Weber wrote:
> The return value of gpio_request is ignored.
> This patch adds the check of the return value of gpio_request.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 9fb416b..4ddd81c 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -234,6 +234,8 @@ static struct gpio_led gpio_leds[];
>  static int devkit8000_twl_gpio_setup(struct device *dev,
>  		unsigned gpio, unsigned ngpio)
>  {
> +	int ret;
> +
>  	omap_mux_init_gpio(29, OMAP_PIN_INPUT);
>  	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
>  	mmc[0].gpio_cd = gpio + 0;
> @@ -244,13 +246,23 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>  
>  	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
>  	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
> -	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
> +	ret = gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
> +	if (ret < 0) {
> +		printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
> +		return ret;
> +	}
> +
>  	/* Disable until needed */
>  	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
>  
>  	/* gpio + 7 is "DVI_PD" (out, active low) */
>  	devkit8000_dvi_device.reset_gpio = gpio + 7;
> -	gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
> +	ret = gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
> +	if (ret < 0) {
> +		printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
> +		return ret;
> +	}

Nak. Why you want this change as seperate patch? Merge this with 1/4

-Manjunath
[...]

