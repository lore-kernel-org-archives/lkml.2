Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2BGKuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:50:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab2BGKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:50:11 -0500
Date: Tue, 7 Feb 2012 11:49:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
Message-ID: <20120207104952.GB4328@elte.hu>
References: <20120206205354.GA31186@quad>
 <1328603689.2476.15.camel@edumazet-laptop>
 <20120207084156.GA15359@elte.hu>
 <1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> On Tue, Feb 7, 2012 at 11:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :
> >
> >> Were these messages introduced by:
> >>
> >>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
> >>
> >> as well?
> >>
> >> In any case I'm holding off on applying the patch before this is
> >> resolved.
> >
> > Reverting e050e3f0a71b solves all my problems, no more warnings.
> >
> > $ perf record -a -g hackbench 10 thread 4000
> > Running with 10*40 (== 400) tasks.
> > Time: 13.181
> > [ perf record: Woken up 59 times to write data ]
> > [ perf record: Captured and wrote 16.874 MB perf.data (~737228 samples)
> > ]
> >
> > $ perf record -a -g hackbench 10 thread 4000
> > Running with 10*40 (== 400) tasks.
> > Time: 13.124
> > [ perf record: Woken up 61 times to write data ]
> > [ perf record: Captured and wrote 16.533 MB perf.data (~722349 samples)
> > ]
> >
>
> What system is this running on?
> The problem is that without e050e3f0a71b interrupt throttling does not work.

Fixes are not supposed to regress, so if we cannot resolve this 
within a couple of days we'll have to revert e050e3f0a71b and 
re-try it later.

> I think the key difference is that without the patch, 
> frequency adjustment happens with the PMU completely stopped 
> whereas with my patch it does not. I suspect this may be the 
> issue. I can rework the patch to disable the PMU completely 
> while retaining the same workflow.

Would be nice to try that.

Thanks,

	Ingo
