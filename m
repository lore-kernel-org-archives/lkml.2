Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0I3Boy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:44:54 -0400
Received: from kroah.org ([198.145.64.141]:35742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0I3Boy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:44:54 -0400
Date: Wed, 29 Sep 2010 18:05:01 -0700
From: Greg KH <greg@kroah.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org, dsd@laptop.org,
        jon.nettleton@gmail.com, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: Re: [PATCH 3/4] cs5535: add some additional cs5535-specific GPIO
	functionality
Message-ID: <20100930010501.GA28145@kroah.com>
References: <20100925190712.6aa5c2fc@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925190712.6aa5c2fc@debxo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 07:07:12PM -0700, Andres Salomon wrote:
> 
> This adds (well, re-adds actually) handling for events/IRQs through cs5535
> GPIOs.  In the wild and wooly world of CS5535, setup_event() is for
> assigning an IRQ to a GPIO filter/event pair, and set_irq() sets up
> the pair to trigger IRQs.
> 
> These should really only be used in highly platform-specific drivers (such
> as OLPC's DCON driver).  Sadly, because set_irq() uses MSRs, this causes the
> driver to become X86-specific.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/gpio/Kconfig       |    2 +-
>  drivers/gpio/cs5535-gpio.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cs5535.h     |    2 +

I can't take this change without the gpio subsystem maintainer acking
it.  Can you get that approval from them?

I'm guessing that your 4/4 patch here depends on it, right?  If so, I'll
hold off on applying that patch until we can figure out how to handle
this, ok?

thanks,

greg k-h
