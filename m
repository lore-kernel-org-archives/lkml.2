Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0KHQAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:00:12 -0500
Received: from kroah.org ([198.145.64.141]:54800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0KHQAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:00:06 -0500
Date: Mon, 8 Nov 2010 07:58:51 -0800
From: Greg KH <greg@kroah.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101108155851.GE10092@kroah.com>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <20101106181930.GB6927@kroah.com>
 <20101108065737.GA10452@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108065737.GA10452@jasper.tkos.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 08:57:37AM +0200, Baruch Siach wrote:
> Hi Greg,
> 
> On Sat, Nov 06, 2010 at 11:19:30AM -0700, Greg KH wrote:
> > On Wed, Nov 03, 2010 at 04:21:35PM +0200, Baruch Siach wrote:
> > > From: Alex Gershgorin <agersh@rambler.ru>
> > > 
> > > The active serial protocol can be used to program Altera Cyclone FPGA devices.
> > > This driver uses the kernel gpio interface to implement the active serial
> > > protocol.
> > > 
> > > Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> > > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > > ---
> 
> [snip]
> 
> > > +static struct class *cyclone_as_class;
> > 
> > Please don't create your own class just for a single driver.  Just use
> > the misc class interface instead, as all you really want/need here is a
> > character device node, right?
> 
> Searching for 'mist' under include/linux/ I couldn't find this "misc class 
> interface". Can you enlighten me?
> 
> I did find the "miscdevices" interface in include/linux/miscdevice.h.

Yes, that is the one.

> I also tried this one before going on to create a class of my own.
> However, this interface seems to be limited to singleton devices. Can
> I use MISC_DYNAMIC_MINOR to create multiple device nodes?

I didn't see where your code was handling multiple device nodes, is it
really doing that?

> Is there any example for this?

You can just increment the name for the miscdevice to do this based on a
driver-supplied unique number.

> > And as discussed at the Plumbers conference this past week, we don't
> > want to add any new 'struct class' implementations to the kernel from
> > now on, as it's the overall wrong thing to do.
> > 
> > > --- /dev/null
> > > +++ b/include/linux/cyclone_as.h
> > 
> > Why do you need a .h file at all?
> 
> Look at the content of this file. I need to pass GPIO numbers from the 
> platform code under arch/ to the driver. For this I use a platform_data 
> struct, which must be visible to the platform code. Is there a better way to 
> do this?

{sigh}

I'm getting really tired of these kinds of .h files cluttering up the
kernel for an interface that should be easier to handle some other way.

I'm really tempted to create something like:
	include/platform_crap/
to put all of these into.

Ok, that probably will not make people all that happy, so how about:
	include/platform_drivers/

instead?

thanks,

greg k-h
