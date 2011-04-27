Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab1D0KST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:18:19 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60031 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab1D0KSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:18:18 -0400
Subject: Re: [IWL4965] TX Power requested while scanning!
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110426063211.GA2419@redhat.com>
References: <1303498582.2103.15.camel@x61.thuisdomein>
	 <20110426063211.GA2419@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 12:18:08 +0200
Message-ID: <1303899488.2050.11.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 08:32 +0200, Stanislaw Gruszka wrote:
> Warning correctly indicate a bug. Please try below patch.
> 
> diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
> index 58a2e63..46966e9 100644
> --- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
> @@ -2988,15 +2988,15 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
>  	struct iwl_priv *priv = container_of(work, struct iwl_priv,
>  			txpower_work);
>  
> +	mutex_lock(&priv->mutex);
> +
>  	/* If a scan happened to start before we got here
>  	 * then just return; the statistics notification will
>  	 * kick off another scheduled work to compensate for
>  	 * any temperature delta we missed here. */
>  	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
>  	    test_bit(STATUS_SCANNING, &priv->status))
> -		return;
> -
> -	mutex_lock(&priv->mutex);
> +		goto out;
>  
>  	/* Regardless of if we are associated, we must reconfigure the
>  	 * TX power since frames can be sent on non-radar channels while
> @@ -3006,7 +3006,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
>  	/* Update last_temperature to keep is_calib_needed from running
>  	 * when it isn't needed... */
>  	priv->last_temperature = priv->temperature;
> -
> +out:
>  	mutex_unlock(&priv->mutex);
>  }
>  

0) This (compiles and) runs without apparent problems. I haven't seen
this WARNING with this patch applied. But please note that I actually
haven't seen that WARNING with (unpatched) rc4 since reporting it (last
Friday).

1) So feel free to add a "Reported-by:" tag and, perhaps, a "Tested-by:"
tag too.


Paul Bolle

