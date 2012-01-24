Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2AXLGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:06:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45252 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AXLGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:06:52 -0500
Message-ID: <4F1E90B6.6090106@openwrt.org>
Date: Tue, 24 Jan 2012 12:06:30 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        giancarlo.asnaghi@st.com, peppe.cavallaro@st.com
Subject: Re: stmmac: fix phy naming inconsistency
References: <20120124092648.GA26380@mail.gnudd.com>
In-Reply-To: <20120124092648.GA26380@mail.gnudd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alessandro,

On 01/24/12 10:26, Alessandro Rubini wrote:
> After commit "db8857b stmmac: use an unique MDIO bus name" my
> device stopped being probed because two different names were being
> used in different places. This fixes the inconsistency.
>
> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>
> Cc: Giuseppe Cavallaro<peppe.cavallaro@st.com>
> Cc: Florian Fainelli<florian@openwrt.org>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>
> Before the commit, the phy was identified like this and stuff worked:
>
>       PHY ID 20005c90 at 1 IRQ 0 (506:01) active
>
> After that commit, I get
>
>       PHY ID 20005c90 at 1 IRQ 0 (STMMAC MII Bus-1:01) active
>       PHY stmmac-1:01 not found
>
> In one place, "stmmac" is a static string, on the other the commit
> used the name field of the bus that was "STMMAC MII Bus", so I changed
> this older string to be nicer -- without spaces.
>
> Maybe the name is available where "stmmac" is spelled out, but I
> didn't check.
>
> Now it works for me:
>
>      eth1: PHY ID 20005c90 at 1 IRQ 0 (stmmac-1:01) active
>      PHY: stmmac-1:01 - Link is Up - 100/Full
>
>
>   drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 6e712c5..819606e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -154,7 +154,7 @@ int stmmac_mdio_register(struct net_device *ndev)
>   	else
>   		irqlist = priv->mii_irq;
>
> -	new_bus->name = "STMMAC MII Bus";
> +	new_bus->name = "stmmac";
>   	new_bus->read =&stmmac_mdio_read;
>   	new_bus->write =&stmmac_mdio_write;
>   	new_bus->reset =&stmmac_mdio_reset;

