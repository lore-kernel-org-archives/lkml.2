Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2DJTYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:24:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40059 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab2DJTYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:24:20 -0400
Date: Tue, 10 Apr 2012 12:24:14 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120410192252.GB4011@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Ian Abbott <ian.abbott@mev.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
References: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
 <20120319030925.GB22956@perelman.Home>
 <20120319163103.GC3694@kroah.com>
 <20120319164325.GA31833@perelman.Home>
 <20120319224649.GA7679@perelman.Home>
 <20120319232656.GB6386@kroah.com>
 <4F798416.8040709@mev.co.uk>
 <20120410182438.GB2052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410182438.GB2052@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Apr 10 12, Greg KH wrote:
> On Mon, Apr 02, 2012 at 11:48:54AM +0100, Ian Abbott wrote:
> > On 2012-03-19 23:26, Greg KH wrote:
> > >On Mon, Mar 19, 2012 at 03:46:49PM -0700, Gerard Snitselaar wrote:
> > >>On Mon, Mar 19, 2012 at 09:43:25AM -0700, Gerard Snitselaar wrote:
> > >>>On Mon, Mar 19, 2012 at 09:31:03AM -0700, Greg KH wrote:
> > >>>>
> > >>>>Ick, why is this loop even needed?  We are only here if the pci device
> > >>>>is present in the system so this shouldn't be needed at all, right?
> > >>>>
> > >>>>Or is this a bit more complex than I am making it out to be?
> > >>>>
> > >>>>greg k-h
> > >>>
> > >>>Most likely not. I will take a look at some of the other drivers in
> > >>>comedi and see how the attach code looks there. I believe the code
> > >>>section in hpdi_attach() was written by the same person. Unfortunately
> > >>>I don't have a device to actually play around and see what changes are
> > >>>doing.
> > >>>
> > >>
> > >>I looked at this a bit more. It looks like they lose visibility to the
> > >>pci_dev structure.
> > >>
> > >>*_probe()
> > >>    comedi_pci_auto_config()     pci_dev
> > >>       comedi_auto_config()      pci_dev->dev
> > >>          comedi_device_attach() ??
> > >>             driv->attach()      ??<= iterate through pci devices.
> > >>
> > >>Most of the examples I have looked at so far use for_each_pci_dev() to
> > >>find the device, and s626 shortcuts it a bit by directly making calls
> > >>to pci_get_subsys() with specific ids. They all verify they have the
> > >>right device by checking the bus and slot that are grabbed from the
> > >>pci_dev in comedi_pci_auto_config() and passed down.
> > >
> > >Ugh, surely there's a way to keep the pci dev through the
> > >comedi_device_attach() call, right?
> > 
> > comedi_device_attach() is also called for the COMEDI_DEVCONFIG ioctl
> > for "manually" configuring a comedi device, and that has no idea
> > about struct pci_dev, etc.
> > 
> > I recently posted a series of patches that allows lower-level comedi
> > drivers to supply separate hooks for auto-configuring PCI devices or
> > USB devices without abusing the old "manual configuration" code
> > paths, see <http://driverdev.linuxdriverproject.org/pipermail/devel/2012-March/025331.html>.
> > 
> > The old loop that searches the PCI bus is still needed for the
> > "manual configuration" code path.
> 
> So, now that I've applied your patches, this patch isn't needed anymore,
> right?  Or should it be reworked to use the new interfaces?
> 
> thanks,
> 
> greg k-h
> 

I'd say drop my patch and if there is still a mismatch problem it can
probably be resolved in a better way.

gerard

