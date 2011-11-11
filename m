Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1KKH07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 02:26:59 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54302 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1KKH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 02:26:57 -0500
Message-ID: <4EBCCE33.2090708@linux.vnet.ibm.com>
Date: Fri, 11 Nov 2011 12:56:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] kernel/cpu.c: Add right qualifiers for intel_thermal_interrupt()
 and cpu_hotplug_pm_sync_init()
References: <1320956564-21334-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1320956564-21334-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 01:52 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Add __init for functions alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()
> because they are only called during boot time.
> 
> Add static for function cpu_hotplug_pm_sync_init() because its scope is limited
> in this file only.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  kernel/cpu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 563f136..cf915b8 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -470,7 +470,7 @@ out:
>  	cpu_maps_update_done();
>  }
> 
> -static int alloc_frozen_cpus(void)
> +static int __init alloc_frozen_cpus(void)
>  {
>  	if (!alloc_cpumask_var(&frozen_cpus, GFP_KERNEL|__GFP_ZERO))
>  		return -ENOMEM;
> @@ -543,7 +543,7 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
>  }
> 
> 
> -int cpu_hotplug_pm_sync_init(void)
> +static int __init cpu_hotplug_pm_sync_init(void)
>  {
>  	pm_notifier(cpu_hotplug_pm_callback, 0);

pm_notifier() macro will declare a static variable. I agree this won't
be any problem functionality-wise. But it doesn't seem elegant to say
"throw away the function but keep the static variable".
So, if you want to add __init qualifier to this function, I suggest that
you declare the static variable outside the function, and call
register_pm_notifier() in the function, just to ensure it doesn't obscure
things.

And please change the title, it talks about intel_thermal_interrupt()!

Thanks,
Srivatsa S. Bhat

>  	return 0;
