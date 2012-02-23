Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2BWKCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:02:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2BWKCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:02:19 -0500
Date: Thu, 23 Feb 2012 11:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120223100205.GD24310@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> On Wed, Feb 22, 2012 at 09:18:55AM +0100, Ingo Molnar wrote:
> 
> > The problem with static_branch_def_false/def_true was that the 
> > very intuitively visible bias that we see with 
> > likely()/unlikely() is confused in jump label constructs through 
> > two layers of modifiers. And the fix is so easy, a simple rename 
> > in most cases ;-)
> > 
> > So instead of that, in this series we have:
> > 
> > +       if (very_unlikely(&perf_sched_events.key))
> > 
> > which is a heck of an improvement IMO. I'd still up its 
> > readability a notch, by also signalling the overhead of the 
> > update path by making it:
> > 
> > +       if (very_unlikely(&perf_sched_events.slow_flag))
> > 
> > ... but I don't want to be that much of a readability nazi ;-)
> 
> I have to say I don't like the "very_unlikely" name.  It's 
> confusing because the condition being evaluated appears to be 
> the address of something, i.e. &perf_sched_events.key in your 
> example, and that looks to me to be very very likely to be 
> true, i.e. non-zero.  But the code is telling me that's very 
> *un*likely, which is confusing.

Having to take the address gives us type safety - i.e. it will 
not be possible to accidentally pass in a non-jump-label key and 
get it misinterpreted.

If some macro magic could be used to remove the address taking 
I'd be in favor of such a simplification, i.e.:

	if (very_unlikely(perf_sched_events.key))

which should address your observation.

Thanks,

	Ingo
