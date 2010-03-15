Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449Ab0COON5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:13:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58368 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935372Ab0COON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:13:56 -0400
Date: Mon, 15 Mar 2010 14:13:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@debian.org>,
       Alessandro Rubini <rubini@unipv.it>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Wells <wellsk40@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amba-clcd: add RGB444 support
Message-ID: <20100315141304.GF700@n2100.arm.linux.org.uk>
References: <1268659809-3609-1-git-send-email-l.fu@pengutronix.de> <20100315133810.GE700@n2100.arm.linux.org.uk> <20100315135945.GA4584@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315135945.GA4584@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 02:59:45PM +0100, Luotao Fu wrote:
> Hi Russell,
> 
> On Mon, Mar 15, 2010 at 01:38:10PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Mar 15, 2010 at 02:30:09PM +0100, Luotao Fu wrote:
> > > This one adds RGB444 (bpp=12) support to amba clcd drivers. Tested on a lpc3250
> > > based platform.
> > 
> > No - this is wrong.  You have a 16bpp display.  bpp is the number of bits
> > in the framebuffer between two successive pixels.  It is not the number of
> > bits used for the pixel information.
> > 
> 
> > The only case where you have a 12bpp display is if you have two pixels
> > packed into three bytes.
> >
> For 12bpp actually 16bits/pixel is used. I'm aware of that. That's the
> reason why the fb.var.bits_per_pixel is set to 16 in clcdfb_decode if
> it is originally set to 12 from the platform file to make usage of 16bpp
> display. omapfb driver does quite the same.

Then omapfb is also buggy and needs fixing in a similar manner.

The de-facto way of determining the bitfield structure is as I highlighted,
which is used by all the x86 drivers supporting RGB555 and RGB565.

We don't use bits_per_pixel=15 for RGB555, and using bits_per_pixel=12 for
RGB444 is wrong for all the same reasons.
