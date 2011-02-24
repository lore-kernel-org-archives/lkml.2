Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1BXACJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:02:09 -0500
Received: from kroah.org ([198.145.64.141]:60400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1BXACI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:02:08 -0500
Date: Wed, 23 Feb 2011 16:01:55 -0800
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110224000155.GA32282@kroah.com>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
 <AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:51:04AM +1000, Dave Airlie wrote:
> On Tue, Feb 22, 2011 at 10:17 PM, Alan Cox <alan@linux.intel.com> wrote:
> > This is an initial staging driver for the GMA500. It's been stripped out
> > of the PVR drivers and crunched together from various bits of code and
> > different kernels.
> >
> > Currently it's unaccelerated but still pretty snappy even compositing with
> > the frame buffer X server.
> >
> > Lots of work is needed to rework the ttm and bo interfaces from being
> > ripped out and then 2D acceleration wants putting back for framebuffer and
> > somehow eventually via DRM.
> >
> > There is no support for the parts without open source userspace (video
> > accelerators, 3D) as per kernel policy.
> >
> > I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
> > something about DRI internals then help would be most welcome.
> >
> 
> 
> Okay I'm okay with this going into staging but we should work out a
> plan for it going forward.

Good as I just added it to the staging-next tree a few hours ago :)

> I don't have any poulsbo hw but if some were to appear I could
> probably expend effort on this.
> 
> So where do we want to go my opinion is
> 
> a) remove all userspace interfaces and simplify ttm memory management usage.
> b) add support to hook this up to the dumb ioctl so we can do trivial
> generic front buffer allocation, so then a libkms + dumb kms
> modesetting driver can work on it.
> c) figure out how to add interface for acceleration users. Whether TTM
> fence interfaces are required etc.

That all sounds reasonable to me.  Patches now gladly accepted.

thanks,

greg k-h
