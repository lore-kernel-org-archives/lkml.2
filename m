Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2LNX5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:57:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34232 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab2LNX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:57:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sivaram Nair <sivaramn@nvidia.com>
Cc: rafael.j.wysocki@intel.com, len.brown@intel.com, daniel.lezcano@linaro.org,
        khilman@ti.com, ccross@android.com, riel@redhat.com,
        youquan.song@intel.com, akpm@linux-foundation.org, shuox.liu@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpuidle: fix finding state with min power_usage
Date: Sat, 15 Dec 2012 01:02:15 +0100
Message-ID: <1380999.e8r58IGCHN@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 03:17:36 PM Sivaram Nair wrote:
> Since cpuidle_state.power_usage is a signed value, use INT_MAX (instead
> of -1) to init the local copies so that functions that tries to find
> cpuidle states with minimum power usage works correctly even if they use
> non-negative values.

I'm queuing this up for submission as v3.8 material.

Thanks,
Rafael


> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
> ---
>  drivers/cpuidle/cpuidle.c        |    2 +-
>  drivers/cpuidle/governors/menu.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 8df53dd..fb4a7dd 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -70,7 +70,7 @@ int cpuidle_play_dead(void)
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int i, dead_state = -1;
> -	int power_usage = -1;
> +	int power_usage = INT_MAX;
>  
>  	if (!drv)
>  		return -ENODEV;
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index bd40b94..20ea33a 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -312,7 +312,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  {
>  	struct menu_device *data = &__get_cpu_var(menu_devices);
>  	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
> -	int power_usage = -1;
> +	int power_usage = INT_MAX;
>  	int i;
>  	int multiplier;
>  	struct timespec t;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
