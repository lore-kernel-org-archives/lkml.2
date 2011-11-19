Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1KSNne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:43:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1KSNnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:43:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Suspend: Fix bug in suspend statistics update
Date: Sat, 19 Nov 2011 14:46:17 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, shuox.liu@intel.com
References: <20111119092019.27505.77215.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111119092019.27505.77215.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111191446.17426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 19, 2011, Srivatsa S. Bhat wrote:
> A pair of missing braces inside the state_store() function causes even
> invalid arguments to suspend to be wrongly treated as failed suspend
> attempts. Fix this.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Good catch!  Applied to linux-pm/pm-fixes.

Thanks,
Rafael


> ---
> 
>  kernel/power/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 71f49fe..36e0f09 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -290,13 +290,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
>  			break;
>  	}
> -	if (state < PM_SUSPEND_MAX && *s)
> +	if (state < PM_SUSPEND_MAX && *s) {
>  		error = enter_state(state);
>  		if (error) {
>  			suspend_stats.fail++;
>  			dpm_save_failed_errno(error);
>  		} else
>  			suspend_stats.success++;
> +	}
>  #endif
>  
>   Exit:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

