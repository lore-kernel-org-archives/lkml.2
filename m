Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1LTAGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:06:06 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15791 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223Ab1LTAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:06:04 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18QOsAOKDdiciTYKtgCkmNw
Date: Mon, 19 Dec 2011 16:06:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/7] ARM: OMAP1: ams-delta: convert latches to
 basic_mmio_gpio
Message-ID: <20111220000600.GY6464@atomide.com>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl>
 <a4b2fd8d5b0f14b24cf6edbb618fa51daf8eefba.1324331816.git.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4b2fd8d5b0f14b24cf6edbb618fa51daf8eefba.1324331816.git.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 14:41]:
> Once ready, ams-delta specific device drivers currently calling custom
> ams_delta_latch[12]_write() functions can be updated to call generic
> gpio_set_value() instead, which will make them less platform dependent.
> Even more, some custom ams-delta only drivers can perhaps be dropped
> from the tree after converting selected ams-delta platform devices to
> follow generic GPIO based device models.
> 
> Depends on patch 1/7, "ARM: OMAP1: ams-delta: register latch dependent
> devices later".

Hmm looking at this maybe you can move the all the latch stuff into
a device driver?

Then you can have the other drivers register with it and let the
module dependencies take care of the init order?

You should only register the platform_device entries in your board-*.c
file, I don't think you actually need to do anything there to power
up things in the board-*.c file execept for the 8250.c driver?

> +static struct gpio latch_gpios[] __initconst = {
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_CAMERA,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_camera",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_ADVERT,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_advert",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_EMAIL,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_email",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_HANDSFREE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_handsfree",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICEMAIL,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_voicemail",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "led_voice",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 6,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "dockit1",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 7,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "dockit2",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LCD_VBLEN,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "lcd_vblen",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_LCD_NDISP,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "lcd_ndisp",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NCE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_nce",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NRE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_nre",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWP,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_nwp",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_nwe",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_ALE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_ale",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_CLE,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "nand_cle",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "keybrd_pwr",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "keybrd_dataout",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_RSTIN,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "scard_rstin",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_CMDVCC,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "scard_cmdvcc",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "modem_nreset",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "modem_codec",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 14,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "hookflash1",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 15,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "hookflash2",
> +	},
> +};
> +
> +void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
> +{
> +	int bit = 0;
> +	u16 bitpos = 1 << bit;
> +
> +	for (; bit < ngpio; bit++, bitpos = bitpos << 1) {
> +		if (!(mask & bitpos))
> +			continue;
> +		gpio_set_value(base + bit, (value & bitpos) != 0);
> +	}
> +}
> +EXPORT_SYMBOL(ams_delta_latch_write);

This part especially looks like it really should be just a regular
device driver under drivers/ somewhere. That might simplify things
quite a bit for you..

Regards,

Tony
