Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1FGIzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:55:05 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:16073 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1FGIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:55:03 -0400
Date: Tue, 7 Jun 2011 10:55:08 +0200
From: David Jander <david.jander@protonic.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does handle_simple_irq() require IRQ's to be disabled?
Message-ID: <20110607105508.1f3033fa@archvile>
In-Reply-To: <alpine.LFD.2.02.1106071016490.11814@ionos>
References: <20110606172840.322f09d4@archvile>
	<alpine.LFD.2.02.1106061816280.13964@ionos>
	<20110607090500.4f060390@archvile>
	<alpine.LFD.2.02.1106071016490.11814@ionos>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Thomas,

On Tue, 7 Jun 2011 10:26:26 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 7 Jun 2011, David Jander wrote:
> > On Mon, 6 Jun 2011 18:18:41 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > handle_nested_irq() is your friend.
> > 
> > Thanks! This worked without disabling IRQ's.
> > One last question, though:
> > 
> > I set up the handler using irq_set_chip_and_handler(irq, ...,
> > handle_simple_irq);
> > From the interrupt thread, I call handle_nested_irq(). Is it OK, that in
> > this case, the defined handler function (handle_simple_irq) is not used?
> > Does this still make sense? Wouldn't calling just irq_set_chip() be enough
> > here (it seems to work correctly)?
> 
> It should be enough. Though you should mark the demuxed interrupts
> with irq_set_nested_thread(irqnr, true). That avoids that you create
> extra threads for the demuxed interrupts which are never used.

Cool! Now the disturbingly big list of kernel threads is gone :-)

Thanks a lot!

-- 
David Jander
Protonic Holland.
