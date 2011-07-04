Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1GDPvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:51:20 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62906 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab1GDPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:51:18 -0400
Message-ID: <19985.57715.78894.466149@ipc1.ka-ro>
Date: Mon, 4 Jul 2011 17:51:15 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] add missing intialisation of bgc->dir
In-Reply-To: <20110704153944.GD29977@ponder.secretlab.ca>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
	<1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
	<20110704064844.GM15152@ponder.secretlab.ca>
	<19985.35317.629981.97373@ipc1.ka-ro>
	<20110704153944.GD29977@ponder.secretlab.ca>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Grant Likely writes:
> On Mon, Jul 04, 2011 at 11:37:57AM +0200, Lothar Waßmann wrote:
> > Hi,
> > 
> > Grant Likely writes:
> > > On Fri, Jul 01, 2011 at 02:08:51PM +0200, Lothar Waßmann wrote:
> > > > ---
> > > >  drivers/gpio/basic_mmio_gpio.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> > > > index 8152e9f..e69a453 100644
> > > > --- a/drivers/gpio/basic_mmio_gpio.c
> > > > +++ b/drivers/gpio/basic_mmio_gpio.c
> > > > @@ -399,6 +399,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
> > > >  		return ret;
> > > >  
> > > >  	bgc->data = bgc->read_reg(bgc->reg_dat);
> > > > +	bgc->dir = bgc->read_reg(bgc->reg_dir);
> > > 
> > > Hi Lothar.
> > > 
> > > You'll need to double check your email setup.  The patch got emailed
> > > separately from the description.
> > > 
> > git-send-email did that.
> 
> It appears that you asked it to send a cover letter, which you usually
> don't want when sending a single patch.  The patch description should
> be part of the git commit itself.
>
Yes, I noticed that already.

> > > I don't know if this is a valid thing to do or not.  Not every GPIO
> > > controller supports reading back the initial state from the direction
> > > register.  I suspect it is better to leave initialization of the
> > > direction to the gpio controller driver itself.
> > > 
> > That would mean, that external software would have to have access to
> > the bgpio internal data structures which is a Bad Thing(TM) IMO. Or we
> > need a function that allows to explicitly initialize the internal
> > shadow registers.
> 
> What device are you using this for.  Are you using the basic gpio
> platform_driver, or do you have a driver using the library part of the
> basic gpio code?
> 
I'm using it via drivers/gpio/gpio-mxc.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
