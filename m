Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2K2HpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:45:12 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3896 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2HpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:45:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Thu, 29 Nov 2012 08:43:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LMML <linux-media@vger.kernel.org>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <201211282018.20832.hverkuil@xs4all.nl> <20121128193021.GA4174@kroah.com>
In-Reply-To: <20121128193021.GA4174@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211290843.36468.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed November 28 2012 20:30:21 Greg Kroah-Hartman wrote:
> On Wed, Nov 28, 2012 at 08:18:20PM +0100, Hans Verkuil wrote:
> > On Wed November 28 2012 18:22:48 Greg Kroah-Hartman wrote:
> > > On Wed, Nov 28, 2012 at 10:18:02AM -0200, Mauro Carvalho Chehab wrote:
> > > > Em Wed, 28 Nov 2012 12:56:10 +0100
> > > > Hans Verkuil <hansverk@cisco.com> escreveu:
> > > > 
> > > > > On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> > > > > > I wish people wouldn't submit big patches right before the merge
> > > > > > window opens...  :/ It's better to let it sit in linux-next for a
> > > > > > couple weeks so people can mess with it a bit.
> > > > > 
> > > > > It's been under review for quite some time now, and the main change since
> > > > > the last posted version is that this is now moved to staging/media.
> > > > > 
> > > > > So it is not yet ready for prime time, but we do want it in to simplify
> > > > > the last remaining improvements needed to move it to drivers/media.
> > > > 
> > > > "last remaining improvements"? I didn't review the patchset, but
> > > > the TODO list seems to have several pending stuff there:
> > > > 
> > > > +- User space interface refinement
> > > > +        - Controls should be used when possible rather than private ioctl
> > > > +        - No enums should be used
> > > > +        - Use of MC and V4L2 subdev APIs when applicable
> > > > +        - Single interface header might suffice
> > > > +        - Current interface forces to configure everything at once
> > > > +- Get rid of the dm365_ipipe_hw.[ch] layer
> > > > +- Active external sub-devices defined by link configuration; no strcmp
> > > > +  needed
> > > > +- More generic platform data (i2c adapters)
> > > > +- The driver should have no knowledge of possible external subdevs; see
> > > > +  struct vpfe_subdev_id
> > > > +- Some of the hardware control should be refactorede
> > > > +- Check proper serialisation (through mutexes and spinlocks)
> > > > +- Names that are visible in kernel global namespace should have a common
> > > > +  prefix (or a few)
> > > > 
> > > > From the above comments, both Kernelspace and Userspace APIs require 
> > > > lots of work.
> > 
> > And that's why it is in staging. Should a long TODO list now suddenly
> > prevent staging from being used? In Barcelona we discussed this and the
> > only requirement we came up was was that it should compile.
> 
> Yes, that's all I care about in staging, but as I stated, I don't
> maintain drivers/staging/media/ that area is under Mauro's control
> (MAINTAINERS even says this), and I'm a bit leery of going against the
> wishes of an existing subsystem maintainer for adding staging drivers
> that tie into their subsystem.
> 
> So if you get Mauro's approval, I'll be glad to queue it up.

Just for the record, my comments were addressed to Mauro, not to you.
I should have stated that in my mail explicitly. As you said, it's
Mauro's decision.

Regards,

	Hans
