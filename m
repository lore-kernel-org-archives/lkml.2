Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0K3WGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:06:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0K3WGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:06:21 -0500
Date: Tue, 30 Nov 2010 22:05:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Message-ID: <20101130220550.GD8521@n2100.arm.linux.org.uk>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com> <201011301621.48140.arnd@arndb.de> <20101130184049.GC8521@n2100.arm.linux.org.uk> <20101130184834.GA16055@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130184834.GA16055@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:48:34AM -0800, Greg KH wrote:
> On Tue, Nov 30, 2010 at 06:40:49PM +0000, Russell King - ARM Linux wrote:
> > There's lots of static devices, not only platform devices, in the ARM
> > tree.  It's going to be a hell of a lot of work to fix this all up
> > properly.
> 
> I agree, it's been abused for many years this way :(

I don't agree that it is abuse - it was something explicitly allowed by
the original device model design by Patrick, with the condition that
such a device was never unregistered.  That's exactly the way we treat
these devices.

What I'm slightly concerned about is that this is going to needlessly
bloat the kernel - we're going to have to find some other way to store
this information, and create devices from that - which means additional
code to do the creation, and data structures for it to create these from.
There will be additional wastage from kmalloc as kmalloc doesn't allocate
just the size you ask for, but normally a power of two which will contain
the size.

That could potentially mean that as the device structure is 216 bytes,
kmalloc will use the 256 byte allocation size, which means a wastage of
40 bytes per device structure.  On top of that goes the size of
resources with the allocation slop on top for that, and then there's
another allocation for the platform data.

Has anyone considered these implications before making this choice?
