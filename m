Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2EVItx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:49:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:36568 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2EVItu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:49:50 -0400
Date: Tue, 22 May 2012 10:49:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
In-Reply-To: <CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205221048140.3231@ionos>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com> <alpine.LFD.2.02.1205212308590.3231@ionos> <CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Ning Jiang wrote:

Please do not top post.

> Sorry that I do not make myself clear.
> 
> First, we should keep all the handle_*_irq behave in pretty much the
> same way even just for the beauty of it. Every interrupt disabled in
> suspend operation needs the ability to abort suspend if there is a
> pending irq.
> 
> Second, let's take look at a example:
> 
>               |
>        +---------+
>         |   INTC  |
>        +---------+
>                   |  GPIO_IRQ
>             +------------+
>              | gpio-exp  |
>             +------------+
>                |            |
>    GPIO0_IRQ  GPIO1_IRQ
> 
> In the above diagram, gpio expander has irq number GPIO_IRQ, it is
> connected with two sub GPIO pins, GPIO0 and GPIO1.
> 
> During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
> so that gpio expander driver can handle the sub irq GPIO0_IRQ and
> GPIO1_IRQ, and these two irqs themselves are handled by simple or
> nested irq in some drivers(typically gpio and mfd driver), if they are
> disabled during suspend, we want them to be able to abort suspend too.

Ok, that makes a lot of sense and should be part of the changelog, so
we know in a year from now why we did this change. Care to resend with
a fixed up changelog ?

Thanks,

	tglx
