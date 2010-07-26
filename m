Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0GZKrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:47:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39031 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0GZKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:47:45 -0400
Date: Mon, 26 Jul 2010 06:44:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drop_monitor: use genl_register_family_with_ops()
Message-ID: <20100726104423.GA14198@hmsreliant.think-freely.org>
References: <1280136017-17526-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280136017-17526-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 05:20:17PM +0800, Changli Gao wrote:
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

> ----
>  net/core/drop_monitor.c |   19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 646ef3b..bdb0e96 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -357,21 +357,12 @@ static int __init init_net_drop_monitor(void)
>  		return -ENOSPC;
>  	}
>  
> -	if (genl_register_family(&net_drop_monitor_family) < 0) {
> +	rc = genl_register_family_with_ops(&net_drop_monitor_family,
> +					   dropmon_ops,
> +					   ARRAY_SIZE(dropmon_ops));
> +	if (rc) {
>  		printk(KERN_ERR "Could not create drop monitor netlink family\n");
> -		return -EFAULT;
> -	}
> -
> -	rc = -EFAULT;
> -
> -	for (i = 0; i < ARRAY_SIZE(dropmon_ops); i++) {
> -		ret = genl_register_ops(&net_drop_monitor_family,
> -					&dropmon_ops[i]);
> -		if (ret) {
> -			printk(KERN_CRIT "Failed to register operation %d\n",
> -				dropmon_ops[i].cmd);
> -			goto out_unreg;
> -		}
> +		return rc;
>  	}
>  
>  	rc = register_netdevice_notifier(&dropmon_net_notifier);
> 

Looks good to me, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>
