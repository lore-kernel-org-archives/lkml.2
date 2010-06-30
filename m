Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab0F3JMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:12:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0F3JML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:12:11 -0400
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
	 <1277885133.1868.71.camel@laptop>
	 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 11:11:56 +0200
Message-ID: <1277889116.1868.95.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 10:00 +0100, Jan Beulich wrote:
> >>> On 30.06.10 at 10:05, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
> >> Add optional (alternative instructions based) callout hooks to the
> >> contended ticket lock and the ticket unlock paths, to allow hypervisor
> >> specific code to be used for reducing/eliminating the bad effects
> >> ticket locks have on performance when running virtualized.
> > 
> > Uhm, I'd much rather see a single alternative implementation, not a
> > per-hypervisor lock implementation.
> 
> How would you imaging this to work? I can't see how the mechanism
> could be hypervisor agnostic. Just look at the Xen implementation
> (patch 2) - do you really see room for meaningful abstraction there?

I tried not to, it made my eyes bleed.. 

But from what I hear all virt people are suffering from spinlocks (and
fair spinlocks in particular), so I was thinking it'd be a good idea to
get all interested parties to collaborate on one. Fragmentation like
this hardly ever works out well.

> Not the least that not every hypervisor may even have a way to
> poll for events (like Xen does), in which case a simple yield may be
> needed instead.

No idea what you're talking about, I think you assume I actually know
something about Xen or virt..

> >> For the moment, this isn't intended to be used together with pv-ops,
> >> but this is just to simplify initial integration. The ultimate goal
> >> for this should still be to replace pv-ops spinlocks.
> > 
> > So why not start by removing that?
> 
> Because I wouldn't get around to test it within the time constraints
> I have?

I'd say that removing basically dead code (the paravirt spinlocks) the
code you'd be changing was easier to follow and thus your patches would
be done quicker?

> >> +#define ALTERNATIVE_TICKET_LOCK \
> > 
> > But but but, the alternative isn't a ticket lock..!?
> 
> ??? Of course it is. 

Ah, right, after looking a bit more at patch 2 I see you indeed
implement a ticket like lock. Although why you need both a ticket and a
FIFO list is beyond me.

