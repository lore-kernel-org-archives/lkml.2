Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937978Ab0CPQXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:23:22 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56452 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937964Ab0CPQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JnthjuzOWdRAk9QYc+D2beAm0sPlaAOIKhFLd0hC60LVopcWyhzU3Mw40TQrHEmNwW
         et12akscSatuntfWKny8780xWZWVb9svFlfwML2hxtSzYnWnvWHHlhQmZzUG32zyfm2V
         uUfk4aGNEbm+pW1POv9fc9pteeNCZF8j0z7uc=
Date: Tue, 16 Mar 2010 19:23:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/x86] perf, x86: Implement initial P4 PMU driver
Message-ID: <20100316162314.GG5206@lenovo>
References: <20100311165439.GB5129@lenovo> <tip-a072738e04f0eb26370e39ec679e9a0d65e49aea@git.kernel.org> <20100316160733.GR1585@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316160733.GR1585@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 05:07:33PM +0100, Robert Richter wrote:
[...]
> --
> 
> From: Robert Richter <robert.richter@amd.com>
> Date: Tue, 16 Mar 2010 16:38:19 +0100
> Subject: [PATCH] perf, x86: reporting error code that returns from x86_pmu.hw_config()
> 
> If x86_pmu.hw_config() fails a fixed error code (-EOPNOTSUPP) is
> return even if a different error was reported. This patch fixes this.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 4e2480f..8982d92 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -467,8 +467,9 @@ static int __hw_perf_event_init(struct perf_event *event)
>  	hwc->last_tag = ~0ULL;
>  
>  	/* Processor specifics */
> -	if (x86_pmu.hw_config(attr, hwc))
> -		return -EOPNOTSUPP;
> +	err = x86_pmu.hw_config(attr, hwc);
> +	if (err)
> +		return err;
>  
>  	if (!hwc->sample_period) {
>  		hwc->sample_period = x86_pmu.max_period;
> -- 
> 1.7.0
>

Though at moment all hw_config callees return 0, it's better
to be ready if one day we may start returning some particular
errors. Looks good to me. Objections?

	-- Cyrill
