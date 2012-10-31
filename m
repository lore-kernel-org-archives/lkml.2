Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2JaAkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:40:24 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202Ab2JaAkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:40:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com
Subject: Re: [PATCH RESEND] cpufreq: Make sure target freq is within limits
Date: Wed, 31 Oct 2012 01:44:18 +0100
Message-ID: <5507910.WhiOUESWao@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <f79c0841be1ae16e1f2bd9084ed9a158eb171eb0.1351254846.git.viresh.kumar@linaro.org>
References: <f79c0841be1ae16e1f2bd9084ed9a158eb171eb0.1351254846.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 06:05:21 PM Viresh Kumar wrote:
> __cpufreq_driver_target() must not pass target frequency beyond the limits of
> current policy.
> 
> Today most of cpufreq platform drivers are doing this check in their target
> routines. Why not move it to __cpufreq_driver_target().
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,
> 
> Resend doesn't contain any change, but fixed commit log

Applied to the linux-next branch of linux-pm.git as v3.8 material.

Thanks,
Rafael


>  drivers/cpufreq/cpufreq.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 28dc134..2f5ac2d 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1470,12 +1470,19 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  			    unsigned int relation)
>  {
>  	int retval = -EINVAL;
> +	unsigned int old_target_freq = target_freq;
>  
>  	if (cpufreq_disabled())
>  		return -ENODEV;
>  
> -	pr_debug("target for CPU %u: %u kHz, relation %u\n", policy->cpu,
> -		target_freq, relation);
> +	/* Make sure that target_freq is within supported range */
> +	if (target_freq > policy->max)
> +		target_freq = policy->max;
> +	if (target_freq < policy->min)
> +		target_freq = policy->min;
> +
> +	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
> +			policy->cpu, target_freq, relation, old_target_freq);
>  
>  	if (target_freq == policy->cur)
>  		return 0;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
