Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030963Ab2CUOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:14:12 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12644 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030828Ab2CUOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:14:10 -0400
Date: Wed, 21 Mar 2012 15:13:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to
 enable/disable
Message-ID: <20120321151357.53fb86e4@endymion.delvare>
In-Reply-To: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 16:40:01 +0530, Amit Daniel Kachhap wrote:
> Basically without this patch changing the mode of thermal zone
> is not possible as wrong string size is passed to strncmp.

Actually it is possible,
$ echo -n disabled > mode
works fine. But it fails without the -n, your patch would fix that.

Acked-by: Jean Delvare <khali@linux-fr.org>

Note that a quick grep suggests that drivers/misc/ad525x_dpot.c,
security/selinux/hooks.c and arch/m68k/sun3/prom/console.c suffer from
the same issue, if you want to fix them too.

> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> ---
>  drivers/thermal/thermal_sys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 220ce7e..96da1af 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -152,9 +152,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
>  	if (!tz->ops->set_mode)
>  		return -EPERM;
>  
> -	if (!strncmp(buf, "enabled", sizeof("enabled")))
> +	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
>  		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
> -	else if (!strncmp(buf, "disabled", sizeof("disabled")))
> +	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
>  		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
>  	else
>  		result = -EINVAL;


-- 
Jean Delvare
