Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2APIgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:36:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2APIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:36:20 -0500
Date: Mon, 16 Jan 2012 09:36:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
Message-ID: <20120116083615.GB23622@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
 <20120116075639.GG15641@elte.hu>
 <CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Mon, Jan 16, 2012 at 1:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >
> >> /proc/schedstat's second field reflect to # of time context switch happened not # of times switched to the expired queue.
> >>
> >> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> >> ---
> >>
> >> diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
> >> index 1cd5d51..7d8e12c 100644
> >> --- a/Documentation/scheduler/sched-stats.txt
> >> +++ b/Documentation/scheduler/sched-stats.txt
> >> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
> >>       1) # of times sched_yield() was called
> >>
> >>  Next three are schedule() statistics:
> >> -     2) # of times we switched to the expired queue and reused it
> >> +     2) # of times context switch happened. This field is not utilized these
> >> +     days but kept for holding userspace tools integrity.
> >
> > if it's not used by anything but kept for the ABI then we should
> > not put context switch number in there, but always keep it zero,
> > right?
> >
>
> Yes, quite right. It is a bit confusing. Anyone might have 
> think that context switch numbers are 0. So, instead of saying 
> "# of times context switch happened", we can say, "This field 
> has been kept for ABI integrity". Right?

Yes - but we should also change it to export a value of zero. 
The field is a legacy 'array expirations' field, and as such it 
should be zero.

Thanks,

	Ingo
