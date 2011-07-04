Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1GDQT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:19:28 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:63261 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab1GDQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:19:26 -0400
Message-ID: <19985.59397.631201.89451@ipc1.ka-ro>
Date: Mon, 4 Jul 2011 18:19:17 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] add missing intialisation of bgc->dir
In-Reply-To: <CACxGe6v87WboQwZn9L0QtND2=B6g6ScQcPgTPnU_2whn=-B9HA@mail.gmail.com>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
	<1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
	<20110704064844.GM15152@ponder.secretlab.ca>
	<19985.35317.629981.97373@ipc1.ka-ro>
	<20110704153944.GD29977@ponder.secretlab.ca>
	<19985.57715.78894.466149@ipc1.ka-ro>
	<CACxGe6v87WboQwZn9L0QtND2=B6g6ScQcPgTPnU_2whn=-B9HA@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Grant Likely writes:
> On Mon, Jul 4, 2011 at 9:51 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> > Hi,
> >
> >> > > I don't know if this is a valid thing to do or not.  Not every GPIO
> >> > > controller supports reading back the initial state from the direction
> >> > > register.  I suspect it is better to leave initialization of the
> >> > > direction to the gpio controller driver itself.
> >> > >
> >> > That would mean, that external software would have to have access to
> >> > the bgpio internal data structures which is a Bad Thing(TM) IMO. Or we
> >> > need a function that allows to explicitly initialize the internal
> >> > shadow registers.
> >>
> >> What device are you using this for.  Are you using the basic gpio
> >> platform_driver, or do you have a driver using the library part of the
> >> basic gpio code?
> >>
> > I'm using it via drivers/gpio/gpio-mxc.
> 
> You can safely do the "bgc->dir = bgc->read_reg(bgc->reg_dir);" in
> gpio-mxc after bgpio_init returns.
> 
I know I can do that, but IMO it's a horrible way of programming, to
let a higher SW layer freely mess with the data structures of another
SW layer. There should be accessor functions to do that!


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
