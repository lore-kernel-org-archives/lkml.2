Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2LPM7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:59:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35363 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2LPM7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:59:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
Date: Sun, 16 Dec 2012 14:04:24 +0100
Message-ID: <4137114.myBUIQvsg3@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 16, 2012 11:20:08 AM Viresh Kumar wrote:
> cpufreq core doesn't manage offline cpus and if driver->init() has returned
> mask including offline cpus, it may result in unwanted behavior by cpufreq core
> or governors.
> 
> We need to get only online cpus in this mask. There are two places to fix this
> mask, cpufreq core and cpufreq driver. It makes sense to do this at common place
> and hence is done in core.

Well, this series makes sense to me, but I'd like to hear what the other people
think.

Thanks,
Rafael


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1f93dbd..de99517 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -970,6 +970,13 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  		pr_debug("initialization failed\n");
>  		goto err_unlock_policy;
>  	}
> +
> +	/*
> +	 * affected cpus must always be the one, which are online. We aren't
> +	 * managing offline cpus here.
> +	 */
> +	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
> +
>  	policy->user_policy.min = policy->min;
>  	policy->user_policy.max = policy->max;
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
