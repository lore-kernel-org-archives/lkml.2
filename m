Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1EZKuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:50:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1EZKt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:49:59 -0400
Date: Thu, 26 May 2011 12:49:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, a.p.zijlstra@chello.nl,
        ming.m.lin@intel.com, acme@redhat.com, "Brown, Len" <lenb@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] show energy consumption info in perf tool
Message-ID: <20110526104937.GE1763@elte.hu>
References: <1306398855.2207.156.camel@rui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306398855.2207.156.camel@rui>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Zhang Rui <rui.zhang@intel.com> wrote:

> Introduce four new perf software events
>
> PERF_COUNT_SW_PKG_ENERGY
> PERF_COUNT_SW_CORE_ENERGY
> PERF_COUNT_SW_UNCORE_ENERGY
> and
> PERF_COUNT_SW_DRAM_ENERGY
> 
> To use it, users can run
> perf stat -e pkg-energy foo
> to get the package energy consumption when running foo.

That's very interesting - being able to profile workloads by 
power/energy use looks like a *very* powerful feature.

Are you allowed to show us some sample output of the data? What's the 
granularity of this info? Say what is the output of:

  perf stat -e pkg-energy -e core-energy -e uncore-energy -e dram-energy -a sleep 10

?

Also, have you tried something like:

	perf record -a -e pkg-energy sleep 60

	perf report

To see where most of the energy is used within a 1 minute interval?

Also, conceptually these are really hardware events, right?

Thanks,

	Ingo
