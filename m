Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1D2OsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:48:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1D2OsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mW2Bf41LVpMlAEyeo38nl8uE1dLh+skEFLYNOos51D4cv7rUSZZs4cq3GboVJCAG4z
         6iN8kNLnsOcG2+1YhMZ7LKjirrVoTESd/boIWmo298qn5ZnIrBEt/3QO9G5m0TkWFZoW
         deSJKgPBakykV/wqFyyMeExuxiSRcB7pSDS6o=
Message-ID: <4DBACF9F.1080200@gmail.com>
Date: Fri, 29 Apr 2011 08:47:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: perf stat branch: perf stat fails on unsupported event
References: <4DBAC59F.2020009@gmail.com> <20110429142037.GB4106@elte.hu>
In-Reply-To: <20110429142037.GB4106@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/29/11 08:20, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
>> This is a Dell R410 with an E5620 processor.
> 
> That's a Westmere CPU.
> 
> Could you check whether the patch below applied to latest -tip gives you 
> stalled-cycles-frontend and stalled-cycles-backend events?

yes, it does. And I see it's been committed already. ;-)

> 
> Thanks,
> 
> 	Ingo
> 
> --------------->
> From 3808ae38f1905c1f11da46ac981c8d2579936fd8 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 30 Apr 2011 09:14:54 +0200
> Subject: [PATCH] perf events, x86: Add Westmere stalled-cycles-frontend/backend events
> 
> Extend the Intel Westmere PMU driver with definitions for generic front-end and
> back-end stall events.
> 
> ( These are only approximations. )
> 
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Link: http://lkml.kernel.org/n/tip-7y40wib8n008io7hjpn1dsrm@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 7983b9a..be8363a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1458,6 +1458,12 @@ static __init int intel_pmu_init(void)
>  		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
>  		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
>  		x86_pmu.extra_regs = intel_westmere_extra_regs;
> +
> +		/* UOPS_ISSUED.STALLED_CYCLES */
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
> +		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
> +
>  		pr_cont("Westmere events, ");
>  		break;
>  
