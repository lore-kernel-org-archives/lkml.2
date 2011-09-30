Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1I3SB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:01:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42252 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1I3SB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:01:27 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18v3p6Y9eDKompD10AC39rb
Date: Fri, 30 Sep 2011 11:01:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] usb: musb: OMAP4430: Remove a redundant
 omap4430_phy_init call in usb_musb_init
Message-ID: <20110930180121.GK6324@atomide.com>
References: <1316508629.14514.2.camel@phoenix>
 <20110929070849.GA27987@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929070849.GA27987@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [110928 23:35]:
> On Tue, Sep 20, 2011 at 04:50:29PM +0800, Axel Lin wrote:
> > Current code calls omap4430_phy_init() twice in usb_musb_init().
> > Calling omap4430_phy_init() once is enough.
> > This patch removes the first omap4430_phy_init() call, which using an
> > uninitialized pointer as parameter.
> > 
> > This patch elimates below build warning:
> > arch/arm/mach-omap2/usb-musb.c: In function 'usb_musb_init':
> > arch/arm/mach-omap2/usb-musb.c:141: warning: 'dev' may be used uninitialized in this function
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Thanks, applying into fixes.

Tony

> 
> > ---
> >  arch/arm/mach-omap2/usb-musb.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> > index a65145b..19e4dac 100644
> > --- a/arch/arm/mach-omap2/usb-musb.c
> > +++ b/arch/arm/mach-omap2/usb-musb.c
> > @@ -137,9 +137,6 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
> >  	musb_plat.mode = board_data->mode;
> >  	musb_plat.extvbus = board_data->extvbus;
> >  
> > -	if (cpu_is_omap44xx())
> > -		omap4430_phy_init(dev);
> > -
> >  	if (cpu_is_omap3517() || cpu_is_omap3505()) {
> >  		oh_name = "am35x_otg_hs";
> >  		name = "musb-am35x";
> > -- 
> > 1.7.4.1
> > 
> > 
> > 
> 
> -- 
> balbi


