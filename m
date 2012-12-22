Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab2LVLwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 06:52:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40890 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LVLwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:52:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 16/25] PM / Domains: don't use [delayed_]work_pending()
Date: Sat, 22 Dec 2012 12:57:20 +0100
Message-ID: <21556832.hKrqJSonFg@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1356141435-17340-17-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <1356141435-17340-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 21, 2012 05:57:06 PM Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.

Is the particular one you're removing from domain.c buggy?

> Remove unnecessary pending tests from power domains.  Only compile
> tested.

I can take this one too.

Thanks,
Rafael


> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: linux-pm@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  drivers/base/power/domain.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index acc3a8d..9a6b05a 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -433,8 +433,7 @@ static bool genpd_abort_poweroff(struct generic_pm_domain *genpd)
>   */
>  void genpd_queue_power_off_work(struct generic_pm_domain *genpd)
>  {
> -	if (!work_pending(&genpd->power_off_work))
> -		queue_work(pm_wq, &genpd->power_off_work);
> +	queue_work(pm_wq, &genpd->power_off_work);
>  }
>  
>  /**
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
