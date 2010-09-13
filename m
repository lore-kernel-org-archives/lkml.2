Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0IMK4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:56:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0IMK4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Wnl++sbZDWZ4HYi/OWDOO2nnDwSUBJcT9w/xzylctGIVlLk2xTlwhQqIzGbFQIbN+B
         hwoA1bG/ojnWo38tw1PYOQP2DPu0anGa98Vkm1rZ0cWD3MNdH7ovGAcKEANwEJjUyIhq
         Lp++fZBBB6lGAsdU3DW8ChjgzC+f2Sofqwu1Q=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] AT91: Add flexibity board support
Date: Mon, 13 Sep 2010 12:56:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: Maxim Osipov <maxim.osipov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <4C8DFA84.4040501@gmail.com>
In-Reply-To: <4C8DFA84.4040501@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009131256.36523.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 13. září 2010 12:18:44 Maxim Osipov napsal(a):
> Hello,
> 
> This patch adds support for AT91 Flexibity board.
> 
> Kind regards,
> Maxim
> 
> From ccb19f0d6dbda5356e64c1ce5d0fe1396c548f1a Mon Sep 17 00:00:00 2001
> From: Maxim Osipov <maxim.osipov@gmail.com>
> Date: Sun, 12 Sep 2010 16:23:48 +0400
> Subject: [PATCH v2] AT91: Add flexibity board support
> 
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---
>  arch/arm/mach-at91/Kconfig           |    6 ++
>  arch/arm/mach-at91/Makefile          |    1 +
>  arch/arm/mach-at91/board-flexibity.c |  166
> ++++++++++++++++++++++++++++++++++ 3 files changed, 173 insertions(+), 0
> deletions(-)
>  create mode 100644 arch/arm/mach-at91/board-flexibity.c
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 939bccd..ca33862 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -248,6 +248,12 @@ config MACH_CPU9260
>  	  Select this if you are using a Eukrea Electromatique's
>  	  CPU9260 Board <http://www.eukrea.com/>
> 
> +config MACH_FLEXIBITY
> +	bool "Flexibity Connect board"
> +	help
> +	  Select this if you are using Flexibity Connect board
> +	  <http://www.flexibity.com>
> +
>  endif
> 
>  # ----------------------------------------------------------
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index ca2ac00..7cbe06d 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_MACH_USB_A9260)	+= board-usb-a9260.o
>  obj-$(CONFIG_MACH_QIL_A9260)	+= board-qil-a9260.o
>  obj-$(CONFIG_MACH_AFEB9260)	+= board-afeb-9260v1.o
>  obj-$(CONFIG_MACH_CPU9260)	+= board-cpu9krea.o
> +obj-$(CONFIG_MACH_FLEXIBITY)	+= board-flexibity.o
> 
>  # AT91SAM9261 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9261EK) += board-sam9261ek.o
> diff --git a/arch/arm/mach-at91/board-flexibity.c
> b/arch/arm/mach-at91/board-flexibity.c new file mode 100644
> index 0000000..a589077
> --- /dev/null
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -0,0 +1,166 @@
> +/*
> + * linux/arch/arm/mach-at91/board-flexibity.c
> + *
> + *  Copyright (C) 2010 Flexibity
> + *  Copyright (C) 2005 SAN People
> + *  Copyright (C) 2006 Atmel
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/input.h>
> +
> +#include <asm/mach-types.h>
> +
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/mach/irq.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/board.h>
> +#include <mach/gpio.h>

#include <linux/gpio.h>

btw. don't you want to modularize this code a bit ? check how mach-pxa/z2.c or 
mach-pxa/vpac270.c is done for example.

Cheers

> +
> +#include "generic.h"
> +
> +
> +static void __init flexibity_map_io(void)
> +{
> +	/* Initialize processor: 18.432 MHz crystal */
> +	at91sam9260_initialize(18432000);
> +
> +	/* DBGU on ttyS0. (Rx & Tx only) */
> +	at91_register_uart(0, 0, 0);
> +
> +	/* set serial console to ttyS0 (ie, DBGU) */
> +	at91_set_serial_console(0);
> +}
> +
> +static void __init flexibity_init_irq(void)
> +{
> +	at91sam9260_init_interrupts(NULL);
> +}
> +
> +
> +/* USB Host port */
> +static struct at91_usbh_data __initdata flexibity_usbh_data = {
> +	.ports		= 2,
> +};
> +
> +/* USB Device port */
> +static struct at91_udc_data __initdata flexibity_udc_data = {
> +	.vbus_pin	= AT91_PIN_PC5,
> +	.pullup_pin	= 0,		/* pull-up driven by UDC */
> +};
> +
> +/* SPI devices */
> +static struct spi_board_info flexibity_spi_devices[] = {
> +	{	/* DataFlash chip */
> +		.modalias	= "mtd_dataflash",
> +		.chip_select	= 1,
> +		.max_speed_hz	= 15 * 1000 * 1000,
> +		.bus_num	= 0,
> +	},
> +};
> +
> +/* MCI (SD/MMC) */
> +static struct at91_mmc_data __initdata flexibity_mmc_data = {
> +	.slot_b		= 0,
> +	.wire4		= 1,
> +	.det_pin	= AT91_PIN_PC9,
> +	.wp_pin		= AT91_PIN_PC4,
> +};
> +
> +/* LEDs */
> +static struct gpio_led flexibity_leds[] = {
> +	{
> +		.name			= "usb1:green",
> +		.gpio			= AT91_PIN_PA12,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb1:red",
> +		.gpio			= AT91_PIN_PA13,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb2:green",
> +		.gpio			= AT91_PIN_PB26,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb2:red",
> +		.gpio			= AT91_PIN_PB27,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb3:green",
> +		.gpio			= AT91_PIN_PC8,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb3:red",
> +		.gpio			= AT91_PIN_PC6,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb4:green",
> +		.gpio			= AT91_PIN_PB4,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb4:red",
> +		.gpio			= AT91_PIN_PB5,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	}
> +};
> +
> +static void __init flexibity_board_init(void)
> +{
> +	/* Serial */
> +	at91_add_device_serial();
> +	/* USB Host */
> +	at91_add_device_usbh(&flexibity_usbh_data);
> +	/* USB Device */
> +	at91_add_device_udc(&flexibity_udc_data);
> +	/* SPI */
> +	at91_add_device_spi(flexibity_spi_devices,
> +		ARRAY_SIZE(flexibity_spi_devices));
> +	/* MMC */
> +	at91_add_device_mmc(0, &flexibity_mmc_data);
> +	/* LEDs */
> +	at91_gpio_leds(flexibity_leds, ARRAY_SIZE(flexibity_leds));
> +}
> +
> +MACHINE_START(FLEXIBITY, "Flexibity Connect")
> +	/* Maintainer: Maxim Osipov */
> +	.phys_io	= AT91_BASE_SYS,
> +	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
> +	.boot_params	= AT91_SDRAM_BASE + 0x100,
> +	.timer		= &at91sam926x_timer,
> +	.map_io		= flexibity_map_io,
> +	.init_irq	= flexibity_init_irq,
> +	.init_machine	= flexibity_board_init,
> +MACHINE_END
