Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805Ab0FQVaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:30:00 -0400
Received: from govinda.solana.com ([198.99.130.30]:56919 "EHLO
	govinda.addtoit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab0FQV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:29:59 -0400
Date: Thu, 17 Jun 2010 17:29:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617212936.GA17185@c-98-229-117-200.hsd1.ma.comcast.net>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net> <20100617200938.GB25977@kroah.com> <20100617201417.GA2873@kroah.com> <201006172241.05878.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006172241.05878.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:41:05PM +0200, Arnd Bergmann wrote:
> On Thursday 17 June 2010 22:14:17 Greg KH wrote:
> > --- a/include/asm-generic/ioctls.h
> > +++ b/include/asm-generic/ioctls.h
> > @@ -87,12 +87,10 @@
> >  #define TIOCGICOUNT    0x545D  /* read serial port inline interrupt counts */
> >  
> >  /*
> > - * some architectures define FIOQSIZE as 0x545E, which is used for
> > - * TIOCGHAYESESP on others
> > + * Some arches already define FIOQSIZE due to a historical
> > + * conflict with a Hayes modem-specific ioctl value.
> >   */
> >  #ifndef FIOQSIZE
> > -# define TIOCGHAYESESP 0x545E  /* Get Hayes ESP configuration */
> > -# define TIOCSHAYESESP 0x545F  /* Set Hayes ESP configuration */
> >  # define FIOQSIZE      0x5460
> >  #endif
> 
> Yes, that looks right. I had introduced the #ifdef originally, but
> did not look closely enough at the patch now.
> 
> 	Arnd
> 

That's better.  I had figured that the whole block was due to the driver,
and therefore could be nuked.

				Jeff


-- 
Work email - jdike at linux dot intel dot com
