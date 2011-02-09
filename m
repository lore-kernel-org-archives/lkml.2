Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1BIT7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:59:51 -0500
Received: from kroah.org ([198.145.64.141]:43500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab1BIT7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:59:20 -0500
Date: Wed, 9 Feb 2011 11:54:43 -0800
From: Greg KH <greg@kroah.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jarod@wilsonet.com>
Subject: Re: PATCH: drivers/staging/lirc/lirc_serial.c: use IS_ERR()
Message-ID: <20110209195443.GA8816@kroah.com>
References: <4D4F0701.5060602@teksavvy.com>
 <4D51B6EF.5000409@teksavvy.com>
 <20110209195238.GA8707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209195238.GA8707@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:52:38AM -0800, Greg KH wrote:
> On Tue, Feb 08, 2011 at 04:34:39PM -0500, Mark Lord wrote:
> > On 11-02-06 03:39 PM, Mark Lord wrote:
> > > The lirc_serial.c module has never worked with ordinary homebrew
> > > serial blaster hardware, and leaks memory when this is attempted.
> > > 
> > > Fix it by replacing incorrect usage of PTR_ERR() with IS_ERR().
> > > (patch is inline and also attached to bypass mailer issues).
> > > 
> > > Signed-off-by: Mark Lord <mlord@pobox.com>
> > > 
> > > --- linux-2.6.37/drivers/staging/lirc/lirc_serial.c	2011-01-04
> > > 19:50:19.000000000 -0500
> > > +++ linux/drivers/staging/lirc/lirc_serial.c	2011-02-06 15:33:49.854453928 -0500
> > > @@ -966,7 +966,7 @@
> > >  	if (n % sizeof(int) || count % 2 == 0)
> > >  		return -EINVAL;
> > >  	wbuf = memdup_user(buf, n);
> > > -	if (PTR_ERR(wbuf))
> > > +	if (IS_ERR(wbuf))
> > >  		return PTR_ERR(wbuf);
> > >  	spin_lock_irqsave(&hardware[type].lock, flags);
> > >  	if (type == LIRC_IRDEO) {
> > 
> > 
> > Anyone out there?
> > 
> > Greg?
> 
> Patience please, I just got over the flu and am now catching up on
> patches.  I'll go queue this up now.

Actually, it's already fixed in the current tree thanks to Jarod in
commit 88914bdf8c677ebd7e797adac05e47303fd6ac77 so you shouldn't need to
worry about this anymore.

thanks,

greg k-h
