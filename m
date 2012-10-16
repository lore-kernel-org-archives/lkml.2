Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2JPRko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:40:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55274 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2JPRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:40:42 -0400
Date: Tue, 16 Oct 2012 10:40:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roland Stigge <stigge@antcom.de>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RFC 02/11 v4] gpio: Add sysfs support to block GPIO API
Message-ID: <20121016174038.GA17982@kroah.com>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
 <1350343887-7344-3-git-send-email-stigge@antcom.de>
 <20121015235720.GA3132@kroah.com>
 <507D58D9.2040607@antcom.de>
 <20121016164326.GA4858@kroah.com>
 <CACRpkdYaaSt9uLN2_=KXYDK2b5D5paopsYxgYKqezKCx8cy=vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYaaSt9uLN2_=KXYDK2b5D5paopsYxgYKqezKCx8cy=vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 07:27:15PM +0200, Linus Walleij wrote:
> On Tue, Oct 16, 2012 at 6:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Oct 16, 2012 at 02:53:45PM +0200, Roland Stigge wrote:
> >>
> >> Further, current gpio and gpiochip devices are also doing this way:
> >> creating the device and subsequently their attrs, even though there may
> >> be a better way but I'm still wondering how this would be.
> >
> > Then the existing code is broken and should be fixed to use dev_attrs.
> > I guess it's time to audit the tree and find all places that get this
> > wrong...
> 
> The thing is, as I've tried to explain but maybe didn't get across,
> that these devices don't *have* a parent, and are not part of any
> tree.

You are passing in a parent device to the device_create() call, where
did that pointer come from?

Either way, the attribute creation needs to happen before we announce
the device to userspace, that's a bug that should be fixed now.

> They are parentless mock devices, created on-the-fly just to get
> sysfs entries.

That's fine, well, not the "parentless" part, but that should be trivial
to fix, just pass in the correct pointer and you should be fine.

> What is needed it to get the device model right in the first
> place.

I thought it was in the device model already?

> Fixing it has been drafted by me and Grant:
> https://blueprints.launchpad.net/linux-linaro/+spec/gpiochip-to-dev
> 
> This is not all-encompassing though :-/

That's a good list to work from, good luck :)

greg k-h
