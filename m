Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2JNICk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 04:02:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab2JNICi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 04:02:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Domains: Fix memory leak on error path in pm_genpd_attach_cpuidle
Date: Sun, 14 Oct 2012 10:06:17 +0200
Message-ID: <1806891.1aniohUZ1p@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-5-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <001d01cda8e6$3ec8bda0$bc5a38e0$%choi@samsung.com>
References: <001d01cda8e6$3ec8bda0$bc5a38e0$%choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for spotting the problem and for the patch (it got corrupted
in transfer, so please see if the one below is what you meant).

I'll queue it up for v3.7, but I'm travelling now, so it may take a while.

Thanks,
Rafael


> From: jhbird.choi@samsung.com
> Subject: PM / Domains: Fix memory leak on error path in pm_genpd_attach_cpuidle
> 
> If pm_genpd_attach_cpudidle failed we leak memory stored in 'cpu_data'.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
> drivers/base/power/domain.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c index c22b869..96b71b6 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1862,7 +1862,7 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  	cpuidle_drv = cpuidle_driver_ref();
>  	if (!cpuidle_drv) {
>  		ret = -ENODEV;
> -		goto out;
> +		goto err_drv;
>  	}
>  	if (cpuidle_drv->state_count <= state) {
>  		ret = -EINVAL;
> @@ -1884,6 +1884,9 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
> 
>   err:
>  	cpuidle_driver_unref();
> +
> + err_drv:
> +	kfree(cpu_data);
>  	goto out;
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
