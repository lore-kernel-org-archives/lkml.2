Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab2EXQR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:17:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47161 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab2EXQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:17:27 -0400
Date: Thu, 24 May 2012 18:17:20 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v3] leds: Add MAX6956 driver
Message-ID: <20120524161720.GT3710@pengutronix.de>
References: <1337593269-2497-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <CACRpkdYJyUE-gM+wnOQvqW4Txuf65kEJsUbdJcBhkzRZYCxYDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYJyUE-gM+wnOQvqW4Txuf65kEJsUbdJcBhkzRZYCxYDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:30:28PM +0200, Linus Walleij wrote:
> On Mon, May 21, 2012 at 9:33 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> 
> > +config LEDS_MAX6956
> > +       tristate "LED support for MAX6956 LED Display Driver and I/O Expander"
> > +       depends on LEDS_CLASS
> > +       depends on GPIOLIB
> 
> Shouldn't this be select GPIOLIB?
> 
> You seem to require it when using this driver.
> 
> Better than hiding it if not selecting GPIOLIB somewhere else?
I don't care much, but:

$ git ls-files | grep Kconfig | xargs grep '\<GPIOLIB\>' | grep -c select
7
$ git ls-files | grep Kconfig | xargs grep '\<GPIOLIB\>' | grep -c depends
39

Is it save to select GPIOLIB on a machine that provides its own
gpio-API?

> > +struct max6956_ddata {
> > +       struct device *dev;
> > +
> > +       struct mutex lock;
> > +
> > +       struct regmap *regmap;
> > +
> > +       struct gpio_chip gpio_chip;
> > +
> > +       struct max6956_pdata pdata;
> > +
> > +       struct max6956_led_ddata leds[32];
> > +
> > +       const char *gpio_names[32];
> > +};
> 
> You can never have enough whitespace? ;-)
> 
> Anyway, so this thing has a gpio_chip and leds.
> 
> The archaic way is to create mfd/max-6956.c and have this
> MFD device spawn two cells, one for GPIO landing in
> driver/gpio/gpio-max6956.c and one for LED landing in
> leds/leds-max6956.c, then mediate register read/writes and
> regmap in the MFD driver.
> 
> The MFD driver decide using platform data whether each
> line should be used for a LED or GPIO.
> 
> Is there some problem with this design pattern?
I thought about that, too, but I think it's overkill to create an mfd
driver. The mfd driver would have essentially the same functions as the
driver I posted. Then add all the oneline wrappers for these added in
drivers/gpio/ and drivers/leds/. I'd expect the SLOC to double even if I
remove all the whitespace above. Moreover it increases complexity for a
driver that is quite simple otherwise.

There are two other drivers that handle gpios below drivers/leds
(leds-pca9532 and leds-tca6507). Are these bad examples? The chip can
only do leds and gpio so the argument won't change in the future.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
