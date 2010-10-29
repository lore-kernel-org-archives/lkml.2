Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab0J2P1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:27:23 -0400
Received: from www.tglx.de ([62.245.132.106]:36722 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0J2P1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:27:22 -0400
Date: Fri, 29 Oct 2010 17:26:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rabin Vincent <rabin@rab.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: handle shared irqs in handle_nested_irq()
In-Reply-To: <AANLkTinaTTqv3r0tWDOeZR5n=nHj5LybxAPf5uvUxpRh@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010291725370.2692@localhost6.localdomain6>
References: <1288288718-1188-1-git-send-email-rabin@rab.in> <alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6> <AANLkTinaTTqv3r0tWDOeZR5n=nHj5LybxAPf5uvUxpRh@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, Rabin Vincent wrote:

> On Fri, Oct 29, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 28 Oct 2010, Rabin Vincent wrote:
> >> Allow shared irqs to work when nested threads are used for handling
> >> threaded interrupts.
> >
> > Why do we want this ? handle_nested_irq() is called from a interrupt
> > demultiplexer, so why would we need shared interrupts for this ?
> 
> Threaded IRQ + handle_nested_irq() is used by I2C GPIO expander drivers
> like chained hander + generic_handle_irq() is used by on-chip GPIO
> drivers.  If two irq handlers are registered on an on-chip GPIO
> interrupt (because two devices are externally connected), it works.  If
> the handlers are instead registered on one of the expander's pins'
> interrupt, without this patch, only the handler registered first is
> called.

Have the hardware dudes not yet understood that shared interrupts are
a horrible idea ?

Sigh,

	tglx
