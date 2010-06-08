Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0FHG7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:59:16 -0400
Received: from www.tglx.de ([62.245.132.106]:52592 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0FHG7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:59:15 -0400
Date: Tue, 8 Jun 2010 08:58:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <esbenhaabendal@gmail.com>
cc: Esben Haabendal <eha@doredevelopment.dk>, linuxppc-dev@ozlabs.org,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006080853220.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain> <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com> <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain> <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain> <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com> <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain> <1275914058.2818.8.camel@eha.doredevelopment.dk>
 <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain> <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Esben Haabendal wrote:

> On Mon, Jun 7, 2010 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Maybe you understand now, why I was pretty sure upfront, that your
> > approach was wrong even without knowing all the gory details ? :)
> 
> I understand.  There is a better solution, which is to use threaded
> interrupts where needed.

FWIW, it just occured to me, that the only reason why the
disable_irq_nosysnc() trips up on the in_atomic() check is your
fiddling with the nested irq dispatcher. 

If you just would have changed the phy driver to
request_irq_any_context() it would have simply worked out of the box,
without any need to remove buslock and changing genirq code at all.

That would not give you the advantage of getting rid of the two
additional I2C transfers, but that's nn optimzation not a functional
requirement.

Thanks,

	tglx
