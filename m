Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2AGPAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 10:00:35 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:19494 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2AGPAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 10:00:34 -0500
Date: Sat, 7 Jan 2012 16:00:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use 
 module_platform_driver()
Message-ID: <20120107160018.43c9d7fe@endymion.delvare>
In-Reply-To: <20111127202212.44ebf4c4@endymion.delvare>
References: <1322374332.2226.1.camel@phoenix>
	<20111127202212.44ebf4c4@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Sun, 27 Nov 2011 20:22:12 +0100, Jean Delvare wrote:
> On Sun, 27 Nov 2011 14:12:12 +0800, Axel Lin wrote:
> > diff --git a/drivers/i2c/muxes/gpio-i2cmux.c b/drivers/i2c/muxes/gpio-i2cmux.c
> > index 7b6ce62..e5fa695 100644
> > --- a/drivers/i2c/muxes/gpio-i2cmux.c
> > +++ b/drivers/i2c/muxes/gpio-i2cmux.c
> > @@ -165,18 +165,7 @@ static struct platform_driver gpiomux_driver = {
> >  	},
> >  };
> >  
> > -static int __init gpiomux_init(void)
> > -{
> > -	return platform_driver_register(&gpiomux_driver);
> > -}
> > -
> > -static void __exit gpiomux_exit(void)
> > -{
> > -	platform_driver_unregister(&gpiomux_driver);
> > -}
> > -
> > -module_init(gpiomux_init);
> > -module_exit(gpiomux_exit);
> > +module_platform_driver(gpiomux_driver);
> 
> This one would be better as a separate patch, as it touches a different
> subdirectory, which I am responsible for.

You resent a v2 of the patch without muxes/gpio-i2cmux.c, which is
good, but I never received the suggested separate patch for
muxes/gpio-i2cmux.c. Did I miss it somehow? Please send it quickly if
you want it to make it into kernel 3.3.

-- 
Jean Delvare
