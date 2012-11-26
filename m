Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2KZKAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:00:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58467 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2KZJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:59:59 -0500
Date: Mon, 26 Nov 2012 10:59:56 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.jarrige@armadeus.org,
        julien.boibessot@armadeus.com
Subject: Re: [PATCH 3/4] imx27-dt: configure i2c1 gpio on armadeus apf27
Message-ID: <20121126095956.GD10369@pengutronix.de>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
 <1353874625-14754-4-git-send-email-tremyfr@yahoo.fr>
 <20121126102858.4ba818b0@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126102858.4ba818b0@skate>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:58:13 up 156 days,  1:09, 35 users,  load average: 0.33, 0.40,
 0.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 10:28:58AM +0100, Thomas Petazzoni wrote:
> Dear Philippe Reynes,
> 
> On Sun, 25 Nov 2012 21:17:04 +0100, Philippe Reynes wrote:
> 
> >  static const struct of_dev_auxdata imx27_auxdata_lookup[] __initconst = {
> > @@ -48,6 +49,10 @@ int apf27_lan8700_wakeup(struct phy_device *phydev)
> >  static void __init apf27_init(void)
> >  {
> >  	phy_register_fixup_for_id("imx27-fec.0-1:1f", apf27_lan8700_wakeup);
> > +
> > +	/* configure i2c1 gpio */
> > +	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 17));
> > +	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 18));
> >  }
> 
> I haven't followed i.MX 27 support lately, but this surely should be
> done using a pinctrl driver. I see that there is a general pinctrl
> driver for i.MX, but a drivers/pinctrl/pinctrl-imx27.c might be
> missing. It would probably be a better idea to implement the missing
> pinctrl driver, if not already available?

It's not available, and yes, it should be implemented. Adding the iomux
setup to a i.MX27 SoC specific file is not a good idea.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
