Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2JSWHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:07:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55829 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab2JSWHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:07:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 1/2] cpufreq: return early from __cpufreq_driver_getavg()
Date: Sat, 20 Oct 2012 00:11:29 +0200
Message-ID: <2737823.2JYE7UmLRN@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org>
References: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 of October 2012 01:42:05 Viresh Kumar wrote:
> There is no need to do cpufreq_get_cpu() and cpufreq_put_cpu() for drivers that
> don't support getavg() routine.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

The patch doesn't seem to follow the changelog or the other way around.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 85df538..f552d5f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1511,12 +1511,14 @@ int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
>  {
>  	int ret = 0;
>  
> +	if (!(cpu_online(cpu) && cpufreq_driver->getavg))
> +		return 0;
> +
>  	policy = cpufreq_cpu_get(policy->cpu);
>  	if (!policy)
>  		return -EINVAL;
>  
> -	if (cpu_online(cpu) && cpufreq_driver->getavg)
> -		ret = cpufreq_driver->getavg(policy, cpu);
> +	ret = cpufreq_driver->getavg(policy, cpu);
>  
>  	cpufreq_cpu_put(policy);
>  	return ret;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
