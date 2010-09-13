Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0IMUxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:53:12 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:34390 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399Ab0IMUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:53:11 -0400
Message-ID: <4C8E8F31.2050108@bluewatersys.com>
Date: Tue, 14 Sep 2010 08:53:05 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Maxim Osipov <maxim.osipov@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] AT91: Add flexibity board support
References: <4C8DFA84.4040501@gmail.com>
In-Reply-To: <4C8DFA84.4040501@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 10:18 PM, Maxim Osipov wrote:
> Hello,
> 
> This patch adds support for AT91 Flexibity board.

Couple more comments below,

> From ccb19f0d6dbda5356e64c1ce5d0fe1396c548f1a Mon Sep 17 00:00:00 2001
> From: Maxim Osipov <maxim.osipov@gmail.com>
> Date: Sun, 12 Sep 2010 16:23:48 +0400
> Subject: [PATCH v2] AT91: Add flexibity board support
> 
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---

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

Use linux/gpio.h

> +
> +#include "generic.h"
> +
> +

Single blank line here, and between functions.

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

Can we drop all the comments inside this function please. They don't add
any information and they make it harder to read the actual code.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
