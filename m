Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2JPQtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:49:50 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:33904 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755359Ab2JPQtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:49:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+j5rOGQFVAtkXqmTx17+gu
Date: Tue, 16 Oct 2012 09:49:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, arnd@arndb.de, olof@lixom.net,
        rdunlap@xenotime.net, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: OMAP4: add _dev_attr_ to ocp2scp for
 representing usb_phy
Message-ID: <20121016164936.GR15569@atomide.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-3-git-send-email-kishon@ti.com>
 <20121011004413.GW12552@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011004413.GW12552@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121010 17:46]:
> Hi,
> 
> * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > In order to reflect devices(usb_phy) attached to ocp2scp bus, ocp2scp
> > is assigned a device attribute to represent the attached devices.
> ...
> 
> > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/io.h>
> >  #include <linux/platform_data/gpio-omap.h>
> >  #include <linux/power/smartreflex.h>
> > +#include <linux/platform_data/omap_ocp2scp.h>
> >  
> >  #include <plat/omap_hwmod.h>
> >  #include <plat/i2c.h>
> > @@ -2681,6 +2682,32 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
> >  	.sysc	= &omap44xx_ocp2scp_sysc,
> >  };
> >  
> > +/* ocp2scp dev_attr */
> > +static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
> > +	{
> > +		.name		= "usb_phy",
> > +		.start		= 0x4a0ad080,
> > +		.end		= 0x4a0ae000,
> > +		.flags		= IORESOURCE_MEM,
> > +	},
> > +	{
> > +		/* XXX: Remove this once control module driver is in place */
> > +		.name		= "ctrl_dev",
> > +		.start		= 0x4a002300,
> > +		.end		= 0x4a002303,
> > +		.flags		= IORESOURCE_MEM,
> > +	},
> > +	{ }
> > +};
> 
> Why don't you set the CONTROL_DEV_CONF as a fixed regulator?

After some more investigating, we may be able to set it up as a
regulator or clock later on. But as a regression fix, this seems
OK for me.

Benoit, is this OK for you?

Regards,

Tony
