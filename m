Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1LERb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54666 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab1LERby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
Date: Mon, 5 Dec 2011 19:31:52 +0200
Message-ID: <CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should probably have CC'ed linux-omap.

On Mon, Dec 5, 2011 at 7:23 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
>
> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
>
> This seems to break USB networking stuff.
>
> Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
> Cc: Heikki Krogerus <heikki.krogerus@nokia.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
>  1 files changed, 2 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index ba1aa07..9f8e4d2 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -23,7 +23,6 @@
>  #include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
>  #include <linux/mmc/host.h>
> -#include <linux/power/isp1704_charger.h>
>
>  #include <plat/mcspi.h>
>  #include <plat/board.h>
> @@ -56,8 +55,6 @@
>  #define RX51_FMTX_IRQ                  53
>  #define RX51_LP5523_CHIP_EN_GPIO       41
>
> -#define RX51_USB_TRANSCEIVER_RST_GPIO  67
> -
>  /* list all spi devices here */
>  enum {
>        RX51_SPI_WL1251,
> @@ -174,30 +171,10 @@ static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
>        },
>  };
>
> -static void rx51_charger_set_power(bool on)
> -{
> -       gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
> -}
> -
> -static struct isp1704_charger_data rx51_charger_data = {
> -       .set_power      = rx51_charger_set_power,
> -};
> -
>  static struct platform_device rx51_charger_device = {
> -       .name   = "isp1704_charger",
> -       .dev    = {
> -               .platform_data = &rx51_charger_data,
> -       },
> +       .name = "isp1704_charger",
>  };
>
> -static void __init rx51_charger_init(void)
> -{
> -       WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> -               GPIOF_OUT_INIT_LOW, "isp1704_reset"));
> -
> -       platform_device_register(&rx51_charger_device);
> -}
> -
>  #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
>
>  #define RX51_GPIO_CAMERA_LENS_COVER    110
> @@ -1102,6 +1079,6 @@ void __init rx51_peripherals_init(void)
>        if (partition)
>                omap2_hsmmc_init(mmc);
>
> -       rx51_charger_init();
> +       platform_device_register(&rx51_charger_device);
>  }

-- 
Felipe Contreras
