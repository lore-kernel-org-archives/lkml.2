Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1FGHE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:04:56 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:15634 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1FGHEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:04:55 -0400
Date: Tue, 7 Jun 2011 09:05:00 +0200
From: David Jander <david.jander@protonic.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does handle_simple_irq() require IRQ's to be disabled?
Message-ID: <20110607090500.4f060390@archvile>
In-Reply-To: <alpine.LFD.2.02.1106061816280.13964@ionos>
References: <20110606172840.322f09d4@archvile>
	<alpine.LFD.2.02.1106061816280.13964@ionos>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On Mon, 6 Jun 2011 18:18:41 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 6 Jun 2011, David Jander wrote:
> > 
> > Hi,
> > 
> > I am trying to implement/fix interrupt controller functionality in
> > gpio/pca953x.c, and for some reason which I don't understand, I need to
> > disable interrupts with local_irq_disable() before calling
> > generic_handle_irq(). This does not seem right.
> > If I follow the code of handle_simple_irq(), the handler function setup for
> > this IRQ, I get to handle_irq_event_percpu(), which has a
> > WARN_ONCE(!irqs_disabled(),...
> > This WARN is triggered, since nobody explicitly disables interrupts. Why?
> >  
> > generic_hanlde_irq() is called from a threaded interrupt handler of the
> > parent of this interrupt controller, and calling local_irq_disable() here
> > seems like a crime. What am I doing wrong?
> 
> handle_nested_irq() is your friend.

Thanks! This worked without disabling IRQ's.
One last question, though:

I set up the handler using irq_set_chip_and_handler(irq, ...,
handle_simple_irq);
>From the interrupt thread, I call handle_nested_irq(). Is it OK, that in this
case, the defined handler function (handle_simple_irq) is not used? Does this
still make sense? Wouldn't calling just irq_set_chip() be enough here (it
seems to work correctly)?

Best regards,

-- 
David Jander
Protonic Holland.
