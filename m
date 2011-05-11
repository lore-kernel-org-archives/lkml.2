Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1EKUrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:47:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36552 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab1EKUrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:47:46 -0400
Date: Wed, 11 May 2011 13:47:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Miller <davem@davemloft.net>
Subject: Re: PM / Wakeup: remove useless synchronize_rcu() call
Message-ID: <20110511204743.GD2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1305144959.3232.5.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305144959.3232.5.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:15:59PM +0200, Eric Dumazet wrote:
> wakeup_source_add() adds an item into wakeup_sources list.
> 
> There is no need to call synchronize_rcu() at this point.
> 
> Its only needed in wakeup_source_remove()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

> CC: David Miller <davem@davemloft.net>,
> CC: Greg Kroah-Hartman <gregkh@suse.de>
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
