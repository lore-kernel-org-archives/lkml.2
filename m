Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1DCOHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 10:07:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32804 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1DCOHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 10:07:54 -0400
Date: Sun, 3 Apr 2011 15:07:50 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110403140750.GB5670@pulham.picochip.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403120344.GA1540@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Sun, Apr 03, 2011 at 04:03:44PM +0400, Anton Vorontsov wrote:
> > > I'm not
> > > hugely thrilled with the current method that the driver uses to define
> > > the register locations (using named resources).  My instinct would be
> > > to use a single register resource region with offsets for each
> > > register type defined from the base of it, but Anton can probably fill
> > > us in on the reason that approach was used.
> 
> Well, I did it that way because you don't have to pass the offsets via
> platform data (you don't need platform data most of the time, i.e. if
> you use dynamic bases).

Well I'm happy to give it a go for some more complex chips with multiple 
banks but I'm not sure how to accomplish this without platform data.  My 
first idea would be to have something like:

struct mmio_gpio_bank {
	unsigned int		ngpio;
	unsigned long		set_offs;
	unsigned long		clr_offs;
	unsigned long		dout_offs;
	unsigned long		din_offs;
	unsigned long		dir_offs;
};

struct mmio_gpio_pdata {
	size_t			bus_width_bits;
	int			gpio_base;
	unsigned int		nr_banks;
	struct mmio_gpio_bank	banks[];
};

and have one iomem resource for the whole controller.  This allows us to 
cope with the controllers where each bank has a different number of GPIO 
pins but I'm not sure how device tree friendly it is.  If there's a 
better way then please let me know and I'll give it a go, though
at first it does need to be able to work without device tree support.

Looking at some of the different IRQ demuxing schemes they seem to vary 
quite a bit so I'm not sure how to handle that in a relatively generic 
way but perhaps that can come later.

Jamie
