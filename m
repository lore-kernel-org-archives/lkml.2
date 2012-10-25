Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946025Ab2JYNr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:47:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:52636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945936Ab2JYNrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:47:55 -0400
Message-ID: <1351172849.12171.10.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 25 Oct 2012 15:47:29 +0200
In-Reply-To: <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 16:18 -0700, Linus Torvalds wrote:
> On Wed, Oct 24, 2012 at 2:53 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> > Grow rudimentary u128 support without relying on gcc/libgcc.
> 
> I missed the part where somebody explains why and what needs this?
> It's going to be very expensive indeed on some platforms, so the fact
> that it is *sometimes* cheap doesn't necessarily imply it should ever
> be used.
> 
> So please, explain what the pressing need is that is so worthwhile
> that this is worth it. Maybe it was in a 00/16 cover letter, but not
> only was that not sent out to the people who got 01, you'd still want
> it in the commit message. 

There's two use cases:

 1) the proposed SCHED_DEADLINE needs to do some u64xu64 math, it
    ends up having to multiply a deadline (in usec) with runtime (also
    in usec).

 2) the infrastructure adds mul_u64_u32_shr(), which is something we
    do a lot of with all the time manipulation, apply a multiplier to
    some u64 clock value.

    We can do better on some archs than we can in generic, so this
    interface could give a win there.


But yes, in general people should be very very reluctant to use this.
