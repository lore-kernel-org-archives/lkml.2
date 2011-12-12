Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1LLM6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:58:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40173 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1LLM6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:58:34 -0500
Message-ID: <1323694657.13285.12.camel@twins>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES
 generic PMU event
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Date: Mon, 12 Dec 2011 13:57:37 +0100
In-Reply-To: <1323559734-3488-3-git-send-email-eranian@google.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	 <1323559734-3488-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 00:28 +0100, Stephane Eranian wrote:
> This event counts the number of reference core cpu cycles.
> Reference means that the event increments at a constant rate which
> is not subject to core CPU frequency adjustments. The event may
> not count when the processor is in halted (low power) state.
> As such, it may not be equivalent to wall clock time. However,
> when the processor is not halted state, the event keeps
> a constant correlation with wall clock time.
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
>  
>  	PERF_COUNT_HW_MAX,			/* non-ABI */
>  };

Does it make sense to add this to the 'generic' events? Are other archs
going to use this?

That is, I already queued patch 1, I'm just wondering if the generic bit
makes sense, Even BUS_CYCLES seems to be a questionable 'generic' event,
but that's history and we can't fix it.
