Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0KHXbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:31:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab0KHXbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:31:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.37-rc1, patch] gianfar: fix sleep in atomic...
Date: Tue, 9 Nov 2010 00:30:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <AANLkTimf_mVrRPEcj8qBbYw1iYHfWdeKUNS3Kk-dfhTT@mail.gmail.com>
In-Reply-To: <AANLkTimf_mVrRPEcj8qBbYw1iYHfWdeKUNS3Kk-dfhTT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011090030.42693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 02, 2010, Daniel J Blueman wrote:
> Since device_set_wakeup_enable now sleeps, it should not be called
> from a critical section. Since wol_en is not updated elsewhere, we can
> omit the locking entirely.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
> index 5c566eb..e641d7c 100644
> --- a/drivers/net/gianfar_ethtool.c
> +++ b/drivers/net/gianfar_ethtool.c
> @@ -635,10 +635,8 @@ static int gfar_set_wol(struct net_device *dev,
> struct ethtool_wolinfo *wol)
>  	if (wol->wolopts & ~WAKE_MAGIC)
>  		return -EINVAL;
> 
> -	spin_lock_irqsave(&priv->bflock, flags);
>  	priv->wol_en = wol->wolopts & WAKE_MAGIC ? 1 : 0;
>  	device_set_wakeup_enable(&dev->dev, priv->wol_en);
> -	spin_unlock_irqrestore(&priv->bflock, flags);
> 
>  	return 0;
>  }
> 

