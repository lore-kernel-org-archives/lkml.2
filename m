Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1GELAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:00:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab1GELAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:00:11 -0400
Date: Tue, 5 Jul 2011 12:59:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705105959.GA14435@elte.hu>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705103403.GN17941@sun>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jul 05, 2011 at 12:20:17PM +0200, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> ...
> > 
> > So why don't we simply set this for all PERF_COUNT_HW_CPU_CYCLES 
> > events in the P4 PMU driver? That would remove half of the patch 
> > AFAICS.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Unfortunately it doesn't solve the main issue -- nmi-watchdog events
> and cpu clock events should be a separate events with non-intersected
> ESCRs, otherwise nmi-watchdog and cpu-cycles can't operate simultaneously
> like other PMUs does.
> 
> non-sleeping ticks use
> 
> 	[P4_EVENT_EXECUTION_EVENT] = {
> 		.escr_msr	= { MSR_P4_CRU_ESCR2, MSR_P4_CRU_ESCR3 },
> 		.cntr		= { {12, 13, 16}, {14, 15, 17}
> 	},
> 
> while cpu-cycles
> 
> 	[P4_EVENT_GLOBAL_POWER_EVENTS] = {
> 		.escr_msr	= { MSR_P4_FSB_ESCR0, MSR_P4_FSB_ESCR1 },
> 		.cntr		= { {0, -1, -1}, {2, -1, -1} },
> 	},

are 'non-sleeping ticks' non-halted cycles - i.e. cycles that always 
count with CPU frequency and can thus be used for periodic 
frequencies?

Thanks,

	Ingo
