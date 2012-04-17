Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2DQR1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:27:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37941 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2DQR1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:27:48 -0400
Message-ID: <4F8DA80F.6030205@gmail.com>
Date: Tue, 17 Apr 2012 10:27:43 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 1/3] netdev/of/phy: New function: of_mdio_find_bus().
References: <1334624608-26667-1-git-send-email-ddaney.cavm@gmail.com> <1334624608-26667-2-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1334624608-26667-2-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 06:03 PM, David Daney wrote:
> From: David Daney<david.daney@cavium.com>
>
> Add of_mdio_find_bus() which allows an mii_bus to be located given its
> associated the device tree node.
>
> This is needed by the follow-on patch to add a driver for MDIO bus
> multiplexers.
>
> The of_mdiobus_register() function is modified so that the device tree
> node is recorded in the mii_bus.  Then we can find it again by
> iterating over all mdio_bus_class devices.
>
> Because the OF device tree has now become an integral part of the
> kernel, this can live in mdio_bus.c (which contains the needed
> mdio_bus_class structure) instead of of_mdio.c.
>
> Signed-off-by: David Daney<david.daney@cavium.com>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: "David S. Miller"<davem@davemloft.net>
> ---
>   drivers/net/phy/mdio_bus.c |   32 ++++++++++++++++++++++++++++++++
>   drivers/of/of_mdio.c       |    2 ++
>   include/linux/of_mdio.h    |    2 ++
>   3 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 8985cc6..46e7dc5 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -88,6 +88,38 @@ static struct class mdio_bus_class = {
>   	.dev_release	= mdiobus_release,
>   };
>
> +#ifdef CONFIG_OF_MDIO
> +/* Helper function for of_phy_find_device */

This comment is incorrect.  I will resend the set with this cleaned up.

David Daney

> +static int of_mii_bus_match(struct device *dev, void *mii_bus_np)
> +{
> +	return dev->of_node == mii_bus_np;
> +}
> +/**
> + * of_mdio_find_bus - Given an mii_bus node, find the mii_bus.
> + * @mdio_np: Pointer to the mii_bus.
> + *
> + * Returns a pointer to the mii_bus, or NULL if none found.
> + *
> + * Because the association of a device_node and mii_bus is made via
> + * of_mdiobus_register(), the mii_bus cannot be found before it is
> + * registered with of_mdiobus_register().
> + *
> + */
> +struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
> +{
[...]
