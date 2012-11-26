Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2KZQmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44218 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2KZQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: How about a gpio_get(device *, char *) function?
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdaUJKs7zx=JWRUb+0Qz2dQU=R5KUK+CoM+nLCgHL99AFA@mail.gmail.com>
References: <38620644.IyR5R8rjKP@percival> <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com> <5097F8CF.5090100@wwwdotorg.org> <CACRpkdaUJKs7zx=JWRUb+0Qz2dQU=R5KUK+CoM+nLCgHL99AFA@mail.gmail.com>
Date: Mon, 26 Nov 2012 11:14:31 +0000
Message-Id: <20121126111431.AE4C23E09C2@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012 22:28:01 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Nov 5, 2012 at 6:35 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > [Me]
> >> gpio_get() should get an abstract handle just like clk_get() or
> >> regulator_get(), not a fixed numeral.
> >
> > I don't really see why the return type of gpio_get() influences whether
> > it can be implemented or not.
> 
> It doesn't influence that, but I want to follow the opaqueness design
> pattern from irq descriptors and struct clk.

Right. I like the pattern too. Unforutunately that means dealing with
somewhere on the order of 2500 callers of the old API. :-(

However, I don't think that the GPIO numberspace issue is completely
intertwined with opaqifying the gpio handles. The numberspace can be
fixed with the current API if someone creates a sparse gpio
registrations.

I don't have any problem with a gpio_get function, but I do agree that
making it return an opaque handle is how it should be written with a new
set of accessors. The handle should probably be simply the pointer to
the &gpio_desc[number] which is a private table in gpiolib.c. The
definition of it isn't available outside of gpiolib.c

In fact, the old functions should be redefined in terms of getting the
gpio_desc from the irq number and calling the new functions.

> 
> > With board files, some "gpio map" table would simply contain the same
> > int GPIO ID value the table as is used anywhere else already. With DT,
> > the same xlate function would translate from DT GPIO-chip-relative
> > IDs/specifiers into the global number space in the same way that we do
> > today via other APIs.
> 
> Yes, this part I buy into, just want to see how we can move forward
> from there. The coplete nightmare is to introduce something into DT
> that nails down a global GPIO numberspace... but I think that is not
> the case atleast.
> 
> > If the GPIO subsystem were reworked as you propose, this API could be
> > reworked in exactly the same way, or if implemented after the rework, it
> > would return whatever handle type was in use at the time.
> 
> Yes, I just think we should return an opaque struct from day 1, so
> just a little, little bit more to shield us.
> 
> Yours,
> Linus Walleij

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
