Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1DGF5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:57:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47918 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1DGF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:57:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6308"; a="84428337"
Message-ID: <4D9D523F.4090506@codeaurora.org>
Date: Wed, 06 Apr 2011 22:57:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <len.brown@intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] cpuidle: Fix build on ARM and SH
References: <1301894612-10471-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1301894612-10471-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/2011 10:23 PM, Mark Brown wrote:
> Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
> cpuidle_idle_call() but contained typos on ARM and SH transposing the
> function name into cpuidle_call_idle().
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

When will this patch get into linux-next? Every ARM and SH build has
failed for the past 3 days presumably due to this. Stephen, can you pick
it up for the time being?

> ---
>  arch/arm/kernel/process.c |    2 +-
>  arch/sh/kernel/idle.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index dc9d685..f47660e 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -197,7 +197,7 @@ void cpu_idle(void)
>  				cpu_relax();
>  			} else {
>  				stop_critical_timings();
> -				if (cpuidle_call_idle())
> +				if (cpuidle_idle_call())
>  					pm_idle();
>  				start_critical_timings();
>  				/*
> diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
> index 9c7099e..1db1968 100644
> --- a/arch/sh/kernel/idle.c
> +++ b/arch/sh/kernel/idle.c
> @@ -101,7 +101,7 @@ void cpu_idle(void)
>  			local_irq_disable();
>  			/* Don't trace irqs off for idle */
>  			stop_critical_timings();
> -			if (cpuidle_call_idle())
> +			if (cpuidle_idle_call())
>  				pm_idle();
>  			/*
>  			 * Sanity check to ensure that pm_idle() returns
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

