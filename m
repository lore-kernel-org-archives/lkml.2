Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1KVQFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:05:52 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45552 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab1KVQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:05:51 -0500
Date: Tue, 22 Nov 2011 17:05:38 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, mst@redhat.com,
        Greg KH <gregkh@suse.de>, tglx@linutronix.de,
        linux-pci@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111122160538.GB15508@local>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
 <20111118220849.GA25205@suse.de>
 <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
 <20111121173620.GA5028@suse.de>
 <20111121181724.GB12011@local>
 <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:24:17AM -0500, Jean-Francois Dagenais wrote:
[...]
> >> 
> >> So please submit a patch, that will make it easier to help you out.
> > 
> > Yes, please do. The more different drivers we have under /drivers/uio, the
> > better. Didn't you use one of the existing drivers as a template for yours?
> Of course, and I am making contributions to the kernel as well (ds1wm,  w1_ds2408,
> ad714x, and more to be merged contribs to blackfin list drivers) because I strongly
> believe in the community aspect of Linux.

I don't doubt that, sorry if I gave that impression. My only concern is that in the
past few years (UIO is in mainline since 2.6.23) less than 1% of the drivers ever
appeared on LKML. That means that, with quite high probability, everybody writing
a new UIO driver will reinvent the wheel. Over the years, I met lots of people
(e.g. at conferences) who wrote a UIO driver for all kinds of devices, even with
different sorts of DMA handling. All of them said "oh, my driver is of no interest
to the public", and never posted it although I strongly encouraged them to do so.

Consequently, everybody has to do the same work again and again, which is just a
waste of rare engineering powers.

> 
> So in the spirit of making the driver more generic, I would like to make this patch
> something along the lines of a generic uio/pci based large DMA acquisition device
> driver. Or maybe even complementing the existing uio_generic_pci.c?

Adding DMA requires changes to the UIO core to be something more than a crude
workaround. Probably a new device like /dev/uio_dma0 for a /dev/uio0. Feel free
to make suggestions.

> 
> The problem is that there are device specific aspects that the "generic" driver would
> need to take into account, e.g. to map BARx or not, or in our case, there are MFDs
> embedded in the firmware (xilinx's ds1wm core, and soon, xilinx's spi core). Furthermore,
> I want the FPGA to be an irq expander since the cores generate interrupts, and a
> couple of balls on the FPGA are irq signals from external i2c chips.

That should not be much of a problem, unless the FPGA generates more than one
physical interrupt.

> 
> I don't yet see any way to specify like a setup callback function that could reach a
> platform module when uio_pci_generic is probing.
> 
> I am thinking this through as I write here...
> 
> My other persona (C++ programmer) suggests that conceptually, uio_pci_generic is
> a "base class" and the other more firmware specific items would be in a derived module.
> In that sense, maybe uio_pci_generic could export it's symbols? So it can be used as
> uio core functionnality?
> 
> So I would still have a module which would contain the specific MFD registration and IRQ
> functionnality, but the BARx and large DMA mapping would reside in uio_pci_generic...

If we want more UIO core functionality, we should integrate it into the UIO core,
and not just hack a driver.

Thanks,
Hans

