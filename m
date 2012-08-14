Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2HNOW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:22:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34486 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756164Ab2HNOWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:22:54 -0400
Date: Tue, 14 Aug 2012 09:22:52 -0500
From: Robin Holt <holt@sgi.com>
To: Ilya Shchepetkov <shchepetkov@ispras.ru>
Cc: Robin Holt <holt@sgi.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 1/5] sgi-xp: Call netif_carrier_off() after
 register_netdev()
Message-ID: <20120814142252.GA3093@sgi.com>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
 <1344940135-17079-2-git-send-email-shchepetkov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344940135-17079-2-git-send-email-shchepetkov@ispras.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:28:51PM +0400, Ilya Shchepetkov wrote:
> For carrier detection to work properly when binding the driver with a
> cable unplugged, netif_carrier_off() should be calle after
> register_netdev(), not before.
> 
> Calling netif_carrier_off() before register_netdev() was causing the
> network interface to miss a linkwatch pending event leading to an
> inconsistent state if the link is not up when interface is initialized.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>

Acked-by: Robin Holt <holt@sgi.com>

> ---
>  drivers/misc/sgi-xp/xpnet.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
> index 3fac67a..9296c8d 100644
> --- a/drivers/misc/sgi-xp/xpnet.c
> +++ b/drivers/misc/sgi-xp/xpnet.c
> @@ -550,8 +550,6 @@ xpnet_init(void)
>  		return -ENOMEM;
>  	}
>  
> -	netif_carrier_off(xpnet_device);
> -
>  	xpnet_device->netdev_ops = &xpnet_netdev_ops;
>  	xpnet_device->mtu = XPNET_DEF_MTU;
>  
> @@ -584,6 +582,8 @@ xpnet_init(void)
>  		kfree(xpnet_broadcast_partitions);
>  	}
>  
> +	netif_carrier_off(xpnet_device);
> +
>  	return result;
>  }
>  
> -- 
> 1.7.7
