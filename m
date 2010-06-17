Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab0FQWDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:03:31 -0400
Received: from kroah.org ([198.145.64.141]:47405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab0FQWDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:03:30 -0400
Date: Thu, 17 Jun 2010 15:03:25 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617220325.GA30984@kroah.com>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
 <20100617200938.GB25977@kroah.com>
 <20100617201417.GA2873@kroah.com>
 <201006172241.05878.arnd@arndb.de>
 <20100617212936.GA17185@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617212936.GA17185@c-98-229-117-200.hsd1.ma.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 05:29:36PM -0400, Jeff Dike wrote:
> On Thu, Jun 17, 2010 at 10:41:05PM +0200, Arnd Bergmann wrote:
> > On Thursday 17 June 2010 22:14:17 Greg KH wrote:
> > > --- a/include/asm-generic/ioctls.h
> > > +++ b/include/asm-generic/ioctls.h
> > > @@ -87,12 +87,10 @@
> > >  #define TIOCGICOUNT    0x545D  /* read serial port inline interrupt counts */
> > >  
> > >  /*
> > > - * some architectures define FIOQSIZE as 0x545E, which is used for
> > > - * TIOCGHAYESESP on others
> > > + * Some arches already define FIOQSIZE due to a historical
> > > + * conflict with a Hayes modem-specific ioctl value.
> > >   */
> > >  #ifndef FIOQSIZE
> > > -# define TIOCGHAYESESP 0x545E  /* Get Hayes ESP configuration */
> > > -# define TIOCSHAYESESP 0x545F  /* Set Hayes ESP configuration */
> > >  # define FIOQSIZE      0x5460
> > >  #endif
> > 
> > Yes, that looks right. I had introduced the #ifdef originally, but
> > did not look closely enough at the patch now.
> > 
> > 	Arnd
> > 
> 
> That's better.  I had figured that the whole block was due to the driver,
> and therefore could be nuked.

Next time you might want to build your patches :)

thanks,

greg k-h
