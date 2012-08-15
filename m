Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2HOURr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:17:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41026 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2HOURW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:17:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Subject: Re: [PATCH] cpuidle: Prevent null pointer dereference in cpuidle_coupled_cpu_notify
Date: Wed, 15 Aug 2012 22:23:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
References: <1344945151.2674.56.camel@linaro1.home>
In-Reply-To: <1344945151.2674.56.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208152223.17623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 14, 2012, Jon Medhurst (Tixy) wrote:
> When a kernel is built to support multiple hardware types it's possible
> that CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is set but the hardware the
> kernel is run on doesn't support cpuidle and therefore doesn't load a
> driver for it. In this case, when the system is shut down,
> cpuidle_coupled_cpu_notify() gets called with cpuidle_devices set to
> NULL. There are quite possibly other circumstances where this
> situation can also occur and we should check for it.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>

Applied to the linux-next branch of the linux-pm.git tree as v3.6 material.

Thanks,
Rafael


> ---
> 
> Would a better fix be to delay registering the notifier until
> cpuidle_coupled_register_device() is called? Though following through
> with that logic would require unregistering the notifier when cpuidle
> driver is unregistered and it still seems possible that there would
> still be a window of opportunity for things to go wrong.
> 
> 
>  drivers/cpuidle/coupled.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2c9bf26..c78a5ff 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -681,7 +681,7 @@ static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
>  	mutex_lock(&cpuidle_lock);
>  
>  	dev = per_cpu(cpuidle_devices, cpu);
> -	if (!dev->coupled)
> +	if (!dev || !dev->coupled)
>  		goto out;
>  
>  	switch (action & ~CPU_TASKS_FROZEN) {
> 

