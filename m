Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1AERnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:43:51 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:37009 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1AERnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:43:50 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ixp4xx_eth: Return proper error for eth_init_one
References: <1294205046.8294.2.camel@mola>
Date: Wed, 05 Jan 2011 18:43:22 +0100
In-Reply-To: <1294205046.8294.2.camel@mola> (Axel Lin's message of "Wed, 05
	Jan 2011 13:24:06 +0800")
Message-ID: <m3bp3vi6v9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> Return PTR_ERR(port->phydev) instead of 1 if phy_connect failed.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

> --- a/drivers/net/arm/ixp4xx_eth.c
> +++ b/drivers/net/arm/ixp4xx_eth.c
> @@ -1229,8 +1229,10 @@ static int __devinit eth_init_one(struct platform_device *pdev)
>  	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT, "0", plat->phy);
>  	port->phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link, 0,
>  				   PHY_INTERFACE_MODE_MII);
> -	if ((err = IS_ERR(port->phydev)))
> +	if (IS_ERR(port->phydev)) {
> +		err = PTR_ERR(port->phydev);
>  		goto err_free_mem;
> +	}
>  
>  	port->phydev->irq = PHY_POLL;

Right. Thanks.

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
-- 
Krzysztof Halasa
