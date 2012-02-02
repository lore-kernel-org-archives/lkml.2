Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2BBHtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:49:24 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:25512 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2BBHtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:49:23 -0500
Date: Thu, 2 Feb 2012 08:49:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20120202084909.2adf0f50@endymion.delvare>
In-Reply-To: <20120202023129.GA19535@ericsson.com>
References: <20110419145303.111aead7@endymion.delvare>
	<20120202023129.GA19535@ericsson.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 18:31:29 -0800, Guenter Roeck wrote:
> On Tue, Apr 19, 2011 at 08:53:03AM -0400, Jean Delvare wrote:
> > I need this to handle SMBus multiplexing on my Asus Z8NA-D6 board. It
> > has an ICH10, I've added support for older ICH chips in case someone
> > needs it, as it was relatively simply to do that.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > Note 1: On early ICH chips, some pins are exclusively inputs or
> > outputs. The driver doesn't currently enforce this.
> > 
> > Note 2: I'm not yet sure if we want a module alias for this driver.
> > Many systems have the device but only a few of them will need the
> > driver (and an ACPI resource conflict will be reported for many
> > others, especially laptops I suspect.) So it might make more sense to
> > let consumer drivers request the i801_gpio driver as needed (which they
> > should do anyway, as you can't assume udev is always up and running on
> > all systems.)
> > 
> > Note 3: This is my first GPIO driver, so while it works fine for me, it
> > might not be perfect. I welcome comments on how to improve it.
> > 
> >  drivers/gpio/Kconfig     |    7
> >  drivers/gpio/Makefile    |    1
> >  drivers/gpio/i801_gpio.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 440 insertions(+)
>
> Did this or an alternate patch for gpio support on the recent Intel ICHs go anywhere ?
> 
> I found another patch which is using a different approach, but I don't see anything
> in the latest kernel.

I don't think any driver made it into the kernel, at least I can't find
any in 3.3-rc2 nor linux-next. I'm not surprised, as neither driver was
using the MFD framework while this would really be the right thing to
do here. I never took the time to convert my driver to MFD and
apparently Peter did not either. This is still on my to-do list but you
know how long it is. If anyone is faster than me at getting the code is
a shape suitable for upstream, I'll be happy to help with review and
testing.

-- 
Jean Delvare
