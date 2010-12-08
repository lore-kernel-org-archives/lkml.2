Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0LHWFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:05:00 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:65230 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LHWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QYxQJLQITH7pLKIX5Su9P1854kQGKCKCLzzZSrWWoJbB0GJe+IMwhtMJh1b2+mdVBQ
         PA8KShaVOfbSKFZCPquNdfmmUkSCjOIJ/Z45imSzF5eeFQy9RkPSZzxdjSnJshKjWshD
         pJA5RAhjmnCUs4yCfO3z3ucVy9FImNa9q0xSU=
Subject: Re: [PATCH] mmc: Fix re-probing after hibernation
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Ball <cjb@laptop.org>, Oliver Neukum <oneukum@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291821839-15088-1-git-send-email-tiwai@suse.de>
References: <1291821839-15088-1-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 00:04:52 +0200
Message-ID: <1291845892.5421.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 16:23 +0100, Takashi Iwai wrote:
> The commit 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e
>   mmc: fix all hangs related to mmc/sd card insert/removal during
>   suspend/resume
> introduced a bug where the device probing no longer works after
> hibernation.  This was because the pm notifier expects
> PM_POST_HIBERNATION call while the system sends PM_POST_RESTORE
> instead, thus disable_rescan is kept as 1.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 31ae07a..30094f6 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1772,7 +1772,7 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>  		break;
>  
>  	case PM_POST_SUSPEND:
> -	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
>  
>  		spin_lock_irqsave(&host->lock, flags);
>  		host->rescan_disable = 0;

So that was the case....
Takasi, thank you very much.

I always use the 'unsafe resume' thing so I wasn't affected.

Best regards,
	Maxim Levitsky


