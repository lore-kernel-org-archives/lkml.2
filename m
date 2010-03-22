Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0CVGEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:04:07 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:56573 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab0CVGEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:04:05 -0400
Date: Mon, 22 Mar 2010 06:03:43 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, <joachim.eastwood@jotron.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] genirq: introduce IRQF_ALLOW_NESTED flag for
 request_irq()
Message-ID: <20100322060343.3487e32c@taxman.wild-wind.fr.eu.org>
In-Reply-To: <927ea285bd0c68934ddae1a47e44a9ba@localhost>
References: <201003112209.o2BM91oQ013581@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1003132039110.22855@localhost.localdomain>
	<927ea285bd0c68934ddae1a47e44a9ba@localhost>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: maz@misterjones.org, tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu, joachim.eastwood@jotron.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 09:36:59 +0100
Marc Zyngier <maz@misterjones.org> wrote:

> On Sat, 13 Mar 2010 20:56:19 +0100 (CET), Thomas Gleixner
> <tglx@linutronix.de> wrote:
> 
> Hi Thomas,
> 
> > In general I have no objections, but one thing bothers me. We have no
> > way to let a driver know whether it runs in a nested threaded context
> > or in hard irq context. There might be (future) drivers which would be
> > happy to know that to apply context dependent optimizations etc.
> > 
> > What about a new function which solves your problem and returns that
> > information ? Something along the line:
> > 
> > int request_any_context_irq(....)
> > {
> > 	...
> > 	if (desc->status & IRQ_NESTED_THREAD) {
> > 	   	ret = request_threaded_irq();
> > 		if (!ret)
> > 			ret = IRQ_IS_NESTED;
> > 
> > 	} else {
> > 		.....
> > 			ret = IRQ_IS_NONTHREADED;
> > 		else
> > 			ret = IRQ_IS_THREADED;
> > 
> > 	}
> > 	...
> > 	return ret;
> > }
> > 
> > You get the idea, right ?
> > 
> > It's a bit more code, but less magic and more flexible for further use
> > cases.
> 
> What about the attached (sorry, webmail crap) patch? I deliberately left
> IS_THREADED out of the picture, as I have the feeling that the caller has
> to know if it really wants a threaded handler, and I couldn't see a way to
> guess its intent.
> 
> Please note that this patch has only been compile-tested, as I'm traveling
> for the rest of the week and don't have access to my boards.
> 
> Thanks,
> 
>         M.

Any comment on this?

Thanks,

	M.
-- 
I'm the slime oozin' out from your TV set...
