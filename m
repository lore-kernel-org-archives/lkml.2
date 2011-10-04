Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1JDIzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:55:43 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:35734 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1JDIzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:55:41 -0400
Date: Tue, 4 Oct 2011 10:54:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111004085409.GA18566@elte.hu>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
 <20110923122014.GP6063@erda.amd.com>
 <1317716839.25926.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317716839.25926.12.camel@twins>
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

> On Fri, 2011-09-23 at 14:20 +0200, Robert Richter wrote:
> > > The only thing I'm not quite sure on is the userspace bits, but those
> > > are in the future work section as well, but possibly Ingo has a strong
> > > opinion here, sadly he doesn't have email atm :/
> > 
> > With Lin's patch 'perf: Remove perf_event_attr::type check' we already
> > can sample with perf record.
> > 
> > I think we could extend perf report to parse also ibs samples. 
> > The only thing we need for it should be the pmu name/type mapping 
> > in the perf.data header and the pmu type in the sample. See my 
> > comment on Stephane's patch '[PATCH] perf: make perf.data more 
> > self-descriptive (v5)'.
> 
> OK, so Ingo really really wants to see a little more perf 
> integration there. Acme, what's the state of Stephane's patch?

So the whole IBS thing looks quite unintegrated to me - and that's 
partly because the hw is admittedly weird. The way we could perhaps 
live with it upstream is two conditions:

 - Testable IBS user-space code a bit more prominently integrated
   than having to go down into a cellar with no working lights and 
   finding the code on display in tools/perf/Documentation/examples/ 
   on the bottom of a locked filing cabinet stuck in a disused
   lavatory with a sign on the door saying 'Beware of the Leopard.'

 - Only root/privileged users should be able to access it. Right now
   i think it's root-only due to percpu restrictions, but wanted to 
   mention it that this is an explicit requirement.

Non-privileged IBS use could be enabled by having working integration 
with generic events: we could add a upos generic event for example so 
IBS could map to '-e uops:p' or such, to allow skid-less profiling on 
AMD CPUs.

Thanks,

	Ingo
