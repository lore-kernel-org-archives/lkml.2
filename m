Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1BWXyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:54:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:56448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1BWXyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:54:50 -0500
Date: Wed, 23 Feb 2011 15:17:55 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How important is it that tty_write_room doesn't lie?
Message-ID: <20110223231755.GA19415@suse.de>
References: <4D656679.90907@freescale.com>
 <20110223202915.GB9081@suse.de>
 <4D657292.6000106@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D657292.6000106@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 02:48:18PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > I think that people don't normally hit this as the console code isn't
> > used as a tty and a console at the same time, right?
> 
> That's another thing I never understood.  It's rare for a driver to support both
> the console and tty layers.  The serial core driver does that, but I can't find
> any other examples.  I would think that a driver would support both interfaces,
> because both are needed.  Simplistically, printk --> console, and printf -->
> tty.  When would ever want user-space support but not kernel support?

usb-serial devices usually never care about kernel support, and as Ted
posted, the majority of people use serial ports for modems.

> > How big is your buffer in your FIFO?  
> 
> The FIFO can vary, but it's probably at least 2KB it size.  At least, we hope to
> able to set it to that size in the field.  Currently, we set it to 4KB.

That's huge.

> > Can you always just say you have a
> > smaller ammount in order to try to work around the tty layer trying to
> > send you a few extra bytes at times?
> 
> How many bytes extra?  I don't even have any hard evidence that this is actually
> happening, but a customer is reporting lost characters and this the only thing
> we could come up with.

With such a large FIFO, I would be very surprised for overruns like
this, unless you are working at very slow baud rates.

> The serial drivers seem to have a software FIFO for the TTY interface, but none
> for the console interface.  uart_write() puts the data into an internal circular
> buffer, and then calls uart_start().  serial8250_console_write(), however,
> writes directly to the hardware.  Is this what I should be doing?

Try it out and see what happens :)

thanks,

greg k-h
