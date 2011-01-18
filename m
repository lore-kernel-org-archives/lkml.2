Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1ARJCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:02:49 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:38508 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab1ARJCp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:02:45 -0500
MIME-Version: 1.0
In-Reply-To: <1295333932-23935-2-git-send-email-weber@corscience.de>
References: <1295333932-23935-1-git-send-email-weber@corscience.de> <1295333932-23935-2-git-send-email-weber@corscience.de>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Tue, 18 Jan 2011 14:32:04 +0530
Message-ID: <AANLkTikK5z7LZCRMBzQ5i_W77HdKfU1iePZR6S_fsKOY@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] OMAP3: Devkit8000: Change lcd power pin
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 12:28, Thomas Weber <weber@corscience.de> wrote:
> This patch fixes a wrongly used lcd enable pin.
>
> The Devkit8000 uses twl4030_ledA configured as output gpio only for the
> lcd enable line. twl4030_gpio.1 is used through the generic gpio functions
> while ledA is used via low level twl4030 calls.
>
> Remove the low level calls and use the generic gpio functions for
> initialization and use of ledA.
>
> This also fixes a bug where the lcd would not power down when blanking.
>
> Fix indentation issue. The comment line uses 8 whitespace.
> This is replaced with one tabulator.
>
> Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 451e7ff..719f4e5 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -114,9 +114,6 @@ static struct omap2_hsmmc_info mmc[] = {
>
>  static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
>  {
> -       twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
> -       twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
> -
>        if (gpio_is_valid(dssdev->reset_gpio))
>                gpio_set_value_cansleep(dssdev->reset_gpio, 1);
>        return 0;
> @@ -245,8 +242,8 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>        /* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
>        gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
>
> -        /* gpio + 1 is "LCD_PWREN" (out, active high) */
> -       devkit8000_lcd_device.reset_gpio = gpio + 1;
> +       /* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
> +       devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
>        gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");

Consider checking the return value of gpio_request().

>        /* Disable until needed */
>        gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
> --
> 1.7.4.rc2
>
