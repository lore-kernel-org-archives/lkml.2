Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2HISIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:08:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2HISIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:08:39 -0400
Message-ID: <1344535707.20277.20.camel@twins>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes
 problems
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Date: Thu, 09 Aug 2012 20:08:27 +0200
In-Reply-To: <CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	 <50235ED0.5010107@intel.com>
	 <CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 16:05 +0200, Stephane Eranian wrote:
> > uncore PMU does not have this issue because uncore_pmu->task_ctx_nr
> > is 'perf_invalid_context'. find_pmu_context() always return NULL in
> > that case.
> >
> Yes, I think IBS should do the same and that should fix the problem
> there too. Will try that. 

I'm afraid not, per-task profiling with uncore doesn't really make that
much sense. For IBS it does.

We can't share a context with different PMUs, that'll totally mess up
the event scheduling.

We'll have to grow perf_event_task_context with an extra context and
have IBS use that.
