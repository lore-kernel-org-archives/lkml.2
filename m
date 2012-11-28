Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2K1TTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:19:52 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1309 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab2K1TTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:19:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Wed, 28 Nov 2012 20:18:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <20121128101802.0eafb6e7@redhat.com> <20121128172248.GA32286@kroah.com>
In-Reply-To: <20121128172248.GA32286@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211282018.20832.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed November 28 2012 18:22:48 Greg Kroah-Hartman wrote:
> On Wed, Nov 28, 2012 at 10:18:02AM -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 28 Nov 2012 12:56:10 +0100
> > Hans Verkuil <hansverk@cisco.com> escreveu:
> > 
> > > On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> > > > I wish people wouldn't submit big patches right before the merge
> > > > window opens...  :/ It's better to let it sit in linux-next for a
> > > > couple weeks so people can mess with it a bit.
> > > 
> > > It's been under review for quite some time now, and the main change since
> > > the last posted version is that this is now moved to staging/media.
> > > 
> > > So it is not yet ready for prime time, but we do want it in to simplify
> > > the last remaining improvements needed to move it to drivers/media.
> > 
> > "last remaining improvements"? I didn't review the patchset, but
> > the TODO list seems to have several pending stuff there:
> > 
> > +- User space interface refinement
> > +        - Controls should be used when possible rather than private ioctl
> > +        - No enums should be used
> > +        - Use of MC and V4L2 subdev APIs when applicable
> > +        - Single interface header might suffice
> > +        - Current interface forces to configure everything at once
> > +- Get rid of the dm365_ipipe_hw.[ch] layer
> > +- Active external sub-devices defined by link configuration; no strcmp
> > +  needed
> > +- More generic platform data (i2c adapters)
> > +- The driver should have no knowledge of possible external subdevs; see
> > +  struct vpfe_subdev_id
> > +- Some of the hardware control should be refactorede
> > +- Check proper serialisation (through mutexes and spinlocks)
> > +- Names that are visible in kernel global namespace should have a common
> > +  prefix (or a few)
> > 
> > From the above comments, both Kernelspace and Userspace APIs require 
> > lots of work.

And that's why it is in staging. Should a long TODO list now suddenly
prevent staging from being used? In Barcelona we discussed this and the
only requirement we came up was was that it should compile.

> > Also, it is not clear at all if this is a fork of the existing davinci
> > driver, or if it is a completely new driver for an already-supported
> > hardware, making very hard (if not impossible) to review it, and, if it
> > is yet-another-driver for the same hardware, moving it out of staging
> > will be a big issue, as it won't be trivial to check for regressions
> > introduced by a different driver.

Having two competing drivers for the same hardware are hardly new. We've
had our share of those in the past, so I fail to see why this is suddenly
a problem or why that should prevent this driver from being merged in staging.

So once the driver is ready to be moved from staging to drivers/media, then
we can choose to keep the old driver around for awhile and let the user
make the choice which to use.

> > 
> > > 
> > > I'm happy with this going in given the circumstances.
> > 
> > Well, I'm not.
> 
> Me either, it is way too late in the cycle to take huge stuff for 3.8,
> sorry.
> 
> But as I don't manage drivers/staging/media/ there's not even anything I
> can do here, it's Mauro's, so I'll leave it up to him :)

It's a staging driver. So you know it will need more work and that it isn't
perfect. It's independent of any core kernel code, so it won't affect anything
else. I don't see why the size of the staging driver should matter in deciding
whether or not to include it. Nor do I see any reason why letting it linger
in linux-next for a few weeks should improve it in any way since we know it
has issues as it is in staging. I understand why linux-next is useful when
it comes to core code, but in this case it just seems to introduce a second
merge window before the 'real' merge window.

This is getting ridiculous in my opinion, not to mention discouraging for
developers. Staging is supposed to be fairly easy to get into (and out of,
if you don't continue development), but now I see all sorts of hurdles being
thrown up.

This driver has been in development for ages, it has seen quite a bit of
review resulting in the TODO list. I believe it's time to get this into
staging. If no further development takes place, then we just kick it out
in 6 months or so, no harm done.

Regards,

	Hans
