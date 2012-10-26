Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2JZJYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:24:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38404 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2JZJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:24:27 -0400
Date: Fri, 26 Oct 2012 11:24:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
Message-ID: <20121026092421.GB628@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins>
 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
 <1351241389.12171.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241389.12171.45.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-10-25 at 15:26 -0700, Linus Torvalds wrote:
> > it's the *rest* of the "u128" math I really object to. I also wonder
> > about the u64xu64 math case for SCHED_DEADLINE, because I assume that
> > it doesn't actually end up using the 128-bit result in that form, but
> > scales it down again some way? 
> 
> No, it does a compare on two u128, so it doesn't loose any 
> precision. If it were to scale down again and loose precision 
> I'd agree with you that introducing the u128 stuff is 
> pointless.
> 
> The point is (as mentioned in the comments below) overflowing 
> an actual u64 is rare, however since some of this 
> (specifically the dl_{runtime,deadline} parameters) is user 
> specified, we have to assume we will overflow.

So can we control this by restricting the users and avoiding the 
overflow?

A 2^64 result should be a *huge* amount of space already for 
just about anything.

Thanks,

	Ingo
