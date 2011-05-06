Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1EFVEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:04:13 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:57868 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1EFVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:04:12 -0400
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
From: Richard Purdie <rpurdie@rpsys.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110413062316.GH18850@pengutronix.de>
References: <1302097097.22904.41.camel@rex>
	 <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <20110412214848.GI7806@n2100.arm.linux.org.uk>
	 <20110413062316.GH18850@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 22:03:22 +0100
Message-ID: <1304715802.30391.157.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 08:23 +0200, Uwe Kleine-König wrote:
> On Tue, Apr 12, 2011 at 10:48:48PM +0100, Russell King - ARM Linux wrote:
> > On Mon, Apr 11, 2011 at 10:35:57PM +0200, Uwe Kleine-König wrote:
> > > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > > index 9bec869..e8e101e 100644
> > > --- a/drivers/leds/Kconfig
> > > +++ b/drivers/leds/Kconfig
> > > @@ -14,6 +14,11 @@ config LEDS_CLASS
> > >  	  This option enables the led sysfs class in /sys/class/leds.  You'll
> > >  	  need this to do anything useful with LEDs.  If unsure, say N.
> > >  
> > > +config LED_REGISTER_GPIO
> > > +	bool
> > > +	help
> > > +	  This option provides the function gpio_led_register_device.
> > > +
> > >  if NEW_LEDS
> > >  
> > >  comment "LED drivers"
> > > diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> > > index 39c80fc..ca428bd 100644
> > > --- a/drivers/leds/Makefile
> > > +++ b/drivers/leds/Makefile
> > > @@ -3,6 +3,7 @@
> > >  obj-$(CONFIG_NEW_LEDS)			+= led-core.o
> > >  obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
> > >  obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
> > > +obj-y					+= led-register.o
> > 
> > Why not obj-$(CONFIG_LED_REGISTER_GPIO) += led-register.o
> > 
> > rather than wrapping the code of led-register.c with a #ifdef for the
> > same symbol?
> I thought that the registration for other led-devices could go into that
> file, too. That's why I choosed the name led-register and not
> leds-gpio-register.c. Agreed? I don't insist on that.

I'm not sure we want/need to put other registration functions in this
file? obj-$(CONFIG_LED_REGISTER_GPIO) probably therefore makes sense
until some other registration need arises.

Regardless, I'm happier with this patch than the previous ones. If you
change it to use obj-$(CONFIG_LED_REGISTER_GPIO), 

Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>

Cheers,

Richard

-- 
Linux Foundation
http://www.yoctoproject.org/

