Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1JTX2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:28:17 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:28827 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1JTX2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:28:15 -0400
Message-ID: <1319153279.2918.16.camel@deadeye>
Subject: Re: [RFC PATCH 15/17] phy_device: Add "port" and "transciever"
 fields
From: Ben Hutchings <bhutchings@solarflare.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Decotigny <decot@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Date: Fri, 21 Oct 2011 00:27:59 +0100
In-Reply-To: <1319144425-15547-16-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
	 <1319144425-15547-16-git-send-email-Kyle.D.Moffett@boeing.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Oct 2011 23:28:15.0144 (UTC) FILETIME=[F0DB8A80:01CC8F7F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18460.005
X-TM-AS-Result: No--11.379900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 17:00 -0400, Kyle Moffett wrote:
> Some PHYs have multiple software-selectable inputs and outputs,
> including RGMII, SGMII, SerDes, etc.  New fields are added to the
> "struct phy_device" for "port" and "transciever" to allow "ethtool" to
> switch outputs at runtime.  The defaults for the new fields are
> identical to the hardcoded values used previously.
> 
> This should make no functional changes to the PHY layer behavior, but
> it will allow later PHY/ethernet drivers to override those fields.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
>  drivers/net/phy/phy.c        |    4 ++--
>  drivers/net/phy/phy_device.c |    2 ++
>  include/linux/phy.h          |    4 ++++
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index c378f91..5f72055 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -290,9 +290,9 @@ int phy_ethtool_gset(struct phy_device *phydev, struct ethtool_cmd *cmd)
>  
>  	ethtool_cmd_speed_set(cmd, phydev->speed);
>  	cmd->duplex = phydev->duplex;
> -	cmd->port = PORT_MII;
> +	cmd->port = phydev->port;
>  	cmd->phy_address = phydev->addr;
> -	cmd->transceiver = XCVR_EXTERNAL;
> +	cmd->transceiver = phydev->transciever;

'transceiver' is spelt thus.

[...]
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -308,6 +308,10 @@ struct phy_device {
>  	u32 supported;
>  	u32 advertising;
>  
> +	/* The current port/xcvr info (Copper, Fibre, MII, Direct-Attach) */
> +	u8 port;
> +	u8 transceiver;
> +

And yet you got it right here.

Ben.

>  	int autoneg;
>  
>  	int link_timeout;

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

