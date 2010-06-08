Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0FHHXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:23:52 -0400
Received: from zmta01.cabocomm.dk ([193.200.44.52]:59785 "EHLO zmta01.irigo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab0FHHXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:23:50 -0400
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
From: Esben Haabendal <eha@doredevelopment.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Esben Haabendal <esbenhaabendal@gmail.com>, linuxppc-dev@ozlabs.org,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1006080853220.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	 <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	 <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	 <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
	 <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
	 <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
	 <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
	 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
	 <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
	 <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain>
	 <1275914058.2818.8.camel@eha.doredevelopment.dk>
	 <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain>
	 <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
	 <alpine.LFD.2.00.1006080853220.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: =?ISO-8859-1?Q?Dor=E9Development?= ApS
Date: Tue, 08 Jun 2010 09:23:40 +0200
Message-ID: <1275981820.2870.74.camel@eha.doredevelopment.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 08:58 +0200, Thomas Gleixner wrote: 
> On Mon, 7 Jun 2010, Esben Haabendal wrote:
> 
> > On Mon, Jun 7, 2010 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Maybe you understand now, why I was pretty sure upfront, that your
> > > approach was wrong even without knowing all the gory details ? :)
> > 
> > I understand.  There is a better solution, which is to use threaded
> > interrupts where needed.
> 
> FWIW, it just occured to me, that the only reason why the
> disable_irq_nosysnc() trips up on the in_atomic() check is your
> fiddling with the nested irq dispatcher. 
> 
> If you just would have changed the phy driver to
> request_irq_any_context() it would have simply worked out of the box,
> without any need to remove buslock and changing genirq code at all.
> 
> That would not give you the advantage of getting rid of the two
> additional I2C transfers, but that's nn optimzation not a functional
> requirement.

Now, that is good news. Thanks!

/Esben

