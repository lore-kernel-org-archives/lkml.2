Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2BVPv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:51:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57379 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2BVPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:51:26 -0500
Date: Wed, 22 Feb 2012 16:51:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222155110.GB28314@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <4F45050B.4080001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F45050B.4080001@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/22/2012 12:18 AM, Ingo Molnar wrote:
> > 
> > For example could you tell *at a glance* what this does:
> > 
> > +       if (!static_branch_def_false(&perf_sched_events.key))
> > 
> > ?
> 
> Yes. [...]

You have specially built eyes I guess - congrats, you are member 
of the 1% :-)

> [...]  Unlike
> 
> > +       if (very_unlikely(&perf_sched_events.key))
> 
> ... which is actively misleading.

Misleading in what way? It clearly conveys that the slowpath 
that follows is a slowpath, that what follows is 'very 
unlikely'.

This is how all current kernel code is using these facilities.

If you have a new usecase (CPU feature flags) then you should 
outline that, instead of expecting something of current usecases 
that they are clearly not ...

Thanks,

	Ingo
