Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0F3JA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:00:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:58020 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0F3JAG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 05:00:06 -0400
Message-Id: <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 10:00:29 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <jeremy.fitzhardinge@citrix.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
In-Reply-To: <1277885133.1868.71.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 10:05, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
>> Add optional (alternative instructions based) callout hooks to the
>> contended ticket lock and the ticket unlock paths, to allow hypervisor
>> specific code to be used for reducing/eliminating the bad effects
>> ticket locks have on performance when running virtualized.
> 
> Uhm, I'd much rather see a single alternative implementation, not a
> per-hypervisor lock implementation.

How would you imaging this to work? I can't see how the mechanism
could be hypervisor agnostic. Just look at the Xen implementation
(patch 2) - do you really see room for meaningful abstraction there?
Not the least that not every hypervisor may even have a way to
poll for events (like Xen does), in which case a simple yield may be
needed instead.

>> For the moment, this isn't intended to be used together with pv-ops,
>> but this is just to simplify initial integration. The ultimate goal
>> for this should still be to replace pv-ops spinlocks.
> 
> So why not start by removing that?

Because I wouldn't get around to test it within the time constraints
I have?

>> +config ENLIGHTEN_SPINLOCKS
> 
> Why exactly are these enlightened? I'd say CONFIG_UNFAIR_SPINLOCKS would
> be much better.

The naming certainly isn't significant to me. If consensus can be
reached on any one name, I'll be fine with changing it. I just don't
want to play ping pong here.

>> +#define X86_FEATURE_SPINLOCK_YIELD (3*32+31) /* hypervisor yield interface 
> */
> 
> That name also sucks chunks, yield isn't a lock related term.

Not sure what's wrong with the name (the behavior *is* a yield of
some sort to the underlying scheduler). But again, any name
acceptable to all relevant parties will be fine with me.

>> +#define ALTERNATIVE_TICKET_LOCK \
> 
> But but but, the alternative isn't a ticket lock..!?

??? Of course it is. Or do you mean the macro doesn't
represent the full lock operation? My reading of the name is that
this is the common alternative instruction sequence used in a lock
operation. And just as above - I don't care much about the actual
name, and I'll change any or all of them as long as I'm not going to
be asked to change them back and forth.

Jan

