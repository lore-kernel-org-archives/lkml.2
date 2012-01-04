Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2ADCcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:32:43 -0500
Received: from ozlabs.org ([203.10.76.45]:60637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab2ADCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:32:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool (drivers & misc)
In-Reply-To: <20120103124420.GA3626@mwanda>
References: <87ehw6sesk.fsf@rustcorp.com.au> <20120103124420.GA3626@mwanda>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jan 2012 12:57:51 +1030
Message-ID: <8762gsdwwo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012 15:44:20 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
Non-text part: multipart/signed
> > diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
> > --- a/drivers/video/intelfb/intelfbdrv.c
> > +++ b/drivers/video/intelfb/intelfbdrv.c
> > @@ -230,16 +230,16 @@ MODULE_DESCRIPTION("Framebuffer driver f
> >  MODULE_LICENSE("Dual BSD/GPL");
> >  MODULE_DEVICE_TABLE(pci, intelfb_pci_table);
> >  
> > -static int accel        = 1;
> > +static bool accel       = 1;
> >  static int vram         = 4;
> > -static int hwcursor     = 0;
> > -static int mtrr         = 1;
> > -static int fixed        = 0;
> > -static int noinit       = 0;
> > -static int noregister   = 0;
> > -static int probeonly    = 0;
> > -static int idonly       = 0;
> > -static int bailearly    = 0;
> > +static bool hwcursor    = 0;
> > +static bool mtrr        = 1;
> > +static bool fixed       = 0;
> > +static bool noinit      = 0;
> > +static bool noregister  = 0;
> > +static bool probeonly   = 0;
> > +static bool idonly      = 0;
> > +static bool bailearly   = 0;
> 
> bailearly should be an int here.  It's part of some ugly debug code
> where a value of 3 means bailout at point 3.  Maybe we should just
> remove it instead...

Yeah, it never worked, since you could only ever set it to 0 or 1:

        module_param(bailearly, bool, 0);

On Tue, 3 Jan 2012 15:58:13 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Dec 15, 2011 at 01:48:51PM +1030, Rusty Russell wrote:
> > diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
> > --- a/drivers/block/paride/pcd.c
> > +++ b/drivers/block/paride/pcd.c
...
> > -static int verbose = 0;
> > +static bool verbose = 0;
> 
> This should be int.  Verbose can be set to 2 for extra verbosity.

Again, I haven't made it more broken than it is already:

        module_param(verbose, bool, 0644);

I've split these two off into separate fixes.  Thanks!

> Btw, these patches that touch a ton of drivers are the wrong idea.
> If you ack any part of it, then get_maintainer.pl CCs you on every
> single kernel patch until eventually you get old and die.

I didn't know that; get_maintainer.pl usually produces too much spew for
me anyway.  It could use some smarts.

Cheers,
Rusty.
