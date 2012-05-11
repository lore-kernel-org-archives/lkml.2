Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946272Ab2EKV7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:59:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946234Ab2EKV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:59:47 -0400
Date: Fri, 11 May 2012 14:59:43 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Message-ID: <20120511215943.GA27371@kroah.com>
References: <201205111007.46754.hartleys@visionengravers.com>
 <4FAD4D20.1010302@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
 <4FAD4F7F.1060603@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net>
 <4FAD5703.7080504@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17ECA@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17ECA@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 01:26:37PM -0500, H Hartley Sweeten wrote:
> On Friday, May 11, 2012 11:14 AM, Ian Abbott wrote:
> > Okay, but I don't think it's worth doing three patches for each driver 
> > where one would do.  Adding a one-line .name = "foo", to the single 
> > patch for each driver you were planning to do anyway seems like a 
> > trivial addition that could be slotted into the patch without too much 
> > argument from the "one change per patch" folks, especially if you 
> > mention the purpose of that line in the commit message.  (I'd defer to 
> > the better judgement of Greg though.)
> 
> With this patch my main goal was to not "break" any of the drivers.
> 
> As a follow-up to this patch I was going to use the macro in all the
> pci drivers that have been refactored. Similar to what I did with the
> module_comedi_driver macro. When I do that I can add the static
> name field to those drivers.
> 
> How about doing this in the register function:
> 
> 	If (!pci_driver->name)
> 		pci_driver->name = comedi_driver->driver_name;
> 
> This way all the drivers that still need to be refactored will still work.
> 
> After all the drivers have been updated, those two lines can be
> removed.
> 
> So we have this patch and one big patch updating all the refactored
> drivers. Some number of patches refactoring the remaining drivers
> and using the module_comedi_pci_driver macro. Then one last
> patch removing the check above.
> 
> How does that sound?

That sounds reasonable to me.

greg k-h
