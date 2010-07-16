Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0GPVkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:40:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62482 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0GPVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gnOivz90HiWpAOsAsB/T815hDGXOzhU9OX49k4IrJR9/GG+vmqlHY4Q+3jjjmaGBus
         M8yUT8vc9rETt+1pitEaFYligNGZnLlw0uY3hqQlFOrboV28qn8sFcb+qdhw1kAuyGpu
         GwqTlwHiz28szTbA4RfjCLLVbn9sUgeeEHQfE=
Message-ID: <4C40D1B2.7000503@garzik.org>
Date: Fri, 16 Jul 2010 17:40:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joseph Kogut <joseph.kogut@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: net: 8139cp: Improved conformance to the Linux
 coding style guidelines.
References: <1279286391-31464-1-git-send-email-joseph.kogut@gmail.com>
In-Reply-To: <1279286391-31464-1-git-send-email-joseph.kogut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 09:19 AM, Joseph Kogut wrote:
> Fixed several issues that made the 8139C+ driver nonconformant to the Linux coding style guidelines.
>
> Signed-off-by: Joseph Kogut<joseph.kogut@gmail.com>
> ---
>   drivers/net/8139cp.c |  304 +++++++++++++++++++++++++-------------------------
>   1 files changed, 153 insertions(+), 151 deletions(-)

This patch is still failing in places to recognize obvious intent of the 
code writer.



>   /*
>   	Copyright 2001-2004 Jeff Garzik<jgarzik@pobox.com>
>
> -	Copyright (C) 2001, 2002 David S. Miller (davem@redhat.com) [tg3.c]
> -	Copyright (C) 2000, 2001 David S. Miller (davem@redhat.com) [sungem.c]
> -	Copyright 2001 Manfred Spraul				    [natsemi.c]
> -	Copyright 1999-2001 by Donald Becker.			    [natsemi.c]
> -       	Written 1997-2001 by Donald Becker.			    [8139too.c]
> -	Copyright 1998-2001 by Jes Sorensen,<jes@trained-monkey.org>. [acenic.c]
> +	Copyright (C) 2001, 2002 David S. Miller (davem@redhat.com)	[tg3.c]
> +	Copyright (C) 2000, 2001 David S. Miller (davem@redhat.com)	[sungem.c]
> +	Copyright 2001 Manfred Spraul					[natsemi.c]
> +	Copyright 1999-2001 by Donald Becker.				[natsemi.c]
> +	Written 1997-2001 by Donald Becker.				[8139too.c]
> +	Copyright 1998-2001 by Jes Sorensen,<jes@trained-monkey.org>.	[acenic.c]

what is the point of this?  I would leave copyright messages as-is.


> @@ -1295,32 +1295,32 @@ static void mdio_write(struct net_device *dev, int phy_id, int location,
>   }
>
>   /* Set the ethtool Wake-on-LAN settings */
> -static int netdev_set_wol (struct cp_private *cp,
> +static int netdev_set_wol(struct cp_private *cp,
>   			   const struct ethtool_wolinfo *wol)
>   {
>   	u8 options;
>
> -	options = cpr8 (Config3)&  ~(LinkUp | MagicPacket);
> +	options = cpr8(Config3)&  ~(LinkUp | MagicPacket);
>   	/* If WOL is being disabled, no need for complexity */
>   	if (wol->wolopts) {
> -		if (wol->wolopts&  WAKE_PHY)	options |= LinkUp;
> -		if (wol->wolopts&  WAKE_MAGIC)	options |= MagicPacket;
> +		if (wol->wolopts&  WAKE_PHY) options |= LinkUp;
> +		if (wol->wolopts&  WAKE_MAGIC) options |= MagicPacket;
>   	}
>
> -	cpw8 (Cfg9346, Cfg9346_Unlock);
> -	cpw8 (Config3, options);
> -	cpw8 (Cfg9346, Cfg9346_Lock);
> +	cpw8(Cfg9346, Cfg9346_Unlock);
> +	cpw8(Config3, options);
> +	cpw8(Cfg9346, Cfg9346_Lock);
>
>   	options = 0; /* Paranoia setting */
> -	options = cpr8 (Config5)&  ~(UWF | MWF | BWF);
> +	options = cpr8(Config5)&  ~(UWF | MWF | BWF);
>   	/* If WOL is being disabled, no need for complexity */
>   	if (wol->wolopts) {
> -		if (wol->wolopts&  WAKE_UCAST)  options |= UWF;
> -		if (wol->wolopts&  WAKE_BCAST)	options |= BWF;
> -		if (wol->wolopts&  WAKE_MCAST)	options |= MWF;
> +		if (wol->wolopts&  WAKE_UCAST) options |= UWF;
> +		if (wol->wolopts&  WAKE_BCAST) options |= BWF;
> +		if (wol->wolopts&  WAKE_MCAST) options |= MWF;
>   	}

you just un-aligned things that were nicely tab-aligned


> @@ -1328,35 +1328,36 @@ static int netdev_set_wol (struct cp_private *cp,
>  }
>
>  /* Get the ethtool Wake-on-LAN settings */
> -static void netdev_get_wol (struct cp_private *cp,
> -	             struct ethtool_wolinfo *wol)
> +static void netdev_get_wol(struct cp_private *cp,
> +			   struct ethtool_wolinfo *wol)
>  {
>  	u8 options;
>
>  	wol->wolopts   = 0; /* Start from scratch */
> -	wol->supported = WAKE_PHY   | WAKE_BCAST | WAKE_MAGIC |
> -		         WAKE_MCAST | WAKE_UCAST;
> +	wol->supported = WAKE_PHY   | WAKE_BCAST | WAKE_MAGIC | WAKE_MCAST | WAKE_UCAST;
> +
>  	/* We don't need to go on if WOL is disabled */
> -	if (!cp->wol_enabled) return;
> +	if (!cp->wol_enabled)
> +		return;
>
> -	options        = cpr8 (Config3);
> -	if (options & LinkUp)        wol->wolopts |= WAKE_PHY;
> -	if (options & MagicPacket)   wol->wolopts |= WAKE_MAGIC;
> +	options        = cpr8(Config3);
> +	if (options & LinkUp) wol->wolopts |= WAKE_PHY;
> +	if (options & MagicPacket) wol->wolopts |= WAKE_MAGIC;
>
>  	options        = 0; /* Paranoia setting */
> -	options        = cpr8 (Config5);
> -	if (options & UWF)           wol->wolopts |= WAKE_UCAST;
> -	if (options & BWF)           wol->wolopts |= WAKE_BCAST;
> -	if (options & MWF)           wol->wolopts |= WAKE_MCAST;
> +	options        = cpr8(Config5);
> +	if (options & UWF) wol->wolopts |= WAKE_UCAST;
> +	if (options & BWF) wol->wolopts |= WAKE_BCAST;
> +	if (options & MWF) wol->wolopts |= WAKE_MCAST;
>  }
>
> -static void cp_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *info)

ditto


Also, it's disappointing to see so much diff noise created by
	s/func ()/func()/
but I don't suppose I'll win that battle.

	Jeff


