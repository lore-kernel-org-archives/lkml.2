Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1J1LtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:49:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab1J1LtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:49:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vbyravarasu@nvidia.com
Subject: Re: [PATCH v2] PM: fix runtime accounting calculation error
Date: Fri, 28 Oct 2011 13:51:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@suse.de,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pdeschrijver@nvidia.com
References: <1319791502-17937-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1319791502-17937-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281351.38664.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 28, 2011, vbyravarasu@nvidia.com wrote:
> From: venu byravarasu <vbyravarasu@nvidia.com>
> 
> With delta type being int, its value is made zero
> for all values of now > 0x80000000.
> Hence fixing it.
> 
> Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>

Thanks, looks good.  I'll add it to the linux-pm tree's pm-fixes
branch when I'm back home later this week.

Rafael


> ---
> changes since v1:
> Removed max_num and its usage references.
> ..........
> 
>  drivers/base/power/runtime.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 1079e03..e8a5172 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -30,13 +30,10 @@ static int rpm_suspend(struct device *dev, int rpmflags);
>  void update_pm_runtime_accounting(struct device *dev)
>  {
>  	unsigned long now = jiffies;
> -	int delta;
> +	unsigned long delta;
>  
>  	delta = now - dev->power.accounting_timestamp;
>  
> -	if (delta < 0)
> -		delta = 0;
> -
>  	dev->power.accounting_timestamp = now;
>  
>  	if (dev->power.disable_depth > 0)
> 

