Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2HITYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:24:23 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab2HITYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:24:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] PM / Domains: fix early device initialization failure
Date: Thu, 9 Aug 2012 21:30:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1344522694-31164-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1344522694-31164-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208092130.15813.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012, Marek Szyprowski wrote:
> dev_pm_get_subsys_data() returns 1 when a new object has been created,
> what should not be considered as an error for pm_genpd_add_device().
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

This has been reported twice already and there's a patch in linux-next
to fix this issue.  And your patch is incomplete. :-)

Thanks,
Rafael


> ---
>  drivers/base/power/domain.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index ba3487c..6b61819 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1323,9 +1323,16 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>  		}
>  
>  	ret = dev_pm_get_subsys_data(dev);
> -	if (ret)
> +
> +	if (ret < 0)
>  		goto out;
>  
> +	/*
> +	 * dev_pm_get_subsys_data() returns 1 when new object has been created
> +	 */
> +	if (ret == 1)
> +		ret = 0;
> +
>  	genpd->device_count++;
>  	genpd->max_off_time_changed = true;
>  
> 

