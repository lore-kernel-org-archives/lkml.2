Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2FFRbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:31:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45666 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2FFRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:31:46 -0400
Subject: Re: [PATCH v9] tilegx network driver: initial support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: bhutchings@solarflare.com, arnd@arndb.de,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
References: <201205201636.q4KGaoA3003845@farm-0027.internal.tilera.com>
	 <20120520.165546.1211013675964130504.davem@davemloft.net>
	 <201205240115.q4O1FwqG006336@lab-41.internal.tilera.com>
	 <20120524.003148.700603156196416506.davem@davemloft.net>
	 <201205251853.q4PIrE7T000723@lab-41.internal.tilera.com>
	 <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 19:31:40 +0200
Message-ID: <1339003900.26966.24.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 16:12 -0400, Chris Metcalf wrote:
> This change adds support for the tilegx network driver based on the
> GXIO IORPC support in the tilegx software stack, using the on-chip
> mPIPE packet processing engine.

> +static void tile_net_setup(struct net_device *dev)
> +{
> +	ether_setup(dev);
> +	dev->netdev_ops = &tile_net_ops;
> +	dev->watchdog_timeo = TILE_NET_TIMEOUT;
> +	dev->features |= NETIF_F_LLTX;
> +	dev->features |= NETIF_F_HW_CSUM;
> +	dev->features |= NETIF_F_SG;
> +	dev->features |= NETIF_F_TSO;
> +	dev->tx_queue_len = 0;
> +	dev->mtu = 1500;
> +}

Why is tx_queue_len set to 0 ?


