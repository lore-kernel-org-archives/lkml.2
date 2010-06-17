Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab0FQUOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:14:23 -0400
Received: from kroah.org ([198.145.64.141]:51552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab0FQUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:14:21 -0400
Date: Thu, 17 Jun 2010 13:14:17 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617201417.GA2873@kroah.com>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
 <20100617172828.GA24362@kroah.com>
 <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
 <20100617200938.GB25977@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100617200938.GB25977@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 01:09:38PM -0700, Greg KH wrote:
> On Thu, Jun 17, 2010 at 03:15:16PM -0400, Jeff Dike wrote:
> > On Thu, Jun 17, 2010 at 10:28:28AM -0700, Greg KH wrote:
> > > You forgot to put a "Signed-off-by:" line in here.
> > > 
> > > Care to add it, and resend it to me?
> > 
> > Oops...
> > 
> > commit e6b14f5bc9803589241bc2aae1565fa0c5bd0ce1
> > Author: Jeff Dike <jdike@linux.intel.com>
> > Date:   Thu Jun 17 11:54:24 2010 -0400
> > 
> >     Remove Hayes ESP ioctls
> >     
> >     The Hayes ESP driver has been removed from the tree:
> >         commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
> >         ("tty: esp: remove broken driver")
> >     so its ioctls aren't needed any more.
> > 
> >     Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> > 
> > diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> > index a799e20..16218ac 100644
> > --- a/include/asm-generic/ioctls.h
> > +++ b/include/asm-generic/ioctls.h
> > @@ -86,16 +86,6 @@
> >  #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> >  #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> >  
> > -/*
> > - * some architectures define FIOQSIZE as 0x545E, which is used for
> > - * TIOCGHAYESESP on others
> > - */
> > -#ifndef FIOQSIZE
> > -# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
> > -# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
> > -# define FIOQSIZE	0x5460
> > -#endif
> 
> Wait, don't we still need to define FIOQSIZE here if no one else has
> done it yet?  With this patch I get a build error on fs/ioctl.c:
> 	fs/ioctl.c: In function ‘do_vfs_ioctl’:
> 	fs/ioctl.c:573:7: error: ‘FIOQSIZE’ undeclared (first use in this function)
> 
> So shouldn't we just remove the TIOCGHAYESESP and TIOCSHAYESESP values,
> and only set FIOQSIZE if it's not set yet?

How about something like the following:


 include/asm-generic/ioctls.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -87,12 +87,10 @@
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 
 /*
- * some architectures define FIOQSIZE as 0x545E, which is used for
- * TIOCGHAYESESP on others
+ * Some arches already define FIOQSIZE due to a historical
+ * conflict with a Hayes modem-specific ioctl value.
  */
 #ifndef FIOQSIZE
-# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
-# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
 # define FIOQSIZE	0x5460
 #endif
 
