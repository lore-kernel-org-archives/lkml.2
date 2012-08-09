Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2HITVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:21:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42956 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2HITVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <1344535707.20277.20.camel@twins>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	<50235ED0.5010107@intel.com>
	<CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
	<1344535707.20277.20.camel@twins>
Date: Thu, 9 Aug 2012 21:21:32 +0200
Message-ID: <CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes problems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 8:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-09 at 16:05 +0200, Stephane Eranian wrote:
>> > uncore PMU does not have this issue because uncore_pmu->task_ctx_nr
>> > is 'perf_invalid_context'. find_pmu_context() always return NULL in
>> > that case.
>> >
>> Yes, I think IBS should do the same and that should fix the problem
>> there too. Will try that.
>
> I'm afraid not, per-task profiling with uncore doesn't really make that
> much sense. For IBS it does.
>
> We can't share a context with different PMUs, that'll totally mess up
> the event scheduling.
>
> We'll have to grow perf_event_task_context with an extra context and
> have IBS use that.

Ok, I am fine with that. Don't know about to call it though.
