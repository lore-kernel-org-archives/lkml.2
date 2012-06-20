Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2FTJgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:36:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2FTJgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:36:49 -0400
Message-ID: <1340185002.21745.80.camel@twins>
Subject: Re: [PATCH 05/10] perf, x86: Move Intel specific code to
 intel_pmu_init()
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 11:36:42 +0200
In-Reply-To: <1340129448-8690-6-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <1340129448-8690-6-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 20:10 +0200, Robert Richter wrote:
> There is some Intel specific code in the generic x86 path. Move it to
> intel_pmu_init().
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 1eb9f00..90d7097 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1760,7 +1760,7 @@ static __init void intel_nehalem_quirk(void)
>  	}
>  }
>  
> -__init int intel_pmu_init(void)
> +static __init int __intel_pmu_init(void)
>  {
>  	union cpuid10_edx edx;
>  	union cpuid10_eax eax;
> @@ -1955,3 +1955,46 @@ __init int intel_pmu_init(void)
>  
>  	return 0;
>  }
> +
> +__init int intel_pmu_init(void)
> +{
> +	struct event_constraint *c;
> +	int ret = __intel_pmu_init();


This seems like a nice enough cleanup all on its own, but why make it
two functions?
