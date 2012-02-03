Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2BCLAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:00:45 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51974 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab2BCLAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:00:44 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.15.19
Date: Fri, 3 Feb 2012 03:00:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Michail Kurachkin <michail.kurachkin@promwad.com>,
        Ivan Kuten <ivan.kuten@promwad.com>
Subject: Re: TDM bus support in Linux Kernel
Message-ID: <20120203110036.GA7732@leaf>
References: <CAKa7sPRgROFY2RfeVW0G_1EWzWXakuWu50tGQ2QuzrvEimU3FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKa7sPRgROFY2RfeVW0G_1EWzWXakuWu50tGQ2QuzrvEimU3FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 11:59:10AM +0300, Viktar Palstsiuk wrote:
> We are designing custom hardware board where processor is connected
> with analog telephony
> SLIC via TDM bus.
> During investigation of Linux kernel we did not find any corresponding TDM code.
> So decided to write a new TDM subsystem in drivers/tdm (like SPI).
> The subsystem consists of tdm_core.c which implements TDM bus routines,
> e.g. tdm_register_board_info(), tdm_add_device(),
> tdm_controller_register() etc, and
> someplatform_tdm.c which implements platform specific TDM contoller.
> 
> Any suggestion if we have chosen right direction and our approach
> conforms Linux kernel architecture?

Disclaimer: not a telephony expert.

>From the information you've provided in this mail, it *sounds* like you
probably have the right approach.  You've definitely done the right
thing by asking for architectural review sooner rather than later, and
it sounds like you've created a nicely abstracted subsystem modeled
after existing Linux subsystems rather than building an entire stack
directly into your driver, which would already put you well ahead of
most hardware vendors.  :)

You should post your code to LKML so that developers can review it.  You
should also CC any potentially interested developers, so they actually
see it.  In addition to CCing anyone specifically interested in
telephony, since you've developed a new subsystem I'd suggest CCing Greg
Kroah-Hartman <gregkh@linuxfoundation.org> as the maintainer of the
driver core.

Also, I don't know whether the TDM bus allows device probing or whether
you have to magically know in advance what devices you expect on a
particular platform.  If the former, you probably want to make sure you
support and use an appropriate MODULE_DEVICE_TABLE for your drivers, so
you can easily look up the right driver for any given device.  If the
latter, you may potentially want to look into the "flattened device
tree" mechanism, which provides a standard means of providing
"hardcoded" hardware configuration information to the kernel at boot
time.  If as the maker of the hardware you have any control over this,
go with the former. :)

> May be there were already some preliminary work for this?

In-kernel, it looks like a "slicoss" driver exists in staging, and
drivers/isdn exists, but AFAICT neither one has had any non-bugfix
development in a long time; the latter has some references to TDM,
though I don't know to what extent it might prove relevant to you.

Outside the kernel, you may want to look at
http://wiki.freeswitch.org/wiki/FreeTDM ; it currently seems to rely on
various out-of-tree and proprietary drivers of dubious status, but you
might still want to look it over, to find out if it has useful ideas or
if you might want to add support for your hardware.

I don't know of any efforts specifically trying to provide a
standardized interface for the TDM bus.  I suspect you'll end up getting
to lead the way here.

Hope that helps,
Josh Triplett
