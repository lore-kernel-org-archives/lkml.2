Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1KOGZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:25:55 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59947 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1KOGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:25:53 -0500
Message-ID: <4EC200D4.9040505@linux.vnet.ibm.com>
Date: Tue, 15 Nov 2011 11:34:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/cpu.c: Add right qualifiers for alloc_frozen_cpus()
 and cpu_hotplug_pm_sync_init()
References: <1321315040-4644-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1321315040-4644-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111506-3864-0000-0000-00000015FDCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 05:27 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Add __init for functions alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()
> because they are only called during boot time.
> 
> Add static for function cpu_hotplug_pm_sync_init() because its scope is limited
> in this file only.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

> ---
> v2: Change a function name typo in the title.
> 
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
>  	return 0;

