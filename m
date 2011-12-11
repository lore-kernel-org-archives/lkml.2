Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab1LKIDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 03:03:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1LKIDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 03:03:23 -0500
Date: Sun, 11 Dec 2011 09:01:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
Message-ID: <20111211080138.GB20790@elte.hu>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
 <1323559734-3488-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323559734-3488-3-git-send-email-eranian@google.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> This event counts the number of reference core cpu cycles. 
> Reference means that the event increments at a constant rate 
> which is not subject to core CPU frequency adjustments. The 
> event may not count when the processor is in halted (low 
> power) state. As such, it may not be equivalent to wall clock 
> time. However, when the processor is not halted state, the 
> event keeps a constant correlation with wall clock time.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/linux/perf_event.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 564769c..0885561 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -54,6 +54,7 @@ enum perf_hw_id {
>  	PERF_COUNT_HW_BUS_CYCLES		= 6,
>  	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
>  	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
> +	PERF_COUNT_HW_REF_CPU_CYCLES		= 9,

Btw., that was what 'bus cycles' tried to do a long time ago: 
the constant, non-variable baseline heartbeat of the system.

We could simply rename that, fix the event tables where needed, 
and keep the ABI.

Just a small detail: how about naming it 'constant [frequency] 
CPU cycles'? That's a concept that might be present on other 
platforms as well.

CONST_FREQ_CYCLES or so. The 'CPU' can be dropped as well 
because it's not really the CPU's frequency anymore.

Thanks,

	Ingo
