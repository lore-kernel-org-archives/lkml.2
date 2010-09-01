Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0IARdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:33:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0IARdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:33:03 -0400
Date: Wed, 1 Sep 2010 19:32:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
Message-ID: <20100901173253.GC23357@elte.hu>
References: <4C7E11E5.1040402@redhat.com>
 <1283331868.2059.808.camel@laptop>
 <4C7E1C36.6070400@redhat.com>
 <4C7E1F12.8030304@cn.fujitsu.com>
 <4C7E2D1D.3080603@redhat.com>
 <1283338977.2059.938.camel@laptop>
 <20100901121518.GA5378@nowhere>
 <1283349585.2356.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283349585.2356.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-09-01 at 14:15 +0200, Frederic Weisbecker wrote:
> 
> > Thanks for fixing this.
> > 
> > However, can we split this in two patches to ease the backport?
> > 
> > The lack of a module_put() after perf_trace_init() failure is there for a while
> > (the backport needs to start in 2.6.32).
> > 
> > But the lack of a module_put in the destroy path needs a .35 backport only.
> 
> I don't think it really needs two patches. Just notify stable (and 
> Greg KH in particular) about the backport requirements. Greg can 
> handle it ;)

Well, Greg certainly has more than enough to handle, so if there's 
different chunks with different -stable vectors then it would be most 
helpful to him to split things up!

Manually trying to split up patches is both error-prone and 
stress-inducing.

Thanks,

	Ingo
