Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab1FFWtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:49:21 -0400
Received: from mail.perches.com ([173.55.12.10]:2566 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab1FFWtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:49:20 -0400
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: anish <anish198519851985@gmail.com>, devel@driverdev.osuosl.org,
        arnd@arndb.de, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        manuel.stahl@iis.fraunhofer.de
In-Reply-To: <20110606224126.GA2668@suse.de>
References: <1307387257.4327.12.camel@anish-desktop>
	 <20110606215549.GA7543@suse.de> <1307398257.4994.30.camel@Joe-Laptop>
	 <20110606222118.GA29883@suse.de> <1307399309.4994.34.camel@Joe-Laptop>
	 <20110606224126.GA2668@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 15:49:17 -0700
Message-ID: <1307400557.4994.41.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 15:41 -0700, Greg KH wrote:
> On Mon, Jun 06, 2011 at 03:28:29PM -0700, Joe Perches wrote:
> > On Mon, 2011-06-06 at 15:21 -0700, Greg KH wrote:
> > > On Mon, Jun 06, 2011 at 03:10:57PM -0700, Joe Perches wrote:
> > > > On Mon, 2011-06-06 at 14:55 -0700, Greg KH wrote:
> > > > > On Tue, Jun 07, 2011 at 12:37:37AM +0530, anish wrote:
> > > > > > From: anish kumar <anish198519851985@gmail.com>
> > > > > > Replace kmalloc with local variables as it was un-necessary and
> > > > > > also removed the redudant code after this change.
> > > > > SPI data, like USB data, has to come from kmalloced data, not from the
> > > > > stack, or bad things can, and will, happen.
> > > > Perhaps just add a comment like:
> > > > +       u8 *tx = kmalloc(2, GFP_KERNEL);	/* can't be on stack */
> > > You really want to do to that for _EVERY_ SPI and USB driver?  I don't
> > > think so.
> > Nope, only the ones that look especially odd because 
> > 	kmalloc(sizeof(struct foo), ...)
> > or
> > 	kmalloc(sizeof("type), ...)
> > is not used.
> > It might be better to just declare a 2 byte struct.
> No, this is a very common thing for all USB and SPI drivers.  It's so
> obvious that once I saw the Subject: line, I knew this patch was going
> to be wrong.

As did I.
I seek to find a way to avoid seeing them in the future too.

> This is something that the USB and SPI developers know all about, it's
> the way things work, and this driver works, so why are people trying to
> "clean" it up in ways that will break it, or cause extra work with
> structures where they are not needed at all?
> odd.

Because people perform pattern recognition as a means to avoid
the work required for complete understanding.

Comments akin to the one in drivers/usb/serial/io_ti.c:

	lsr = kmalloc(1, GFP_KERNEL);	/* Sigh, that's right, just one byte,
					   as not all platforms can do DMA
					   from stack */

help people avoid applying patterns to inappropriate uses.


