Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1EKQbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:31:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1EKQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:31:45 -0400
Date: Wed, 11 May 2011 08:22:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] [wip] ARM: imx: register "leds-gpio" device using new
 helper function
Message-ID: <20110511062257.GH29089@pengutronix.de>
References: <20110510073152.GF29089@pengutronix.de>
 <1305017456-10910-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1305017456-10910-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <0D753D10438DA54287A00B027084269764D2C3CCBE@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0D753D10438DA54287A00B027084269764D2C3CCBE@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hartley,

On Tue, May 10, 2011 at 05:26:18PM -0500, H Hartley Sweeten wrote:
> On Tuesday, May 10, 2011 1:51 AM, Uwe Kleine-König wrote:
> > diff --git a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > index fa5288018..3479f66 100644
> > --- a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > +++ b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > @@ -113,7 +113,7 @@ eukrea_mbimx27_keymap_data __initconst = {
> >  	.keymap_size    = ARRAY_SIZE(eukrea_mbimx27_keymap),
> >  };
> >  
> > -static struct gpio_led gpio_leds[] = {
> > +static const struct gpio_led gpio_leds[] __initconst = {
> >  	{
> >  		.name			= "led1",
> >  		.default_trigger	= "heartbeat",
> > @@ -128,19 +128,11 @@ static struct gpio_led gpio_leds[] = {
> >  	},
> >  };
> >  
> > -static struct gpio_led_platform_data gpio_led_info = {
> > +static const struct gpio_led_platform_data gpio_led_info __initconst = {
> >  	.leds		= gpio_leds,
> >  	.num_leds	= ARRAY_SIZE(gpio_leds),
> >  };
> 
> Just a note that the 'const' you added to struct gpio_led above will be
> discarded in struct gpio_led_platform_data.  You will get something like:
> 
> arch/arm/mach-imx/eukrea_mbimx27-baseboard.c:132: warning: initialization discards qualifiers from pointer target type
It seems you don't have

	9517f92 (leds: make *struct gpio_led_platform_data.leds const)

(contained in .39-rc1) in your tree :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
