Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1JXHs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:48:27 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:32938 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1JXHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:48:24 -0400
Date: Mon, 24 Oct 2011 09:48:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111024094817.30c01c9b@de.ibm.com>
In-Reply-To: <20111023113422.GD5156@elte.hu>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<20111007070842.GA27555@hostway.ca>
	<20111007174848.GA11011@hostway.ca>
	<1318010515.398.8.camel@twins>
	<20111008005035.GC22843@hostway.ca>
	<1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	<20111020163609.16816e78@de.ibm.com>
	<20111023113422.GD5156@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011 13:34:22 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > +#define cputime_zero			((__force cputime_t) 0ULL)
> > +#define cputime64_zero			((__force cputime64_t) 0ULL)
> 
> Hm, why are these still needed?
> 
> This:
> 
> 		if (*newval == cputime_zero)
> 			return;
> 
> Could be written as the much simpler:
> 
> 		if (!*newval)
>  			return;
> 
> with no ill effect that i can see.

These types are still there because cputime_t can be u32 or u64. E.g. this

  timer->expires.cpu = 0;

will give the following sparse warning

  kernel/posix-cpu-timers.c:463:46: warning: implicit cast to nocast type

if you architecture happens to have a u64 as cputime_t.
We could get rid of cputime64_t as it always should be a u64. To keep
things symmetrical I choose to keep both defines.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

