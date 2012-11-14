Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161236Ab2KNQLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:11:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50035 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161113Ab2KNQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:11:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/mdio: fix build errors when CONFIG_OF isn't set
To: Sasha Levin <sasha.levin@oracle.com>, rob.herring@calxeda.com,
        srinivas.kandagatla@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
In-Reply-To: <1349886683-26351-1-git-send-email-sasha.levin@oracle.com>
References: <1349886683-26351-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 14 Nov 2012 16:11:35 +0000
Message-Id: <20121114161135.71E153E0B1E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 12:31:23 -0400, Sasha Levin <sasha.levin@oracle.com> wrote:
> Commit f9dc9ac5 ("of/mdio: Add dummy functions in of_mdio.h.") has added
> empty stubs into of_mdio.h which were not static, this causes build errors
> when these symbols were defined across several objects.
> 
> Fix it by marking those stubs as 'static inline'.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Rob, can you please pick up into your merge branch for device tree?

Thanks,
g.

> ---
>  include/linux/of_mdio.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index 6ef49b8..7f17b9c 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -26,17 +26,17 @@ extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>  extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
>  
>  #else /* CONFIG_OF */
> -int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
> +static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  {
>  	return -ENOSYS;
>  }
>  
> -struct phy_device *of_phy_find_device(struct device_node *phy_np)
> +static inline struct phy_device *of_phy_find_device(struct device_node *phy_np)
>  {
>  	return NULL;
>  }
>  
> -struct phy_device *of_phy_connect(struct net_device *dev,
> +static inline struct phy_device *of_phy_connect(struct net_device *dev,
>  					 struct device_node *phy_np,
>  					 void (*hndlr)(struct net_device *),
>  					 u32 flags, phy_interface_t iface)
> @@ -44,14 +44,14 @@ struct phy_device *of_phy_connect(struct net_device *dev,
>  	return NULL;
>  }
>  
> -struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
> +static inline struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>  					 void (*hndlr)(struct net_device *),
>  					 phy_interface_t iface)
>  {
>  	return NULL;
>  }
>  
> -struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
> +static inline struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
>  {
>  	return NULL;
>  }
> -- 
> 1.7.12
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
