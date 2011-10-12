Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1JLHFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:05:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1JLHFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:05:43 -0400
Date: Wed, 12 Oct 2011 09:04:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111012070402.GB18618@elte.hu>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
 <20110923122014.GP6063@erda.amd.com>
 <1317716839.25926.12.camel@twins>
 <20111004085409.GA18566@elte.hu>
 <20111004142641.GF21506@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004142641.GF21506@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 04.10.11 04:54:09, Ingo Molnar wrote:
> > So the whole IBS thing looks quite unintegrated to me - and that's 
> > partly because the hw is admittedly weird. The way we could perhaps 
> > live with it upstream is two conditions:
> > 
> >  - Testable IBS user-space code a bit more prominently integrated
> >    than having to go down into a cellar with no working lights and 
> >    finding the code on display in tools/perf/Documentation/examples/ 
> >    on the bottom of a locked filing cabinet stuck in a disused
> >    lavatory with a sign on the door saying 'Beware of the Leopard.'
> 
> With Lin Ming's patch
> 
>  [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
> 
> you can use perf record to collect IBS samples, e.g.:
> 
>  # perf record -e ibs_fetch:r0 -c 100000 -a bash -c someload
>  [ perf record: Woken up 3 times to write data ]
>  [ perf record: Captured and wrote 2.004 MB perf.data (~87572 samples) ]
> 
> With Stephane's patch
> 
>  [PATCH] perf: make perf.data more self-descriptive (v8)
> 
> I could extend perf report to add an IBS parser (I need to know the
> pmu name/type value mapping).
> 
> Do you have something like that in mind?
> 
> As all these patches are still off-tree I would rather prefer to 
> decouple the IBS patches from a parser implementation and add it 
> later as a single patch series. Hmm?

Yeah, i'd like to have something that i can try out in practice on an 
AMD box without having to apply any other patches.

The perf.data extension patch from Stephane is now in perf/core. You 
could add Lin Ming's patch to your tree - they really interdepend. 
That way it could be reviewed and handled as a coherent unit offering 
some real, testable functionality.

> >  - Only root/privileged users should be able to access it. Right now
> >    i think it's root-only due to percpu restrictions, but wanted to 
> >    mention it that this is an explicit requirement.
> 
> Yes, IBS is restricted to percpu. And percpu requires root 
> privileges like all other pmu events. What is your point here?

My point is that this should not just be an incidental side-effect of 
hardware limitations but should stay so until deeper integration is 
achieved. The list i gave is similar for other future PMU additions.

Anyway, if perf report [and, in latest perf/core, perf top] can do 
IBS output that would be a sufficient level of integration i think.

Thanks,

	Ingo
