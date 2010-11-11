Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0KKSFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:05:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab0KKSFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:05:15 -0500
Date: Thu, 11 Nov 2010 19:04:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101111180456.GA27803@elte.hu>
References: <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu>
 <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal>
 <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com>
 <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net>
 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289489200.11397.21.camel@maggy.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> I _finally_ got back to this yesterday, and implemented your suggestion, though 
> with a couple minor variations.  Putting the autogroup pointer in the signal 
> struct didn't look right to me, so I plugged it into the task struct instead.  I 
> also didn't refcount taskgroups, wanted the patchlet to be as self-contained as 
> possible, so refcounted the autogroup struct instead.  I also left group movement 
> on tty disassociation in place, but may nuke it.
> 
> The below has withstood an all night thrashing in my laptop with a PREEMPT_RT 
> kernel, and looks kinda presentable to me, so...

The patch and the diffstat gives me warm fuzzy feelings:

> ---
>  Documentation/kernel-parameters.txt |    2 
>  drivers/char/tty_io.c               |    4 
>  include/linux/sched.h               |   20 ++++
>  init/Kconfig                        |   12 ++
>  kernel/exit.c                       |    1 
>  kernel/sched.c                      |   28 ++++--
>  kernel/sched_autogroup.c            |  161 ++++++++++++++++++++++++++++++++++++
>  kernel/sched_autogroup.h            |   10 ++
>  kernel/sysctl.c                     |   11 ++
>  9 files changed, 241 insertions(+), 8 deletions(-)

Very well contained, minimally invasive to anything else!

( Noticed only one very small detail: sched_autogroup.h has an illness of lack of 
  newlines which makes it a bit hard to read - but this is cured easily. )

I'll test and apply this patch to the scheduler tree, so if anyone has objections 
please holler now :-)

Linus, does this look OK to you too, can i add your Acked-by?

Thanks,

	Ingo
