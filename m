Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1EDO5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:57:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45574 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1EDO53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:57:29 -0400
Date: Wed, 4 May 2011 15:57:25 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jamie Iles <jamie@jamieiles.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504145725.GD15967@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504110939.GB13514@pulham.picochip.com>
 <20110504113131.GA639@oksana.dev.rtsoft.ru>
 <20110504143757.GB15967@pulham.picochip.com>
 <20110504154440.1674adb9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504154440.1674adb9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, May 04, 2011 at 03:44:40PM +0100, Alan Cox wrote:
> > OK, so here's what I've got so far (patches attached).  I've updated the 
> > basic_mmio_gpio library with your initial lkml patch and updated it to 
> > allow bgpio_chip to be embedded in another structure.  I've also 
> > attempted to convert over the bt8xx and langwell drivers but they're a 
> > little rough around the edges in places (and untested as I don't have 
> > the hardware).
> 
> Looking at the Langwell driver you replace 130 lines of code that do the
> job, with 126 lines of code that do setup for a whole extra module which
> makes it bigger and slower as well as much harder to maintain.
> 
> That sounds to me like for Langwell at least it is not worth doing
> because all you've done is added complexity, indirection and overhead. So
> NAK the Langwell one.

I picked that one because I thought it might convert nicely, but it 
didn't!  I posted it anyway in case I'm missing a better way to do it 
and to give a fair representation.

With regards to the ARM drivers, lots of these aren't currently devices 
(in the driver model) so converting many of these would be net code 
increase but I suspect that it's probably worth it in these cases 
(providing that's the only complexity).

> The bt8xx looks a nice example of one of the cases where it will help
> however.

Yes, and I suspect there are a few others too.

Jamie
