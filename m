Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab1AEJuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:50:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41111 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1AEJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=CrIjqysq/bUHZwqC47Aa9oPMqLlEzFWZccxHwZAutWLEN+93S7fEx74vAwZeZQBp54
         eByMiOJFqMCIVWbYJuQ5xc8DDv3p7vQpj74sts6CtGmRSyR7EWSgNKkpaajgLNuWEbal
         XBf4qP6fzBhq3/5ai1KxcymRfVTox+Ew5iaF0=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] net: r6040: Return proper error for r6040_init_one
Date: Wed, 5 Jan 2011 10:50:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-server; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
References: <1294216804.19064.2.camel@mola>
In-Reply-To: <1294216804.19064.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101051050.45381.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 January 2011 09:40:04 Axel Lin wrote:
> Return -ENOMEM instead of 0 for the case of mdiobus_alloc and kmalloc
> failure.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/net/r6040.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
> index 0b014c89..27e6f6d 100644
> --- a/drivers/net/r6040.c
> +++ b/drivers/net/r6040.c
> @@ -1153,6 +1153,7 @@ static int __devinit r6040_init_one(struct pci_dev
> *pdev, lp->mii_bus = mdiobus_alloc();
>  	if (!lp->mii_bus) {
>  		dev_err(&pdev->dev, "mdiobus_alloc() failed\n");
> +		err = -ENOMEM;
>  		goto err_out_unmap;
>  	}
> 
> @@ -1165,6 +1166,7 @@ static int __devinit r6040_init_one(struct pci_dev
> *pdev, lp->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
> if (!lp->mii_bus->irq) {
>  		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
> +		err = -ENOMEM;
>  		goto err_out_mdio;
>  	}
