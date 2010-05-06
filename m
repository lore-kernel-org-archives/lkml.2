Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0EFI1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:27:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0EFI1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:27:45 -0400
Date: Thu, 6 May 2010 10:27:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
Message-ID: <20100506082714.GA2036@elte.hu>
References: <1273053073.1642.235.camel@laptop>
 <4BE1406C.2000400@kernel.org>
 <1273059488.1642.245.camel@laptop>
 <4BE1648B.1080709@kernel.org>
 <20100505165532.GC14323@elte.hu>
 <1273083173.1642.250.camel@laptop>
 <1273083396.1642.251.camel@laptop>
 <20100505183000.GF6320@nowhere>
 <20100506062855.GD1172@elte.hu>
 <4BE26B96.4040007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE26B96.4040007@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 05/06/2010 08:28 AM, Ingo Molnar wrote:
> > ( They are also under intense optimization - the jump-tracepoints patch makes 
> >   them probably even cheaper than preempt notifiers, in the off case. )
> 
> I mostly agree on other points but TPs and sched_notifiers are inherently 
> different in how they are enabled/disabled. sched_notifiers are 
> enabled/disabled per-task and at least w/ cmwq, there will always be some 
> tasks with active sched_notifiers so code level optimizations aren't really 
> useful.

Note that preempt notifiers used to modify scheduling behavior/semantics i'm 
really against. Please get that functionality into the scheduler - especially 
if it's essentially always-on.

Preempt notifiers are for things like KVM which want to do extended context 
saving. They are _NOT_ 'hooks' into the scheduler.

	Ingo
