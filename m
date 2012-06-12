Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2FLAoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:44:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FLAoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:44:24 -0400
Date: Mon, 11 Jun 2012 17:44:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: cleanup alloc_subdevices
Message-ID: <20120612004421.GA30997@kroah.com>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 07:07:41PM -0500, H Hartley Sweeten wrote:
> On Monday, June 11, 2012 4:57 PM, Greg KH wrote:
> > On Thu, Jun 07, 2012 at 03:08:15PM -0700, H Hartley Sweeten wrote:
> >> Cleanup the comedi core "alloc_subdevices" fuction and it's use
> >> in the comedi drivers.
> >> 
> >> 1) Move the inline alloc_subdevices() function from comedidev.h
> >> to drivers.c and rename it to comedi_alloc_subdevices(). The
> >> function is large enough to warrant being an exported symbol
> >> rather than being an inline in every driver.
> >> 
> >> 2) Since dev->n_subdevices is an int variable, change the 
> >> num_subdevices parameter from an unsigned int to an int.
> >> 
> >> 3) It's possible for a couple of the comedi drivers to incorrectly
> >> call this function with num_subdevices = 0 so add a sanity check
> >> before doing the kcalloc.
> >> 
> >> 4) It's possible for the kcalloc to fail so don't set dev->n_subdevices
> >> until after the kcalloc has succedded. Also, remove the places in
> >> the drivers were dev->n_subdevices was being set directly.
> >> 
> >> 5) Remove all the "allocation failed" error messages.
> >> 
> >> 6) Remove all the "Allocate the subdevice structures" comments from
> >> the drivers. The function name itself provides this information.
> >> 
> >> 7) When comedi_alloc_subdevices does fail, make all the drivers
> >> properly return the error code.
> >
> > You are doing 7 different things in one patch.  Doesn't that imply that
> > you should have 7 different patches, in series, doing this?  That would
> > make it easier to review at the least.
> >
> > Please redo this in that manner and resend.
> 
> 2, 3, and 4 probably go together. They all deal with the 'num_subdevices'
> 
> 1 can be a separate patch as long as I don't do the rename.
> 
> 5, 6, and 7 could all go together with the final rename of the function.
> 
> Does that sound ok?

No, why not just break it up into 7 different patches?  You are doing
different things, which would you rather review for correctness, 7
simple, tiny patches, or some that do multiple things at the same time
that are bigger?

thanks,

greg k-h
