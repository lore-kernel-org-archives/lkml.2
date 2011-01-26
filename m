Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1AZN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:58:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1AZN6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:58:18 -0500
Date: Wed, 26 Jan 2011 14:58:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: perf, x86: Provide a PEBS capable cycle event
Message-ID: <20110126135801.GA30064@elte.hu>
References: <201101062000.p06K0ESw011195@hera.kernel.org>
 <20110126113740.GA13911@elte.hu>
 <AANLkTintgqOkwo=WRH_9vGwGgXf0XrfU2e++daUOOG=i@mail.gmail.com>
 <20110126120646.GA20064@elte.hu>
 <AANLkTikjEGMV=ZwiUmFxmQaELG525ntd=Xi8_EXFT9J7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikjEGMV=ZwiUmFxmQaELG525ntd=Xi8_EXFT9J7@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> On Wed, Jan 26, 2011 at 1:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> On Wed, Jan 26, 2011 at 12:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> >> >
> >> >> Gitweb:     http://git.kernel.org/linus/7639dae0ca11038286bbbcda05f2bef601c1eb8d
> >> >> Commit:     7639dae0ca11038286bbbcda05f2bef601c1eb8d
> >> >> Parent:     abe43400579d5de0078c2d3a760e6598e183f871
> >> >> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> >> AuthorDate: Tue Dec 14 21:26:40 2010 +0100
> >> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> >> CommitDate: Thu Dec 16 11:36:44 2010 +0100
> >> >>
> >> >>     perf, x86: Provide a PEBS capable cycle event
> >> >>
> >> >>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> >>     LKML-Reference: <new-submission>
> >> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >> >> ---
> >> >>  arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
> >> >>  1 files changed, 26 insertions(+), 0 deletions(-)
> >> >
> >> > btw., precise profiling via PEBS:
> >> >
> >> >  perf record -e cycles:p ...
> >> >
> >> > works pretty nicely now on Nehalem CPUs and later.
> >> >
> >> The problem is that cycles:p is not equivalent to cycles in terms of how
> >> cycles are counted. cycles counts only unhalted cycles. cycles:p counts
> >> ALL cycles, event when the CPU is in halted state.
> >
> > That's not really an issue in practice: it at most can cause a bit larger value for:
> >
> >     2.38%       swapper  [kernel.kallsyms]      [k] mwait_idle_with_hints                             ▮
> >
> > Which entry exists with regular cycles event _anyway_, because every irq entry ends
> > up there.
> >
> 
> There is a difference in interpretation. Because now when you get samples in those 
> idle routines, you cannot tell whether it is because you actually execute code 
> there or because you were halted (not executing) and now sampling has altered the 
> behavior of the system in that you wake up from halted state to service a PMU 
> interrupt.

The thing is, most people are not interested in seeing the idle routine entry 
anyway, so we already exclude it in say 'perf top' output, see the skip_symbols[] 
array in builtin-top.c.

So utility seems rather low.

If we contrast it to the utility of having precise PEBS sampling, which dramatically 
improves *all* profiling data and which improves the reading of annotated profiling 
output beyond measure, the default path to go here seems rather obvious. Agreed?

Thanks,

	Ingo
