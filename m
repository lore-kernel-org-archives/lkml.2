Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1EFHir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:38:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1EFHiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:38:46 -0400
Date: Fri, 6 May 2011 09:38:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf events, x86: Add SandyBridge
 stalled-cycles-frontend/backend events
Message-ID: <20110506073832.GG23166@elte.hu>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> Extend the Intel SandyBridge PMU driver with definitions
> for generic front-end and back-end stall events.
> 
> ( As commit 3011203 says, these are only approximations. )
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index c1ec7a5..61cbf48 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1485,6 +1485,12 @@ static __init int intel_pmu_init(void)
>  
>  		x86_pmu.event_constraints = intel_snb_event_constraints;
>  		x86_pmu.pebs_constraints = intel_snb_pebs_events;
> +
> +		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
> +		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
> +

Nice!

Could you check Intel Atom perhaps as well, does it have any useful event to 
approximate this?

Thanks,

	Ingo
