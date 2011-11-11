Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1KKHIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 02:08:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1KKHIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 02:08:06 -0500
Date: Fri, 11 Nov 2011 08:06:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] TSC sched_clock overflow workaround
Message-ID: <20111111070615.GA14347@elte.hu>
References: <1320987192.15791.13.camel@js-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320987192.15791.13.camel@js-netbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <johnstul@us.ibm.com> wrote:

> Hey Thomas, Ingo,
> 	I thought Peter had sent this on, but apparently its not landed yet, so
> I wanted to make sure you got it.
> 
> After ~208 days, the sched_clock multiplication overflows and 
> causes some false positives in the softlockup watchdog. I don't 
> think there are any actual panics going on, as an earlier related 
> div by zero issue was already fixed. However, the false positives 
> do continue to worry folks.
> 
> We still need a proper fix, which will probably be in part making 
> sched_clock do periodic accumulation, as well as possibly changing 
> users of sched_clock (like the softlockup watchdog) use timekeeping 
> timestamps rather then sched_clock.

I'd *much* rather see a real fix for this than an ugly workaround 
that disables a very real speedup.

Thanks,

	Ingo
