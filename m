Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2K0IKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:10:13 -0500
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:49536 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757604Ab2K0IKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:10:12 -0500
Date: Tue, 27 Nov 2012 09:00:06 +0100
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: eukrea_mbimx27-baseboard - use stock
 get_pendown_state() in ads7846
Message-ID: <20121127090006.06eb49dc@eb-e6520>
In-Reply-To: <20121127074209.GL10369@pengutronix.de>
References: <20121124082529.GA7687@core.coreip.homeip.net>
	<20121127074209.GL10369@pengutronix.de>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 8288593640309304721
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehhedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehhedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 27 Nov 2012 08:42:09 +0100,
Sascha Hauer <s.hauer@pengutronix.de> a écrit :

> On Sat, Nov 24, 2012 at 12:25:30AM -0800, Dmitry Torokhov wrote:
> > The default implementation matches exactly our custom one so we can switch
> > to using the default one. As a bonus the driver will take care of setting
> > GPIO line for us.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> > 
> > Not tested - no hardware, but should be fine.
> > 
> >  arch/arm/mach-imx/eukrea_mbimx27-baseboard.c | 19 +------------------
> >  1 file changed, 1 insertion(+), 18 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > index 98aef57..b20fc55 100644
> > --- a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > +++ b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> > @@ -238,24 +238,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
> >  	.flags = IMXUART_HAVE_RTSCTS,
> >  };
> >  
> > -#define ADS7846_PENDOWN (GPIO_PORTD | 25)
> > -
> > -static void __maybe_unused ads7846_dev_init(void)
> > -{
> > -	if (gpio_request(ADS7846_PENDOWN, "ADS7846 pendown") < 0) {
> > -		printk(KERN_ERR "can't get ads7846 pen down GPIO\n");
> > -		return;
> > -	}
> > -	gpio_direction_input(ADS7846_PENDOWN);
> > -}
> > -
> > -static int ads7846_get_pendown_state(void)
> > -{
> > -	return !gpio_get_value(ADS7846_PENDOWN);
> > -}
> > -
> >  static struct ads7846_platform_data ads7846_config __initdata = {
> > -	.get_pendown_state	= ads7846_get_pendown_state,
> > +	.gpio_pendown		= (GPIO_PORTD | 25),
> 
> Please use IMX_GPIO_NR(4, 25) instead. Otherwise this looks ok.
> 
> Eric, ok with you?
> 
seems fine.

Eric

