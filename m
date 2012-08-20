Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2HTKKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:10:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2HTKKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:10:21 -0400
Message-ID: <1345457400.23018.28.camel@twins>
Subject: Re: [PATCH 1/2] pebs, x86: Make sure to really disable PEBS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 20 Aug 2012 12:10:00 +0200
In-Reply-To: <1345306530-25665-1-git-send-email-andi@firstfloor.org>
References: <1345306530-25665-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 09:15 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When disabling a PEBS event we need to check the old value
> to determine if PEBS was running. Otherwise the last PEBS value
> could be kept running.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index e38d97b..db49ab3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -438,9 +438,10 @@ void intel_pmu_pebs_disable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  	struct hw_perf_event *hwc = &event->hw;
> +	u64 old = cpuc->pebs_enabled;
>  
>  	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
> -	if (cpuc->enabled)
> +	if (old)

cpuc->enabled != cpuc->pebs_enabled

>  		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
>  
>  	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;

