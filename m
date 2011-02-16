Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1BPIg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:36:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BPIgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:36:23 -0500
Date: Wed, 16 Feb 2011 09:35:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, simoneau@ele.uri.edu,
        will.newton@gmail.com, hpa@zytor.com, matt@console-pimps.org,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110216083542.GE16529@elte.hu>
References: <4D59B891.8010300@zytor.com>
 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
 <20110215211123.GA3094@ele.uri.edu>
 <20110215.132702.39199169.davem@davemloft.net>
 <1297808418.2460.9.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297808418.2460.9.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2011-02-15 at 13:27 -0800, David Miller wrote:
> > From: Will Simoneau <simoneau@ele.uri.edu>
> > Date: Tue, 15 Feb 2011 16:11:23 -0500
> > 
> > > Note how the cache and cache coherence protocol are fundamental parts of this
> > > operation; if these instructions simply bypassed the cache, they *could not*
> > > work correctly - how do you detect when the underlying memory has been
> > > modified?
> > 
> > The issue here isn't L2 cache bypassing, it's local L1 cache bypassing.
> > 
> > The chips in question aparently do not consult the local L1 cache on
> > "ll" instructions.
> > 
> > Therefore you must only ever access such atomic data using "ll"
> > instructions.
> 
> Note that it's actually a reasonable design choice to not consult the L1
> in these case .... as long as you invalidate it on the way. That's how
> current powerpcs do it afaik, they send a kill to any matching L1 line
> along as reading from the L2. (Of course, L1 has to be write-through for
> that to work).

Just curious: how does this work if there's an interrupt (or NMI) right after the 
invalidate instruction but before the 'll' instruction? The IRQ/NMI may refill the 
L1. Or are the two instructions coupled by hw (they form a single instruction in 
essence) and irqs/NMIs are inhibited inbetween?

Thanks,

	Ingo
