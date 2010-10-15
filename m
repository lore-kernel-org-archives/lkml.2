Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0JOMfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:35:20 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:52597 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755270Ab0JOMfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:35:17 -0400
Date: Fri, 15 Oct 2010 14:32:59 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Sergio Tanzilli <tanzilli@acmesystems.it>
Cc: linux@arm.linux.org.uk, linux@maxim.org.za, nicolas.ferre@atmel.com,
        costa.antonior@gmail.com, eschwab@online.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Acme Systems FOX Board G20 board files
Message-ID: <20101015123259.GH11127@game.jcrosoft.org>
References: <1287014786-25543-1-git-send-email-tanzilli@acmesystems.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287014786-25543-1-git-send-email-tanzilli@acmesystems.it>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5369135181744614145
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -0,0 +1,279 @@
> +/*
> + *  Copyright (C) 2005 SAN People
> + *  Copyright (C) 2008 Atmel
> + *  Copyright (C) 2010 Lee McLoughlin - lee@lmmrtech.com
> + *  Copyright (C) 2010 Sergio Tanzilli - tanzilli@acmesystems.it
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/spi/at73c213.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/clk.h>
> +#include <linux/w1-gpio.h>
> +
> +#include <mach/hardware.h>
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/irq.h>
> +
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/mach/irq.h>
> +
> +#include <mach/board.h>
> +#include <mach/gpio.h>
please replace by linux/gpio.h
> +#include <mach/at91sam9_smc.h>
> +
> +#include "sam9_smc.h"
> +#include "generic.h"
> +
> +/*
> + * The FOX Board G20 hardware comes as the "Netus G20" board with
> + * just the cpu, ram, dataflash and two header connectors.
> + * This is plugged into the FOX Board which provides the ethernet,
> + * usb, rtc, leds, switch, ...
> + *
> + * For more info visit: http://www.acmesystems.it/foxg20
> + */
> +
> +
> +	.is_rmii	= 1,
> +};
please not 4 blank line
> +
> +
> +
> +
> +/*
> + * MCI (SD/MMC)
> + * det_pin, wp_pin and vcc_pin are not connected
> + */
> +static struct at91_mmc_data __initdata foxg20_mmc_data = {
> +	.slot_b		= 1,
> +	.wire4		= 1,
> +};
> +
> +
> +/*
> + * LEDs
> + */
> +static struct gpio_led foxg20_leds[] = {
> +	{	/* user led, red */
> +		.name			= "user_led",
> +		.gpio			= AT91_PIN_PC7,
> +		.active_low		= 0,
> +		.default_trigger	= "heartbeat",
> +	},
> +};
> +
> +

please also fix some white spaces

use checkpatch.pl


Best Regards,
J.
