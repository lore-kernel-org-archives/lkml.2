Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1EJHcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:32:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52547 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1EJHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:31:59 -0400
Date: Tue, 10 May 2011 09:31:52 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, kernel@pengutronix.de,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110510073152.GF29089@pengutronix.de>
References: <1302097097.22904.41.camel@rex>
 <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110509150254.e7da059f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110509150254.e7da059f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, May 09, 2011 at 03:02:54PM -0700, Andrew Morton wrote:
> On Mon, 11 Apr 2011 22:35:57 +0200
> Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> 
> > This function makes a deep copy of the platform data to allow it to live
> > in init memory.
> > The definition cannot go into leds-gpio.c because it needs to be builtin
> > to be usable by platforms.
> > 
> 
> Well...  why?  The changelog tells us what the function does but
> provides no information explaining why you think it's needed, nor how
> it is expected to be used, etc.
> 
> Please send a complete and useful changelog!
OK, will try to do better for v4.

> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -14,6 +14,11 @@ config LEDS_CLASS
> >  	  This option enables the led sysfs class in /sys/class/leds.  You'll
> >  	  need this to do anything useful with LEDs.  If unsure, say N.
> >  
> > +config LED_REGISTER_GPIO
> > +	bool
> > +	help
> > +	  This option provides the function gpio_led_register_device.
> > +
> 
> Every other LEDS Kconfig symbol uses "LEDS", not "LED".  I'll make that
> change.
I used LED only to match led-register.c. There led- seemed reasonable to
me because it's only the drivers that use leds-, but there is
led-core.o, led-class.o and led-triggers.o.
Hmm, I don't care much.
 
> >  if NEW_LEDS
> >  
> >  comment "LED drivers"
> > [...]
> > --- a/include/linux/leds.h
> > +++ b/include/linux/leds.h
> > @@ -207,5 +207,17 @@ struct gpio_led_platform_data {
> >  					unsigned long *delay_off);
> >  };
> >  
> > +/**
> > + * gpio_led_register_device - register a gpio-led device
> > + * @pdata: the platform data used for the new device
> > + *
> > + * Use this function instead of platform_device_add()ing a static struct
> > + * platform_device.
> > + *
> > + * Note: as pdata and pdata->leds is copied these usually can and should be
> > + * __initdata.
> > + */
> > +struct platform_device *gpio_led_register_device(
> > +		int id, const struct gpio_led_platform_data *pdata);
> 
> It's unusual to document functions in the .h file.  There's a bit of
> precedent for that in leds.h, but there is more precedent in
> drivers/leds/*.c
> 
> Personally I think that putting the documentation in .h is rather sucky
> - it happens so rarely that one just doesn't think of looking in there.
> 
> The description isn't terribly useful if the reader doesn't know what
> "platform_device_add()ing a static struct platform_device" is for.  Can
> we describe this in some manner whcih doesn't refer to something else
> which is probably undocumented?
> 
> The comment doesn't document return values.
OK, will fix in v4.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
