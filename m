Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab2IFT4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:56:22 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:45202 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2IFT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:56:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX191zAC/1dxcJqO/A/3Hmv0P
Date: Thu, 6 Sep 2012 12:56:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Message-ID: <20120906195607.GB1303@atomide.com>
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com>
 <5048C2A2.2020104@ti.com>
 <20120906171301.GC17754@arwen.pp.htv.fi>
 <20120906171803.GA30717@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906171803.GA30717@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [120906 10:23]:
> Hi,
> 
> On Thu, Sep 06, 2012 at 08:13:03PM +0300, Felipe Balbi wrote:
> > Hi,
> > 
> > On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
> > > 
> > > 
> > > On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> > > > The mailbox register for usb otg in omap is present in control module.
> > > > On detection of any events VBUS or ID, this register should be written
> > > > to send the notification to musb core.
> > > > 
> > > > Till we have a separate control module driver to write to control module,
> > > > omap2430 will handle the register writes to control module by itself. So
> > > > a new address space to represent this control module register is added
> > > > to usb_otg_hs.
> > > > 
> > > > Cc: Benoit Cousson <b-cousson@ti.com>
> > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > ---
> > > >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > > index 242aee4..02341bc 100644
> > > > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > > @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
> > > >  		.pa_end		= 0x4a0ab003,
> > > >  		.flags		= ADDR_TYPE_RT
> > > >  	},
> > > > +	{
> > > > +		.pa_start	= 0x4a00233c,
> > > > +		.pa_end		= 0x4a00233f,
> > > > +		.flags		= ADDR_TYPE_RT
> > > > +	},
> > > 
> > > I do not have any objection/comment here, but I believe this is control
> > > module address space required for USB module, right?
> > > I am not sure this is right way of accessing control module space.
> > > Actually Control Module Access required for drivers is one of the
> > > blocking issue we have currently.
> > > 
> > > Also there was some effort put up by 'Konstantine' to convert Control
> > > module to MFD driver, I haven't seen any further update on it. But it
> > > would be good to check with him.
> > 
> > this was an agreement with Benoit since we already lost a couple merge
> > windows for this patchset. We agreed to wait until -rc4 for SCM driver
> > and if it wasn't ready, we'd go ahead with this and SCM author would fix
> > it up on a patch converting users to new SCM driver.
> 
> Tony, can I get your Acked-by to this patch so I can take it together
> with the rest of the series ? Thanks
> 
> ps: I'll apply this to my 'musb' branch which is immutable, so it's safe
> to merge it into your tree once I apply.

It would be best if this got acked by Benoit and Paul as they may
have some other patches queued up. I'll ack if they ack ;)

Tony
