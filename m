Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2IGE5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:57:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49862 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2IGE5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:57:36 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Thread-Topic: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Thread-Index: AQHNjD/HHshpdyaaf02JITaIfoJKF5d9cdgA//+/NICAARyb0A==
Date: Fri, 7 Sep 2012 04:57:12 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EAAC815@DBDE01.ent.ti.com>
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com> <5048C2A2.2020104@ti.com>
 <20120906171301.GC17754@arwen.pp.htv.fi>
In-Reply-To: <20120906171301.GC17754@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 22:43:03, Balbi, Felipe wrote:
> Hi,
> 
> On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
> > 
> > 
> > On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> > > The mailbox register for usb otg in omap is present in control module.
> > > On detection of any events VBUS or ID, this register should be written
> > > to send the notification to musb core.
> > > 
> > > Till we have a separate control module driver to write to control module,
> > > omap2430 will handle the register writes to control module by itself. So
> > > a new address space to represent this control module register is added
> > > to usb_otg_hs.
> > > 
> > > Cc: Benoit Cousson <b-cousson@ti.com>
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > ---
> > >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > index 242aee4..02341bc 100644
> > > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > > @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
> > >  		.pa_end		= 0x4a0ab003,
> > >  		.flags		= ADDR_TYPE_RT
> > >  	},
> > > +	{
> > > +		.pa_start	= 0x4a00233c,
> > > +		.pa_end		= 0x4a00233f,
> > > +		.flags		= ADDR_TYPE_RT
> > > +	},
> > 
> > I do not have any objection/comment here, but I believe this is control
> > module address space required for USB module, right?
> > I am not sure this is right way of accessing control module space.
> > Actually Control Module Access required for drivers is one of the
> > blocking issue we have currently.
> > 
> > Also there was some effort put up by 'Konstantine' to convert Control
> > module to MFD driver, I haven't seen any further update on it. But it
> > would be good to check with him.
> 
> this was an agreement with Benoit since we already lost a couple merge
> windows for this patchset. We agreed to wait until -rc4 for SCM driver
> and if it wasn't ready, we'd go ahead with this and SCM author would fix
> it up on a patch converting users to new SCM driver.
> 

Understood and thanks for confirming.

Thanks,
Vaibhav

> -- 
> balbi
> 

