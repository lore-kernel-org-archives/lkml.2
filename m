Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1GDPjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:39:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37288 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1GDPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:39:47 -0400
Date: Mon, 4 Jul 2011 09:39:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add missing intialisation of bgc->dir
Message-ID: <20110704153944.GD29977@ponder.secretlab.ca>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
 <1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
 <20110704064844.GM15152@ponder.secretlab.ca>
 <19985.35317.629981.97373@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19985.35317.629981.97373@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 11:37:57AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Grant Likely writes:
> > On Fri, Jul 01, 2011 at 02:08:51PM +0200, Lothar Waßmann wrote:
> > > ---
> > >  drivers/gpio/basic_mmio_gpio.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> > > index 8152e9f..e69a453 100644
> > > --- a/drivers/gpio/basic_mmio_gpio.c
> > > +++ b/drivers/gpio/basic_mmio_gpio.c
> > > @@ -399,6 +399,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
> > >  		return ret;
> > >  
> > >  	bgc->data = bgc->read_reg(bgc->reg_dat);
> > > +	bgc->dir = bgc->read_reg(bgc->reg_dir);
> > 
> > Hi Lothar.
> > 
> > You'll need to double check your email setup.  The patch got emailed
> > separately from the description.
> > 
> git-send-email did that.

It appears that you asked it to send a cover letter, which you usually
don't want when sending a single patch.  The patch description should
be part of the git commit itself.

> 
> > I don't know if this is a valid thing to do or not.  Not every GPIO
> > controller supports reading back the initial state from the direction
> > register.  I suspect it is better to leave initialization of the
> > direction to the gpio controller driver itself.
> > 
> That would mean, that external software would have to have access to
> the bgpio internal data structures which is a Bad Thing(TM) IMO. Or we
> need a function that allows to explicitly initialize the internal
> shadow registers.

What device are you using this for.  Are you using the basic gpio
platform_driver, or do you have a driver using the library part of the
basic gpio code?

g.

