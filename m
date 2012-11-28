Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2K1RWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:22:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:54847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2K1RWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:22:51 -0500
Date: Wed, 28 Nov 2012 09:22:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121128172248.GA32286@kroah.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128114537.GN11248@mwanda>
 <201211281256.10839.hansverk@cisco.com>
 <20121128101802.0eafb6e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128101802.0eafb6e7@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:18:02AM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 28 Nov 2012 12:56:10 +0100
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
> > On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> > > I wish people wouldn't submit big patches right before the merge
> > > window opens...  :/ It's better to let it sit in linux-next for a
> > > couple weeks so people can mess with it a bit.
> > 
> > It's been under review for quite some time now, and the main change since
> > the last posted version is that this is now moved to staging/media.
> > 
> > So it is not yet ready for prime time, but we do want it in to simplify
> > the last remaining improvements needed to move it to drivers/media.
> 
> "last remaining improvements"? I didn't review the patchset, but
> the TODO list seems to have several pending stuff there:
> 
> +- User space interface refinement
> +        - Controls should be used when possible rather than private ioctl
> +        - No enums should be used
> +        - Use of MC and V4L2 subdev APIs when applicable
> +        - Single interface header might suffice
> +        - Current interface forces to configure everything at once
> +- Get rid of the dm365_ipipe_hw.[ch] layer
> +- Active external sub-devices defined by link configuration; no strcmp
> +  needed
> +- More generic platform data (i2c adapters)
> +- The driver should have no knowledge of possible external subdevs; see
> +  struct vpfe_subdev_id
> +- Some of the hardware control should be refactorede
> +- Check proper serialisation (through mutexes and spinlocks)
> +- Names that are visible in kernel global namespace should have a common
> +  prefix (or a few)
> 
> From the above comments, both Kernelspace and Userspace APIs require 
> lots of work.
> 
> Also, it is not clear at all if this is a fork of the existing davinci
> driver, or if it is a completely new driver for an already-supported
> hardware, making very hard (if not impossible) to review it, and, if it
> is yet-another-driver for the same hardware, moving it out of staging
> will be a big issue, as it won't be trivial to check for regressions
> introduced by a different driver.
> 
> > 
> > I'm happy with this going in given the circumstances.
> 
> Well, I'm not.

Me either, it is way too late in the cycle to take huge stuff for 3.8,
sorry.

But as I don't manage drivers/staging/media/ there's not even anything I
can do here, it's Mauro's, so I'll leave it up to him :)

thanks,

greg k-h
