Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab0D3Shs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:37:48 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:38673 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099Ab0D3ShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:37:21 -0400
X-Greylist: delayed 4114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 14:37:11 EDT
Date: Fri, 30 Apr 2010 11:08:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: x86@kernel.org, linux-trace-users@vger.kernel.org,
       linux-perf-users@vger.kernel.org, robert.schoene@tu-dresden.de,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] x86 cpufreq: Make trace_power_frequency cpufreq
 driver independent
Message-ID: <20100430090814.GF11032@elte.hu>
References: <1272380262-23671-1-git-send-email-trenn@suse.de>
 <1272380262-23671-3-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272380262-23671-3-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> +	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
> +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> +	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
> +                trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
> +	trace_power_end(smp_processor_id());

Extending power tracing to all cpufreq modules is obviously a good thing.

But why is trace_power_start() adding a CPU ID argument? CPU ids are already 
available and can be sampled via PERF_SAMPLE_CPU if needed. AFAICS only 
power_frequency needs a new 'target_cpu_id' field.

> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index 0d4d8ff..7809bef 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c

Timechart is maintained by Arjan so we need an ack from him as well. I've seen 
some back and forth in the discussions - what's the technical resolution of 
that?

(Also, there's some whitespace noise in the patch.)

Thanks,

	Ingo
