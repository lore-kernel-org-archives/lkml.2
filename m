Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab0GORdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:33:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38070 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab0GORds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:33:48 -0400
Date: Thu, 15 Jul 2010 18:33:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Conke Hu <conke.hu@gmail.com>, CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100715173322.GL29322@n2100.arm.linux.org.uk>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com> <20100715163526.GJ29322@n2100.arm.linux.org.uk> <20100715165141.GA21272@suse.de> <20100715171029.GK29322@n2100.arm.linux.org.uk> <20100715172218.GA22197@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715172218.GA22197@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:22:18AM -0700, Greg KH wrote:
> On Thu, Jul 15, 2010 at 06:10:29PM +0100, Russell King - ARM Linux wrote:
> > On Thu, Jul 15, 2010 at 09:51:41AM -0700, Greg KH wrote:
> > > On Thu, Jul 15, 2010 at 05:35:26PM +0100, Russell King - ARM Linux wrote:
> > > > On Thu, Jul 15, 2010 at 11:16:30PM +0800, Conke Hu wrote:
> > > > > ever notice to the following kernel log?
> > > > > "Device 's3c2440-nand' does not have a release() function, it is
> > > > > broken and must."
> > > > > release() function should be implemented  in the platform_device.
> > > > 
> > > > That's not telling you to provide a release function.  The warning is
> > > > telling you that a device is being unregistered which doesn't have a
> > > > release function.
> > > > 
> > > > Consider this point - maybe it doesn't have a release function because
> > > > it's not supposed to be unregistered?
> > > 
> > > Heh, well, it is being unregistered, and at that point in time, the
> > > kernel complains.
> > 
> > The unregistration occurs because platform_register_devices() (which is
> > used by arch code to register a block of platform devices) undoes its
> > work if one of the devices fails to register.
> > 
> > I've long since thought, since I created that function, that this probably
> > isn't desirable behaviour, and it should continue to register as many
> > devices as it possibly can.
> > 
> > > All kobjects need a release function that actually frees it.  If not,
> > > that is a logic bug.  Please see the Documentation/kobject.txt file for
> > > details.
> > 
> > How do you free a statically declared platform device?
> 
> You never unregister it :)

Indeed, and one way to do that is to fix the double-registration of
dm9000.0.  Another way to avoid the other complaints is to remove
the unregistration in platform_register_devices().
