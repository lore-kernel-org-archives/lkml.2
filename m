Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865Ab2COMmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:42:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2COMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:42:46 -0400
Date: Thu, 15 Mar 2012 13:42:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315124228.GA5318@elte.hu>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
 <20120315014511.GT27051@google.com>
 <1331809239.18960.168.camel@twins>
 <1331809597.18960.171.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331809597.18960.171.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-03-15 at 12:00 +0100, Peter Zijlstra wrote:
> > On Wed, 2012-03-14 at 18:45 -0700, Mandeep Singh Baines wrote:
> > > You could make MAX_RT_PRIO greater than MAX_USER_RT_PRIO but that
> > > might
> > > have some impact on real-time applications. A simple one-line patch:
> > > 
> > > - #define MAX_RT_PRIO           MAX_USER_RT_PRIO
> > > + #define MAX_RT_PRIO           (MAX_USER_RT_PRIO + 1)
> > > 
> > > would prevent user-space from causing a false lockup detection.
> > 
> > We're so not going to muck with the fifo priorities just for this stupid
> > soft watchdog,.. I already hate that I can't disable the piece of crap,
> > making it more involved is just really not going to happen.
> 
> And before people start to whinge about that, all the soft 
> watchdog issues I've seen fly by the past year or so all were 
> bugs in the watchdog itself, I can't actually remember it 
> flagging a real problem.

Its efficiency always depended on which area I was working on. 
For syscall level stuff it helped me numerous times.

> The NMI watchdog otoh works like a charm for me and regularly 
> helps out when I done stupid.

Sure, you are mostly working on perf events, the scheduler and 
related core kernel areas so when you are stupid you get a hard 
lockup or worse, quickly. Not much room for soft lockups.

So it's more of a case of selection bias, me thinks.

So unless there's concensus to remove everything but the hard 
lockup detection facilities, lets solve the technical problem at 
hand, ok?

Thanks,

	Ingo
