Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0DAKgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:36:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:50802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0DAKgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:36:21 -0400
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1270104442.3456.11.camel@minggr.sh.intel.com>
References: <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
	 <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com>
	 <1269968113.5258.442.camel@laptop> <20100330182906.GD5211@lenovo>
	 <1269975840.5258.609.camel@laptop> <20100331161523.GA9058@lenovo>
	 <20100331162647.GA15288@lenovo>  <20100331170517.GB15288@lenovo>
	 <1270088048.8575.38.camel@minggr.sh.intel.com>
	 <1270104442.3456.11.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 12:36:17 +0200
Message-ID: <1270118177.1653.146.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 14:47 +0800, Lin Ming wrote:
> 
> In file included from arch/x86/kernel/cpu/perf_event.c:1326:
> arch/x86/kernel/cpu/perf_event_p6.c:94: error: ‘x86_hw_config’ undeclared here (not in a function)
> arch/x86/kernel/cpu/perf_event_p6.c:99: error: unknown field ‘raw_event’ specified in initializer
> arch/x86/kernel/cpu/perf_event_p6.c:99: error: ‘x86_pmu_raw_event’ undeclared here (not in a function)
> make[3]: *** [arch/x86/kernel/cpu/perf_event.o] Error 1
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
> index 626abc0..4ec9680 100644
> --- a/arch/x86/kernel/cpu/perf_event_p6.c
> +++ b/arch/x86/kernel/cpu/perf_event_p6.c
> @@ -91,12 +91,11 @@ static __initconst struct x86_pmu p6_pmu = {
>         .enable_all             = p6_pmu_enable_all,
>         .enable                 = p6_pmu_enable_event,
>         .disable                = p6_pmu_disable_event,
> -       .hw_config              = x86_hw_config,
> +       .hw_config              = x86_pmu_hw_config,
>         .schedule_events        = x86_schedule_events,
>         .eventsel               = MSR_P6_EVNTSEL0,
>         .perfctr                = MSR_P6_PERFCTR0,
>         .event_map              = p6_pmu_event_map,
> -       .raw_event              = x86_pmu_raw_event,
>         .max_events             = ARRAY_SIZE(p6_perfmon_event_map),
>         .apic                   = 1,
>         .max_period             = (1ULL << 31) - 1, 

egads, that hunk seems to have tunneled into another patch in my
queue,.. /me goes fix.

Thanks Lin.

