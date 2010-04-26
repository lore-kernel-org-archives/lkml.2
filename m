Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0DZO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:57:08 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35700 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0DZO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:57:05 -0400
Date: Mon, 26 Apr 2010 16:57:00 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
Message-ID: <20100426145700.GP30801@buzzloop.caiaq.de>
References: <op.vbrfqdznfxrvh1@pikus>
 <20100426141605.GO30801@buzzloop.caiaq.de>
 <op.vbrxsrw07p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vbrxsrw07p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 04:42:17PM +0200, Michał Nazarewicz wrote:
> >On Mon, Apr 26, 2010 at 10:29:05AM +0200, Michał Nazarewicz wrote:
> >>I need to create an USB gadget with drivers for Windows included
> >>"on board".  In particular, when the gadget is connected to Windows
> >>host it is detected as mass storage and mounted drive include the
> >>drivers.  However, when the drivers are installed, it is detected
> >>as some other device.
> >>
> >>Now, it seems that a simple composite device with two configurations
> >>is enough -- the first containing mass storage and the second other
> >>functions.  My tests show that Windows manages to set the first
> >>configuration and detect the mass storage interface.
> 
> On Mon, 26 Apr 2010 16:16:05 +0200, Daniel Mack <daniel@caiaq.de> wrote:
> >Why are you using two configurations on this device instead of one
> >configuration with two interfaces? Interfaces are not allowed to share
> >endpoints within one configuration, so they can be used simultaniously.
> 
> Ideally, I would like to use two configurations on its own just like
> g_ether that is one configuration with RNDIS and some other functionality
> and another with CDC ECM and some other functionality.

If you do that, the configuration which is chosen eventually purely
relies on the driver stack and/or user setting.

> It seems however that such gadgets are not properly detected by Windows
> as composite devices and thus require a driver (I imagined a single INF
> should be enough but now I'm not even sure of that) and so I tried adding
> another configuration with just the mass storage function and this seems
> to be handled correctly.

Maybe Windows just selects the interface it has a driver for already?
On the other hand, that would be giving a hint of some sort of
intelligence, which I can't believe either as their USB stack is totally
screwed. Not a single detail in its implementation seems to make any
sense.

> Now, even if I were to ignore the other RNDIS/ECM multiple personality
> disorder and sticking to a single configuration with RNDIS there's still
> an issue (or challenge if you will) of a "Found new driver" dialog
> popping up like crazy when the device is inserted but the drivers from
> mass storage didn't have time to install.

Yeah, great technology. Even if you install the driver (which you have
to do even for USB sticks), you'll be prompted for the same action again
once you dare to plug in the device in some other port. This is because
Windows registeres its USB drivers under the USB host port in the device
tree, and hence once the same device is connected anywhere else, it's
completely new to the system again.

> This is especially true since
> it was my experience that RDNIS is able to freeze Windows if it's not
> the first interface.

Sic!

> So in the end, I'm looking for a method to get a device that can be
> plugged in and report as mass storage with drivers but when drivers
> are installed report as something else.  I know it is possible since
> I encountered several devices that do exactly that.

Are you sure they don't do exactly that by running two interfaces in
the same configuration? In theory, Windows should (as any other OS
as well) recognize the interfaces it has drivers for and handle them
automatically (after this stupid wizard tortured you of course). And if
there is an interface that needs special attention, you will need to
install a driver for it. But I haven't dealt with Windows for a longer
time, so I can only give hints at this point.

Daniel

