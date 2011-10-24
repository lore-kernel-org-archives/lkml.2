Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1JXIIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:08:41 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:43454 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1JXIIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:08:39 -0400
Date: Mon, 24 Oct 2011 10:08:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111024100832.7fcfefdd@de.ibm.com>
In-Reply-To: <CA+55aFyybeTZvzSU4L=hV1Y6+wXn2ZkuZF9R+vAj6MRVC+MmBQ@mail.gmail.com>
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
	<20111024094817.30c01c9b@de.ibm.com>
	<CA+55aFyybeTZvzSU4L=hV1Y6+wXn2ZkuZF9R+vAj6MRVC+MmBQ@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 09:51:09 +0200
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Oct 24, 2011 at 9:48 AM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> >
> > These types are still there because cputime_t can be u32 or u64. E.g. this
> >
> >  timer->expires.cpu = 0;
> >
> > will give the following sparse warning
> >
> >  kernel/posix-cpu-timers.c:463:46: warning: implicit cast to nocast type
> 
> Ok, we should probably special-case zero for that case too (we
> consider zero to be very special - it's not only the NULL pointer, but
> 0 is special for the bitwise types etc). So this is very arguably a
> sparse issue: casting zero is special.

Ok, cool. In that case I'll cook up a patch without cputime_t & cputime64_t
and put it on the cputime branch on git390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

