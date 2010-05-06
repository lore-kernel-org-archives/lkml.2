Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab0EFU1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:27:39 -0400
Received: from kroah.org ([198.145.64.141]:58424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab0EFU1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:27:35 -0400
Date: Thu, 6 May 2010 13:25:35 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100506202535.GA28600@kroah.com>
References: <20100503234123.GC13519@suse.de>
 <1272931198.30040.218.camel@Joe-Laptop.home>
 <20100504025430.GA26421@suse.de>
 <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 11:59:03AM -0500, H Hartley Sweeten wrote:
> On Tuesday, May 04, 2010 2:23 PM, H Hartley Sweeten wrote:
> >
> > The macros ReadMReg and WriteMReg are really just private versions of
> > the kernel's readl and writel functions.  Use the kernel's functions
> > instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> > change all the uses of dt3155_lbase to reflect this.
> >
> > While here, make dt3155_lbase static since it is only used in the
> > dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
> > since it is not used anywhere in the code.
> >
> > Where is makes sense, create a local 'mmio' variable instead of using
> > dt3155_lbase[minor] to make the code more readable.
> >
> > This change also affects the {Read|Write}I2C functions so they are
> > also modified as needed.
> >
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Scott Smedley <ss@aao.gov.au>
> >
> 
> Greg,
> 
> Did this patch fair any better when trying to merge it?

No, not at all :(

> If there is still an issue I will wait until Linus' tree, linux-next,
> and your staging-next branch appear to be more in sync.

Yes, please wait a bit, I really don't know what is going on here,
sorry.

greg k-h
