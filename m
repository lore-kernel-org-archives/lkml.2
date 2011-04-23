Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1DWNpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:45:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46109 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1DWNpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:45:35 -0400
Date: Sat, 23 Apr 2011 15:45:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110423154528.4145698d@endymion.delvare>
In-Reply-To: <BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
References: <20110419145303.111aead7@endymion.delvare>
	<BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tue, 19 Apr 2011 08:44:29 -0600, Grant Likely wrote:
> On Tue, Apr 19, 2011 at 6:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > I need this to handle SMBus multiplexing on my Asus Z8NA-D6 board. It
> > has an ICH10, I've added support for older ICH chips in case someone
> > needs it, as it was relatively simply to do that.
>
> Your timing is impeccable.  You're getting caught up in the big gpio
> driver consolidation.  :-)
> 
> Most gpio drivers end up looking pretty darn similar.  Instead of
> writing the same types of drivers over and over again, the new
> approach is to try and consolidate the mmio drivers down to using
> basic_mmio_gpio.c.
> 
> In this particular case, you've got a PCI device which looks to be
> going into config space to get some information about how the chip is
> layed out.  What I would do is keep your existing pci probe & remove
> hooks, but use them to create and register child basic_mmio_gpio
> platform_devices for each gpio bank.

I can see there are still discussions going on with regards to
basic_mmio_gpio. To be honest, I don't have any opinion on this. My
only concern is that I have driver code which appears to work well
enough for me and I would like it to be merged in kernel 2.6.40.

So my questions are as follows: what do I get to do for it to happen?
If there a chance that my driver as it currently exists (i.e. not using
basic_mmio_gpio) gets reviewed and merged? Or do I have to rewrite it
using basic_mmio_gpio to get a chance?

I can't see any driver currently relying on basic_mmio_gpio in the
kernel tree. Why is that, and why would my driver have to, if none else
did yet?

And a technical question (which makes me feel somewhat ashamed as I
guess I really should know the answer): the ICH is using I/O ports for
GPIO control, not a memory mapping. Would basic_mmio_gpio work for it
still?

Thanks,
-- 
Jean Delvare
