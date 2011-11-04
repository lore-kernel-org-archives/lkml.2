Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab1KDUBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:01:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1KDUBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:01:11 -0400
Date: Fri, 4 Nov 2011 13:00:57 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martyn Welch <martyn.welch@ge.com>,
        Grant Likely <grant.likely@secretlab.ca>, devel@driverdev.osuosl.org,
        manohar.vanga@cern.ch, cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Driver for GE PIO2 VME Card
Message-ID: <20111104200057.GB400@suse.de>
References: <20111104173126.30940.28135.stgit@ES-BJ21R4J>
 <1320436514.14409.309.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320436514.14409.309.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 08:55:14PM +0100, Paul Bolle wrote:
> A few random remarks follow. Ie, things that came up while quickly
> scanning this.
> 
> On Fri, 2011-11-04 at 17:33 +0000, Martyn Welch wrote:
> > diff --git a/drivers/staging/vme/devices/Kconfig b/drivers/staging/vme/devices/Kconfig
> > index ca5ba89..99f5414 100644
> > --- a/drivers/staging/vme/devices/Kconfig
> > +++ b/drivers/staging/vme/devices/Kconfig
> > @@ -6,3 +6,13 @@ config VME_USER
> >  	  If you say Y here you want to be able to access a limited number of
> >  	  VME windows in a manner at least semi-compatible with the interface
> >  	  provided with the original driver at http://vmelinux.org/.
> 
> Blank line here.
> 
> > +config VME_PIO2
> > +	tristate "GE PIO2 VME"
> > +	help
> > +	  If you say Y here you have a GE PIO2. The PIO2 is a 6U VME Card,
> 
> Maybe something like: "Say Y here if you have a GE PIO2."?
> 
> > +	  implementing 32 solid-state relay switched IO lines, in 4 groups of 8.
> > +	  The IO lines are provided as input, output or both as a build time
> > +	  option.
> 
> What option would that be?
> 
> > +	  Otherwise it is safe to say N here.
> > +
> 
> A lot of modules have the "if you say M here the module will be called"
> boilerplate here (which actually doesn't match the line I just made up).
> 
> > +/* These are required for each board */
> > +MODULE_PARM_DESC(bus, "Enumeration of VMEbus to which the board is connected");
> > +module_param_array(bus, int, &bus_num, 0);
> > +
> > +MODULE_PARM_DESC(base, "Base VME address for PIO2 Registers");
> > +module_param_array(base, long, &base_num, 0);
> > +
> > +MODULE_PARM_DESC(vector, "VME IRQ Vector (Lower 4 bits masked)");
> > +module_param_array(vector, int, &vector_num, 0);
> > +
> > +MODULE_PARM_DESC(level, "VME IRQ Level");
> > +module_param_array(level, int, &level_num, 0);
> > +
> > +MODULE_PARM_DESC(variant, "Last 4 characters of PIO2 board variant");
> > +module_param_array(variant, charp, &variant_num, 0);
> > +
> > +/* This is for debugging */
> > +MODULE_PARM_DESC(loopback, "Enable loopback mode on all cards");
> > +module_param(loopback, bool, 0);
> 
> All module parameters have a sysfs visibility (or permission) of zero.
> Why is that? (This might very well be a naive question. But I often
> wonder why a certain parameter's permission isn't at least 400, just to
> allow a quick check of that parameter.) Are arrays tricky in sysfs?

Yes, arrays are tricky, and in the end, all of these need to be "real"
sysfs files, not module parameters, but for now, it's ok to leave it as
is until the code is cleaned up.

thanks,

greg k-h
