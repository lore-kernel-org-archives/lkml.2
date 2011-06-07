Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1FGI0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:26:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:42012 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1FGI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:26:29 -0400
Date: Tue, 7 Jun 2011 10:26:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Jander <david.jander@protonic.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why does handle_simple_irq() require IRQ's to be disabled?
In-Reply-To: <20110607090500.4f060390@archvile>
Message-ID: <alpine.LFD.2.02.1106071016490.11814@ionos>
References: <20110606172840.322f09d4@archvile> <alpine.LFD.2.02.1106061816280.13964@ionos> <20110607090500.4f060390@archvile>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, David Jander wrote:
> On Mon, 6 Jun 2011 18:18:41 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > handle_nested_irq() is your friend.
> 
> Thanks! This worked without disabling IRQ's.
> One last question, though:
> 
> I set up the handler using irq_set_chip_and_handler(irq, ...,
> handle_simple_irq);
> From the interrupt thread, I call handle_nested_irq(). Is it OK, that in this
> case, the defined handler function (handle_simple_irq) is not used? Does this
> still make sense? Wouldn't calling just irq_set_chip() be enough here (it
> seems to work correctly)?

It should be enough. Though you should mark the demuxed interrupts
with irq_set_nested_thread(irqnr, true). That avoids that you create
extra threads for the demuxed interrupts which are never used.

Thanks,

	tglx
