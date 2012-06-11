Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2FKXHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:07:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2FKXH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:07:28 -0400
Date: Mon, 11 Jun 2012 16:07:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH -next] usb: add usb.h stubs for CONFIG_USB not enabled
Message-ID: <20120611230723.GA25565@kroah.com>
References: <Pine.LNX.4.44L0.1205191026400.1348-100000@netrider.rowland.org>
 <4FB7C0E4.4000008@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB7C0E4.4000008@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 08:48:52AM -0700, Randy Dunlap wrote:
> On 05/19/2012 07:30 AM, Alan Stern wrote:
> 
> > On Fri, 18 May 2012, Randy Dunlap wrote:
> > 
> >> From: Randy Dunlap <rdunlap@xenotime.net>
> >>
> >> Add stubs for some usb core functions when CONFIG_USB
> >> is not enabled.  This fixes these comedi build errors:
> >>
> >> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
> >> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> >> ---
> >> I am only adding the stubs that are needed for comedi to build.
> >> I expect that more stubs will be needed as more build errors are
> >> found.  It seems to me that linux/usb.h might need more (major)
> >> moving of lines to support more stubs in the future.
> > 
> > This doesn't seem like the right thing to do.  If a driver needs to 
> > register with the USB core then that driver should depend on 
> > CONFIG_USB.
> > 
> > On the other hand, if the driver is capable of being built without USB 
> > support then it should use the necessary preprocessor tests to protect 
> > calls to any USB routines.
> 
> 
> Yeah, my first patch (not on linux-usb list) to staging/comedi/drivers.c
> just surrounded the usb helper functions with IS_ENABLED(CONFIG_USB).
> I'm fine with that patch, but Greg said that he wanted stubs...

In looking at this a bit more, I think we should go back to the "fix up
comedi" patch, as it is less intrusive, and as we haven't needed these
stubs for the past 10+ years, we probably shouldn't add them now :)

So, do you happen to have that old patch around, or do you want me to
make those changes?

thanks,

greg k-h
