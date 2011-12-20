Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1LTBA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:00:27 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48942 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1LTBAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:00:25 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/7] ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
Date: Tue, 20 Dec 2011 01:59:36 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl> <a4b2fd8d5b0f14b24cf6edbb618fa51daf8eefba.1324331816.git.jkrzyszt@tis.icnet.pl> <20111220000600.GY6464@atomide.com>
In-Reply-To: <20111220000600.GY6464@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112200159.36558.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of December 2011 at 01:06:00, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 14:41]:
> > Once ready, ams-delta specific device drivers currently calling custom
> > ams_delta_latch[12]_write() functions can be updated to call generic
> > gpio_set_value() instead, which will make them less platform dependent.
> > Even more, some custom ams-delta only drivers can perhaps be dropped
> > from the tree after converting selected ams-delta platform devices to
> > follow generic GPIO based device models.
> > 
> > Depends on patch 1/7, "ARM: OMAP1: ams-delta: register latch dependent
> > devices later".
> 
> Hmm looking at this maybe you can move the all the latch stuff into
> a device driver?

The latch stuff is just platform data for the existing gpio-generic aka 
basic_mmio_gpio driver. I'm not sure if creating a new custom driver by 
just squashing an existig driver code with a board specific platform 
data is a good idea.

> Then you can have the other drivers register with it and let the
> module dependencies take care of the init order?

It it was more complicated than providing just platform data, not even a 
single custom callback, to an existing gpio-generic driver, creating a 
custom driver might help indeed. However, I think I have all issues with 
initialization order already sorted out without inventing a new driver.

> You should only register the platform_device entries in your board-*.c
> file, I don't think you actually need to do anything there to power
> up things in the board-*.c file execept for the 8250.c driver?

Exactly, but not in a single patch. With this patch, I keep the old API 
for all drivers to still work, that's why I have to handle GPIO pins on 
behalf of them until updated. Those are updated step by step throghout 
the following patches of the series.

> > +static struct gpio latch_gpios[] __initconst = {
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_CAMERA,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_camera",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_ADVERT,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_advert",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_EMAIL,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_email",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_HANDSFREE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_handsfree",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICEMAIL,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_voicemail",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "led_voice",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 6,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "dockit1",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 7,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "dockit2",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LCD_VBLEN,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "lcd_vblen",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_LCD_NDISP,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "lcd_ndisp",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NCE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_nce",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NRE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_nre",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWP,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_nwp",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_nwe",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_ALE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_ale",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_NAND_CLE,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "nand_cle",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "keybrd_pwr",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "keybrd_dataout",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_RSTIN,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "scard_rstin",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_CMDVCC,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "scard_cmdvcc",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "modem_nreset",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "modem_codec",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 14,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "hookflash1",
> > +	},
> > +	{
> > +		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 15,
> > +		.flags	= GPIOF_OUT_INIT_LOW,
> > +		.label	= "hookflash2",
> > +	},
> > +};
> > +
> > +void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
> > +{
> > +	int bit = 0;
> > +	u16 bitpos = 1 << bit;
> > +
> > +	for (; bit < ngpio; bit++, bitpos = bitpos << 1) {
> > +		if (!(mask & bitpos))
> > +			continue;
> > +		gpio_set_value(base + bit, (value & bitpos) != 0);
> > +	}
> > +}
> > +EXPORT_SYMBOL(ams_delta_latch_write);
> 
> This part especially looks like it really should be just a regular
> device driver under drivers/ somewhere. 

I really don't understand what kind of a driver you might mean here.

The latch_gpios[] table is initially filled with all latch1 and latch2 
GPIO pins in order to register and initialize them from the board file 
until they are handled by respective existing device drivers (leds, 
nand, lcd, serio, serial8250, asoc) instead of those drivers accessing 
the latches with those old ams_delta_latch[12]_write() functions. That 
table will get almost empty after the transision process is completed, 
holding only pins not used by any drivers / connected to unsued devices, 
in order to initialize them from the board file for power saving 
purposes. A separate driver for the purpose of initializing a few GPIO 
pins seems an overkill.

The new ams_delta_latch_write() function is a unified replacement for 
those removed ams_delta_latch[12]_write(), and serves as a temporary 
wrapper over gpio_set_value(), providing the old API for those not yet 
updated device drivers, and will be removed after all drivers are 
converted.

Perhaps I was not clear enough with my intention of a smooth step by 
step transition to the GPIO API without breaking any signle driver with 
any single patch.

> That might simplify things quite a bit for you..

Will be simplified, step by step, while moving GPIO handling from the 
board file to all those existing device drivers.

I hope this clarifies things enough.

Thanks,
Janusz
