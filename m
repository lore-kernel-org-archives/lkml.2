Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1EKUnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:43:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab1EKUnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:43:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: PM / Wakeup: remove useless synchronize_rcu() call
Date: Wed, 11 May 2011 22:43:47 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        David Miller <davem@davemloft.net>
References: <1305144959.3232.5.camel@edumazet-laptop>
In-Reply-To: <1305144959.3232.5.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112243.47480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 11, 2011, Eric Dumazet wrote:
> wakeup_source_add() adds an item into wakeup_sources list.
> 
> There is no need to call synchronize_rcu() at this point.
> 
> Its only needed in wakeup_source_remove()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: David Miller <davem@davemloft.net>,
> CC: Greg Kroah-Hartman <gregkh@suse.de>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  drivers/base/power/wakeup.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> index abbbd33..84f7c7d 100644
> --- a/drivers/base/power/wakeup.c
> +++ b/drivers/base/power/wakeup.c
> @@ -110,7 +110,6 @@ void wakeup_source_add(struct wakeup_source *ws)
>  	spin_lock_irq(&events_lock);
>  	list_add_rcu(&ws->entry, &wakeup_sources);
>  	spin_unlock_irq(&events_lock);
> -	synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(wakeup_source_add);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

