Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0I3GaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:30:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49906 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab0I3GaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:30:23 -0400
Date: Thu, 30 Sep 2010 08:30:20 +0200
From: Florian Mickler <florian@mickler.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Newsgroups: gmane.linux.kernel
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
Message-ID: <20100930083020.62b56218@schatten.dmk.lab>
In-Reply-To: <AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>
References: <1284284969.2928.18.camel@maxim-laptop>
	<1284427621.4127.7.camel@maxim-laptop>
	<4C8F2699.3020509@kernel.org>
	<AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
	<1284507516.4963.2.camel@maxim-laptop>
	<AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
	<1284511071.3551.1.camel@maxim-laptop>
	<AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
	<20100915132731.GA20558@khazad-dum.debian.net>
	<AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
	<1284589207.4672.3.camel@maxim-laptop>
	<AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>
	<1285069338.3124.4.camel@maxim-laptop>
	<1285110590.2822.9.camel@maxim-laptop>
	<4C99B25D.20805@kernel.org>
	<1285162900.3335.15.camel@maxim-laptop>
	<1285163911.3159.5.camel@maxim-laptop>
	<4C9B141F.3050908@kernel.org>
	<AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 11:21:08 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, Sep 23, 2010 at 10:47, Tejun Heo <tj@kernel.org> wrote:
> 
> > Yeah, what I'm curious about is why hal behaves differently with
> > claiming block patch.  Exclusive open still fails with EBUSY with or
> > without the patch, right?  So, why does hal behave differently?
> 
> We don't support unlocked cd doors. Currently eject/umount of optical
> media has to be initiated by the user.
> 
> HAL checked if the device was mounted, and if it was, it dropped the
> O_EXCL. This was to support polling of the eject-button state, which
> worked on a few drives. That's no longer cecked with udisks, it does
> O_EXCL only for optical media.
> 
> >> Look if it fails. sure the device is open, but if doesn't fail, nothing
> >> prevents a bit less honest clients (that don't use exclusive open) to
> >> open the device. How exclusive such an open is then?
> 
> >> So I mean exclusive open should really block _all_ following opens of
> >> the device, exclusive or not.
> >
> > That will probably break a lot of stuff.
> 
> That would surely need a new flag like O_REALLYEXCL. :)
> 
> > I'm currently working on in-kernel media presence polling to handle
> > the open and polling command sequence issues.  That said, it's not
> > entirely clear how the mount case should be handled.  If a media is
> > mounted, the device is exclusively open and media presence polling
> > shouldn't be inserting commands in the middle but then how can it
> > detect the media has been ejected by the user?  Kay, can you please
> > enlighten me on how it's supposed to work?
> 
> Non-optical devices should not be a problem, and can be always polled,
> as it seems. We do this without O_EXCL since forever.
> 
> For optical drives I would never ever bypass O_EXCL, like udisks is
> doing it. There are far too many problems with burning, which never
> got really solved.
> 
> Force-removed media (not recommended unlocked doors) might not be
> detected until the filesystem is cleaned-up/umounted, but that's
> probably the better compromise than fiddling with the broken drives
> during burning sessions.
> 
> Kay

So, is the $subject problem solved now? Normally, we shouldn't break
stuff with new kernels... If this is only a temporary breakage on
the other hand, we should keep track of it... 
I ask, because this is listed as https://bugzilla.kernel.org/show_bug.cgi?id=18522.
If it should stay listed, we may need an ETA for the fix... 

Regards,
Flo


