Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1DTUxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:53:04 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:27378 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab1DTUxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:53:01 -0400
Message-ID: <4DAF479D.7090309@chelsio.com>
Date: Wed, 20 Apr 2011 13:52:45 -0700
From: Dimitris Michailidis <dm@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 5/8] Enable cxgb3 to support zerocopy
References: <1303328216.19336.18.camel@localhost.localdomain> <1303330438.19336.57.camel@localhost.localdomain>
In-Reply-To: <1303330438.19336.57.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 01:13 PM, Shirley Ma wrote:
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
> index 9108931..93a1101 100644
> --- a/drivers/net/cxgb3/cxgb3_main.c
> +++ b/drivers/net/cxgb3/cxgb3_main.c
> @@ -3313,7 +3313,7 @@ static int __devinit init_one(struct pci_dev *pdev,
>  		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
>  		netdev->features |= NETIF_F_GRO;
>  		if (pci_using_dac)
> -			netdev->features |= NETIF_F_HIGHDMA;
> +			netdev->features |= NETIF_F_HIGHDMA | NETIF_F_ZEROCOPY;
>  
>  		netdev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
>  		netdev->netdev_ops = &cxgb_netdev_ops;

The features handling has been reworked in net-next and patches like this 
won't apply as the code you're patching has changed.  Also core code now 
does a lot of the related work and you'll need to tell it what to do with 
any new flags.

What properties does a device or driver need to meet to set this flag?  It 
seems to be set a bit too unconditionally.  For example, does it work if one 
disables scatter/gather?
