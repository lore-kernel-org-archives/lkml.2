Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1JQHzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:55:49 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:39716 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1JQHzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:55:48 -0400
Date: Mon, 17 Oct 2011 09:55:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017095544.6bf76dea@de.ibm.com>
In-Reply-To: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<20111007070842.GA27555@hostway.ca>
	<20111007174848.GA11011@hostway.ca>
	<1318010515.398.8.camel@twins>
	<20111008005035.GC22843@hostway.ca>
	<1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011 18:39:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That stupid definition of cputime_add() has apparently existed as-is
> since it was introduced in 2005. Why do we have code like this:
> 
>     times->utime = cputime_add(times->utime, t->utime);
> 
> instead of just
> 
>     times->utime += t->utime;
> 
> which seems not just shorter, but more readable too? The reason is not
> some type safety in the cputime_add() thing, it's just a macro.
> 
> Added Martin and Ingo to the discussion - Martin because he added that
> cputime_add in the first place, and Ingo because he gets the most hits
> on kernel/sched_stats.h. Guys - you can see the history on lkml.

I introduced those macros to find all the places in the kernel operating
on a cputime value. The additional debug patch defined cputime_t as a
struct which contained a single u64. That way I got a compiler error
for every place I missed.

The reason for the cputime_xxx primitives has been my fear that people
ignore the cputime_t type and just use unsigned long (as they always
have). That would break s390 which needs a u64 for its cputime value.
Dunno if we still need it, seems like we got used to using cputime_t.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

