Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0LKV4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 16:56:09 -0500
Received: from void.printf.net ([89.145.121.20]:60668 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0LKV4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 16:56:07 -0500
Date: Sat, 11 Dec 2010 21:55:57 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Oliver Neukum <oneukum@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Fix re-probing after hibernation
Message-ID: <20101211215557.GA25693@void.printf.net>
References: <1291821839-15088-1-git-send-email-tiwai@suse.de> <20101209015303.GB19741@void.printf.net> <s5hlj3z1ksb.wl%tiwai@suse.de> <201012092137.24603.rjw@sisk.pl> <s5h39q6yt1s.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h39q6yt1s.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Fri, Dec 10, 2010 at 08:40:31AM +0100, Takashi Iwai wrote:
> Subject: [PATCH] mmc: Fix re-probing with PM_POST_RESTORE notification
> 
> In the error-path where PM notifies PM_POST_RESTORE, the rescan-blockage
> should be cleared as well.  Otherwise it'll be never re-probed.
> 
> Also, as a bonus, this fixes a bug in S4 with user-mode suspend in the
> current code, as it sends PM_POST_RESTORE instead of
> PM_POST_HIBERNATION wrongly.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 31ae07a..57dcf8f 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1773,6 +1773,7 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>  
>  	case PM_POST_SUSPEND:
>  	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
>  
>  		spin_lock_irqsave(&host->lock, flags);
>  		host->rescan_disable = 0;

Thanks, have pushed this to mmc-next and queued it for .37/stable.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
