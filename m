Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab1JYNGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:06:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JYNGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:06:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vbyravarasu@nvidia.com
Subject: Re: [PATCH] PM: fix calculation mistake in roll-over cases
Date: Tue, 25 Oct 2011 15:08:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@suse.de,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
References: <1319538052-2480-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1319538052-2480-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251508.40854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 25, 2011, vbyravarasu@nvidia.com wrote:
> From: venu byravarasu <vbyravarasu@nvidia.com>
> 
> In case of jiffies roll over, delta is made zero.
> Hence fixing it, after taking roll over into consideration.
> 
> Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
> ---
> When jiffies roll over, calculation of time spent in the
> current state (stored in variable 'delta') is incorrect.
> Hence fixing it, after taking roll over into consideration.
> 
>  drivers/base/power/runtime.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 1079e03..bd93fb0 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -30,12 +30,13 @@ static int rpm_suspend(struct device *dev, int rpmflags);
>  void update_pm_runtime_accounting(struct device *dev)
>  {
>  	unsigned long now = jiffies;
> -	int delta;
> +	unsigned long delta;
> +	unsigned long max_num = ~0;
>  
>  	delta = now - dev->power.accounting_timestamp;
>  
> -	if (delta < 0)
> -		delta = 0;
> +	if (now < dev->power.accounting_timestamp)
> +		delta = max_num - dev->power.accounting_timestamp + now;
>  
>  	dev->power.accounting_timestamp = now;

I'm not sure how this is supposed to improve things.  Care to give more
details?

Rafael
