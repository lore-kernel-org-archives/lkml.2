Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2IJS2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:28:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47451 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2IJS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:28:15 -0400
Date: Mon, 10 Sep 2012 20:29:29 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: export a safe netdev_priv wrapper for candev
Message-ID: <20120910182929.GC2006@gmail.com>
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142507.GA11000@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910142507.GA11000@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00468-g15b91d3
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

On Mon, Sep 10, 2012 at 04:25:07PM +0200, Kurt Van Dijck wrote:
> can: export a safe netdev_priv wrapper for candev
> 
> In net_device notifier calls, it was impossible to determine
> if a CAN device is based on candev in a safe way.
> This patch adds such test in order to access candev storage
> from within those notifiers.
> 
> Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
> 
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 963e2cc..6c1e704 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -795,6 +795,18 @@ void unregister_candev(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(unregister_candev);
>  
> +/*
> + * Test if a network device is a candev based device
> + * and return the can_priv* if so.
> + */
> +struct can_priv *safe_candev_priv(struct net_device *dev)
> +{
> +	if ((dev->type != ARPHRD_CAN) || (dev->rtnl_link_ops != &can_link_ops))
> +		return NULL;
> +
> +	return netdev_priv(dev);
> +}
> +

No EXPORT_SYMBOL_GPL here?

Looks good to me a part from that.

Fabio

-- 
Fabio Baltieri
