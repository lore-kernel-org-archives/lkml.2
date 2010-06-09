Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0FIUs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:48:57 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:60568 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0FIUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:48:56 -0400
X-Greylist: delayed 693 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 16:48:56 EDT
Date: Wed, 9 Jun 2010 21:37:20 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100609203720.GK7660@chipmunk>
References: <4c0ff6b2.0c3ddf0a.2185.2e09@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0ff6b2.0c3ddf0a.2185.2e09@mx.google.com>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Dmytro Milinevskyy <milinevskyy@gmail.com> [2010-06-09 23:14:39+0300]:
>
> This patch adds support for the OpenRD Ultimate machine(could be found 
> at http://www.arm.linux.org.uk/developer/machines/list.php?id=2884)
> 
> Besides adding machine description this patch adds correction for PHY 
> address for Ultimate version.
> 
> Differences from the previous attempt:
>  - Applied suggestion from Lennert Buytenhek to change PHY addresses 
>  in instances of mv643xx_eth_platform_data in case of ultimate 
>  version.
> 
> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
> ---
>  
> +	if (machine_is_openrd_ultimate()) {
> +		openrd_ge00_data.phy = 0;
> +		openrd_ge01_data.phy = 1;
> +	}
> +
>
Does this even work?  Surely you mean the following instead:
----
if (machine_is_openrd_ultimate()) {
	openrd_ge00_data.phy_addr = MV643XX_ETH_PHY_ADDR(0);
	openrd_ge00_data.phy_addr = MV643XX_ETH_PHY_ADDR(1);
}
----

>  	kirkwood_ge00_init(&openrd_ge00_data);
> -	if (machine_is_openrd_client())
> +	if (machine_is_openrd_client() ||      \__same line
> +		machine_is_openrd_ultimate())  /
>  		kirkwood_ge01_init(&openrd_ge01_data);
> +  <------- REMOVE
>  	kirkwood_sata_init(&openrd_sata_data);
>  	kirkwood_sdio_init(&openrd_mvsdio_data);
>  
As that 'if()' clause is still less than 77 chars wide:
----
kirkwood_ge00_init(&openrd_ge00_data);
if (machine_is_openrd_client() || machine_is_openrd_ultimate())
	kirkwood_ge01_init(&openrd_ge01_data);
kirkwood_sata_init(&openrd_sata_data);
kirkwood_sdio_init(&openrd_mvsdio_data);
----

Cheers

-- 
Alexander Clouter
.sigmonster says: People respond to people who respond.
