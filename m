Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936037Ab0GPIyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 04:54:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:55693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936016Ab0GPIyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:54:47 -0400
Date: Fri, 16 Jul 2010 01:55:33 -0700
From: Greg KH <gregkh@suse.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Conke Hu <conke.hu@gmail.com>, CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100716085533.GB2419@suse.de>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com> <20100715163526.GJ29322@n2100.arm.linux.org.uk> <20100715165141.GA21272@suse.de> <20100715171029.GK29322@n2100.arm.linux.org.uk> <20100715172218.GA22197@suse.de> <20100715173322.GL29322@n2100.arm.linux.org.uk> <20100715205153.GC24463@suse.de> <20100715210936.GB6773@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715210936.GB6773@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:09:36PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 15, 2010 at 01:51:53PM -0700, Greg KH wrote:
> > On Thu, Jul 15, 2010 at 06:33:22PM +0100, Russell King - ARM Linux wrote:
> > > Another way to avoid the other complaints is to remove
> > > the unregistration in platform_register_devices().
> > 
> > No, because you could have created a platform device with a call to
> > platform_device_alloc() and then called platform_device_register() and
> > then later, platform_device_unregister(), right?
> 
> No.  Sorry, platform_register_devices should've been platform_add_devices().
> Please look at that function.

Hm, it just calls platform_device_register(), so it's pretty hard to
determine that it's a static device from that function.

> It's used to register an array of static platform devices from architecture
> code, as I've said in this thread once already.

I can't think of an easy way to prevent these types of devices from
being removed, other than the existing warnings we have.  I'll mull it
over some more and see if I can come up with something in the future.

thanks,

greg k-h
