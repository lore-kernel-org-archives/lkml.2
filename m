Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1CHMMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:12:24 -0500
Received: from www.tglx.de ([62.245.132.106]:50988 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab1CHMMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:12:21 -0500
Date: Tue, 8 Mar 2011 13:12:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Moving staging:iio over to threaded interrupts.
In-Reply-To: <4D76119A.2030100@cam.ac.uk>
Message-ID: <alpine.LFD.2.00.1103081304470.2787@localhost6.localdomain6>
References: <4D6FCC99.6090202@cam.ac.uk> <alpine.LFD.2.00.1103081055160.2787@localhost6.localdomain6> <4D76119A.2030100@cam.ac.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, Jonathan Cameron wrote:
> On 03/08/11 10:30, Thomas Gleixner wrote:
> > So now you can request the interrupts for your subdevices with
> > request_irq or request_threaded_irq.
> > 
> > You can also implement #1 this way, you just mark the sub device
> > interrupts as IRQ_NESTED_THREAD, and then call the handlers from the
> > main trigger irq thread.
> Hi Thomas,
> 
> One issue here that I'm not quite sure how to overcome is that the trigger to
> device mapping tends to be dynamic.  That is we quite often switch around
> what device is triggered by which trigger at runtime.  All done via text label
> matching via sysfs.

Was not aware of that.
 
> I guess we could maintain this by a spot of indirection and pool of interrupts per
> trigger (with compile time control on how many). Any other approaches come to mind?

That should work. You just need a function in the trigger
implementation which hands back an unused irq number to the device
when a trigger is installed for a device. Then the device calls
request[_threaded]_irq() on that irq number and all should work
magically.

Thanks,

	tglx

