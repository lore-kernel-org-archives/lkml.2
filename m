Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1D0WXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:23:15 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36530 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab1D0WXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:23:13 -0400
Date: Wed, 27 Apr 2011 15:23:10 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2 3/4] ethtool: Use the full 32 bit speed range in
 ethtool's set_settings
Message-ID: <20110427152310.248307e2@nehalam>
In-Reply-To: <1303929290-21037-4-git-send-email-decot@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
	<1303929290-21037-4-git-send-email-decot@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 11:34:48 -0700
David Decotigny <decot@google.com> wrote:

> diff --git a/drivers/net/skge.c b/drivers/net/skge.c
> index 176d784..b0fa999 100644
> --- a/drivers/net/skge.c
> +++ b/drivers/net/skge.c
> @@ -322,7 +322,7 @@ static int skge_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
>  	} else {
>  		u32 setting;
>  
> -		switch (ecmd->speed) {
> +		switch (ethtool_cmd_speed(ecmd)) {
>  		case SPEED_1000:
>  			if (ecmd->duplex == DUPLEX_FULL)
>  				setting = SUPPORTED_1000baseT_Full;
> @@ -355,7 +355,7 @@ static int skge_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
>  		if ((setting & supported) == 0)
>  			return -EINVAL;
>  
> -		skge->speed = ecmd->speed;
> +		skge->speed = ethtool_cmd_speed(ecmd);
>  		skge->duplex = ecmd->duplex;
>  	}
>  
> diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
> index c8d0451..40afe07 100644
> --- a/drivers/net/sky2.c
> +++ b/drivers/net/sky2.c
> @@ -3453,7 +3453,7 @@ static int sky2_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
>  	} else {
>  		u32 setting;
>  
> -		switch (ecmd->speed) {
> +		switch (ethtool_cmd_speed(ecmd)) {
>  		case SPEED_1000:
>  			if (ecmd->duplex == DUPLEX_FULL)
>  				setting = SUPPORTED_1000baseT_Full;
> @@ -3486,7 +3486,7 @@ static int sky2_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
>  		if ((setting & supported) == 0)
>  			return -EINVAL;
>  
> -		sky2->speed = ecmd->speed;
> +		sky2->speed = ethtool_cmd_speed(ecmd);
>  		sky2->duplex = ecmd->duplex;
>  		sky2->flags &= ~SKY2_FLAG_AUTO_SPEED;
>  	}

These two are trivial, thanks for doing it.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>


-- 
