Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LGHO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:14:57 -0500
Received: from smtp.nokia.com ([147.243.128.24]:38227 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1LGHO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:14:56 -0500
From: <kalle.jokiniemi@nokia.com>
To: <felipe.contreras@nokia.com>, <linux-kernel@vger.kernel.org>
CC: <heikki.krogerus@nokia.com>, <cbouatmailru@gmail.com>, <tony@atomide.com>,
        <felipe.contreras@gmail.com>
Subject: RE: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Thread-Topic: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Thread-Index: AQHMs3K6p8szTVFcUk6vwcKmskkM7pXP94Fg
Date: Wed, 7 Dec 2011 07:14:45 +0000
Message-ID: <17A5987AD917BF4DB82CC60AED33D5E107096E44@008-AM1MPN1-021.mgdnok.nokia.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
In-Reply-To: <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-headerinfofordlp: None
x-titus-version: 3.3.8.1
x-tituslabs-classifications-30: TLPropertyRoot=Nokia;Confidentiality=Company
 Confidential;Project=None;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IjpYutPtrUQ5frt4OB8CssV448XPEb9pGoTyOOuIrxISzWgR4/SsOA3qutDDp8OGYS6aU2ua/5APreC2U7sYcx5lhA6wJcm7pxdVvoi6Nf/B8ETPcIU06SyW29Is27Xv+gKvboRhyv6Bokel/ceunzLv1rR9MvC+tsuh/HenBDgzPjwCNDq+ey1hBq6atwwIf0i/5/Za/qyzYF/chEteKbrRO0aRM+PNtFv63clxdjM5OPsNKa418oZgr+PSAFU65Q==
x-originating-ip: [172.22.212.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Dec 2011 07:14:47.0206 (UTC) FILETIME=[E6D77C60:01CCB4AF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Contreras Felipe (Nokia-SD/Helsinki)
> Sent: 5. joulukuuta 2011 19:24
> To: linux-main
> Cc: Jokiniemi Kalle (Nokia-MP/Tampere); Heikki Krogerus; Anton Vorontsov;
> Tony Lindgren; Felipe Contreras
> Subject: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
> 
> From: Felipe Contreras <felipe.contreras@gmail.com>
> 
> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
> 
> This seems to break USB networking stuff.

Reverting this patch will cause 14,7mA leak from the ISP1704 USB transceiver. I did test at the time that USB networking was ok on MeeGo 1.1 based (MeeGo community edition N900) release and this patch. Though can't help debugging this now, sorry. 

If you guys are not concerned with use time, no problem with this patch.

- Kalle

> 
> Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
> Cc: Heikki Krogerus <heikki.krogerus@nokia.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
>  1 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-
> omap2/board-rx51-peripherals.c
> index ba1aa07..9f8e4d2 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -23,7 +23,6 @@
>  #include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
>  #include <linux/mmc/host.h>
> -#include <linux/power/isp1704_charger.h>
> 
>  #include <plat/mcspi.h>
>  #include <plat/board.h>
> @@ -56,8 +55,6 @@
>  #define RX51_FMTX_IRQ			53
>  #define RX51_LP5523_CHIP_EN_GPIO	41
> 
> -#define RX51_USB_TRANSCEIVER_RST_GPIO	67
> -
>  /* list all spi devices here */
>  enum {
>  	RX51_SPI_WL1251,
> @@ -174,30 +171,10 @@ static struct spi_board_info
> rx51_peripherals_spi_board_info[] __initdata = {
>  	},
>  };
> 
> -static void rx51_charger_set_power(bool on)
> -{
> -	gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
> -}
> -
> -static struct isp1704_charger_data rx51_charger_data = {
> -	.set_power	= rx51_charger_set_power,
> -};
> -
>  static struct platform_device rx51_charger_device = {
> -	.name	= "isp1704_charger",
> -	.dev	= {
> -		.platform_data = &rx51_charger_data,
> -	},
> +	.name = "isp1704_charger",
>  };
> 
> -static void __init rx51_charger_init(void)
> -{
> -	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> -		GPIOF_OUT_INIT_LOW, "isp1704_reset"));
> -
> -	platform_device_register(&rx51_charger_device);
> -}
> -
>  #if defined(CONFIG_KEYBOARD_GPIO) ||
> defined(CONFIG_KEYBOARD_GPIO_MODULE)
> 
>  #define RX51_GPIO_CAMERA_LENS_COVER	110
> @@ -1102,6 +1079,6 @@ void __init rx51_peripherals_init(void)
>  	if (partition)
>  		omap2_hsmmc_init(mmc);
> 
> -	rx51_charger_init();
> +	platform_device_register(&rx51_charger_device);
>  }
> 
> --
> 1.7.8.rc3.17.gf56ef1

