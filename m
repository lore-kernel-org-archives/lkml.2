Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FHRpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:45:38 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:39247 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0FHRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:45:37 -0400
Date: Tue, 8 Jun 2010 19:45:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Alexander Clouter <alex@digriz.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100608174536.GW1743@mail.wantstofly.org>
References: <4c0e7d5a.0c3ddf0a.2771.ffffd485@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0e7d5a.0c3ddf0a.2771.ffffd485@mx.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 08:24:40PM +0300, Dmytro Milinevskyy wrote:

> diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
> index ad3f1ec..5d6797a 100644
> --- a/arch/arm/mach-kirkwood/openrd-setup.c
> +++ b/arch/arm/mach-kirkwood/openrd-setup.c
> @@ -47,6 +47,14 @@ static struct mv643xx_eth_platform_data openrd_ge01_data = {
>  	.phy_addr	= MV643XX_ETH_PHY_ADDR(24),
>  };
>  
> +static struct mv643xx_eth_platform_data openrd_ultimate_ge00_data = {
> +	.phy_addr	= MV643XX_ETH_PHY_ADDR(0),
> +};
> +
> +static struct mv643xx_eth_platform_data openrd_ultimate_ge01_data = {
> +	.phy_addr	= MV643XX_ETH_PHY_ADDR(1),
> +};
> +
>  static struct mv_sata_platform_data openrd_sata_data = {
>  	.n_ports	= 2,
>  };
> @@ -73,9 +81,14 @@ static void __init openrd_init(void)
>  
>  	kirkwood_ehci_init();
>  
> -	kirkwood_ge00_init(&openrd_ge00_data);
> -	if (machine_is_openrd_client())
> -		kirkwood_ge01_init(&openrd_ge01_data);
> +	if (machine_is_openrd_ultimate()) {
> +		kirkwood_ge00_init(&openrd_ultimate_ge00_data);
> +		kirkwood_ge01_init(&openrd_ultimate_ge01_data);
> +	} else {
> +		kirkwood_ge00_init(&openrd_ge00_data);
> +		if (machine_is_openrd_client())
> +			kirkwood_ge01_init(&openrd_ge01_data);
> +	}

Just write the PHY addresses into openrd_ge0[01]_data here iff
machine_is_openrd_ultimate()?
