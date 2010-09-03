Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0ICIsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:48:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1892 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0ICIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:48:39 -0400
Date: Fri, 3 Sep 2010 10:48:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Jin Dongming" <jin.dongming@np.css.fujitsu.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20100903104801.4b41ec56@hyperion.delvare>
In-Reply-To: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com>
References: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Sep 2010 17:45:26 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Warn when sysfs_add_file_to_group fails.
> 
> Also add missing curly braces.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index c2a8b26..4c3cd62 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -211,20 +211,26 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
>  	if (err)
>  		return err;
>  
> -	if (cpu_has(c, X86_FEATURE_PLN))
> +	if (cpu_has(c, X86_FEATURE_PLN)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_core_power_limit_count.attr,
>  					      thermal_attr_group.name);
> -	if (cpu_has(c, X86_FEATURE_PTS))
> +		WARN_ON(err);
> +	}
> +	if (cpu_has(c, X86_FEATURE_PTS)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_package_throttle_count.attr,
>  					      thermal_attr_group.name);
> -		if (cpu_has(c, X86_FEATURE_PLN))
> +		WARN_ON(err);
> +		if (cpu_has(c, X86_FEATURE_PLN)) {
>  			err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					&attr_package_power_limit_count.attr,
>  					thermal_attr_group.name);
> +			WARN_ON(err);
> +		}
> +	}
>  
> -	return err;
> +	return 0;
>  }
>  
>  static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)


-- 
Jean Delvare
