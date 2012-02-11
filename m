Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2BKJOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 04:14:33 -0500
Received: from smtp1.infomaniak.ch ([84.16.68.89]:55089 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2BKJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 04:14:30 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Feb 2012 04:14:29 EST
Message-ID: <4F362F4B.4060903@brownhat.org>
Date: Sat, 11 Feb 2012 10:05:15 +0100
From: Daniele Venzano <venza@brownhat.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/50] sis900: use dev_hw_addr_random() instead of random_ether_addr()
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-25-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1328735457-29986-25-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08.02.2012 22:10, Danny Kukawka ha scritto:

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.

Acked-by: Daniele Venzano <venza@brownhat.org>

> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/net/ethernet/sis/sis900.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
> index c8efc70..cbd0343 100644
> --- a/drivers/net/ethernet/sis/sis900.c
> +++ b/drivers/net/ethernet/sis/sis900.c
> @@ -527,7 +527,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
>  		ret = sis900_get_mac_addr(pci_dev, net_dev);
>  
>  	if (!ret || !is_valid_ether_addr(net_dev->dev_addr)) {
> -		random_ether_addr(net_dev->dev_addr);
> +		dev_hw_addr_random(net_dev, net_dev->dev_addr);
>  		printk(KERN_WARNING "%s: Unreadable or invalid MAC address,"
>  				"using random generated one\n", dev_name);
>  	}


