Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2JZLNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:13:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2JZLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:13:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com
Subject: Re: [PATCH] cpufreq: Avoid calling cpufreq driver's target() routine if target_freq == policy->cur
Date: Fri, 26 Oct 2012 13:17:12 +0200
Message-ID: <5056958.0bPciFrxt5@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1d7b6e421a335255da956804b43ce3517538409c.1351244153.git.viresh.kumar@linaro.org>
References: <1d7b6e421a335255da956804b43ce3517538409c.1351244153.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 03:06:26 PM Viresh Kumar wrote:
> Avoid calling cpufreq driver's target() routine if new frequency is same as
> policies current frequency.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Looks reasonable.

Any objection from anyone?

Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 261ef65..28dc134 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1476,6 +1476,10 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  
>  	pr_debug("target for CPU %u: %u kHz, relation %u\n", policy->cpu,
>  		target_freq, relation);
> +
> +	if (target_freq == policy->cur)
> +		return 0;
> +
>  	if (cpu_online(policy->cpu) && cpufreq_driver->target)
>  		retval = cpufreq_driver->target(policy, target_freq, relation);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
