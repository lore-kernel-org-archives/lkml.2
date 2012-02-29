Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2B2Ptz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:49:55 -0500
Received: from zmc.proxad.net ([212.27.53.206]:53167 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab2B2Ptx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:49:53 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.558
Message-ID: <4F4E48F0.80805@freebox.fr>
Date: Wed, 29 Feb 2012 16:49:04 +0100
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] bcm63xx_enet: use dev_set_mac_address() instead of
 bcm_enet_set_mac_address()
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de> <1330530176-24952-5-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1330530176-24952-5-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/29/12 16:42, Danny Kukawka a écrit :
> Use dev_set_mac_address() instead of bcm_enet_set_mac_address() directly
> to get validation checks for free.
>
> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>

Acked-by: Florian Fainelli <ffainelli@freebox.fr>

> ---
>   drivers/net/ethernet/broadcom/bcm63xx_enet.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index c7ca7ec..28184a8 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -858,7 +858,7 @@ static int bcm_enet_open(struct net_device *dev)
>
>   	/* write device mac address */
>   	memcpy(addr.sa_data, dev->dev_addr, ETH_ALEN);
> -	bcm_enet_set_mac_address(dev,&addr);
> +	dev_set_mac_address(dev,&addr);
>
>   	/* allocate rx dma ring */
>   	size = priv->rx_ring_size * sizeof(struct bcm_enet_desc);
