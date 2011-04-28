Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1D1EtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:49:06 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52343 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab1D1EtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:49:05 -0400
Date: Wed, 27 Apr 2011 21:49:02 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: artpol <artpol84@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        bhutchings@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.38.4] mii: add support of pause frames in mii_get_an
Message-ID: <20110427214902.0826a4d1@nehalam>
In-Reply-To: <1303962554.15395.1.camel@artpol-thinkpad>
References: <1303962554.15395.1.camel@artpol-thinkpad>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 10:49:14 +0700
artpol <artpol84@gmail.com> wrote:

> Add support of pause frames advertise in mii_get_an. This provides all drivers 
> that use mii_ethtool_gset to represent their own and Link partner flow control
> abilities in ethtool.
> 
> Signed-off-by: Artem Polyakov <artpol84@gmail.com>
> 
> ---
> 
> --- linux-2.6.38.4/drivers/net/mii.c.orig	2011-04-28 08:46:13.000000000 +0700
> +++ linux-2.6.38.4/drivers/net/mii.c	2011-04-25 23:04:20.694981968 +0700
> @@ -49,6 +49,10 @@ static u32 mii_get_an(struct mii_if_info
>  		result |= ADVERTISED_100baseT_Half;
>  	if (advert & ADVERTISE_100FULL)
>  		result |= ADVERTISED_100baseT_Full;
> +	if (advert & ADVERTISE_PAUSE_CAP)
> +		result |= ADVERTISED_Pause;
> +	if (advert & ADVERTISE_PAUSE_ASYM)
> +		result |= ADVERTISED_Asym_Pause;
>  
>  	return result;
>  }

One common driver problem is that auto negotiation of pause
is really a separate operation from negotiation of speed.
It should be possible to force no flow-control but still negotiate
speed and vice-versa.  The ethtool api breaks this into two operations
but many drivers munge them together.
