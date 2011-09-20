Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1ITVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:09:59 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4608 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1ITVJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:09:58 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Tue, 20 Sep 2011 14:09:29 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Kasper Pedersen" <kernel@kasperkp.dk>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tg3: fix VLAN tagging regression
Message-ID: <20110920210929.GA9652@mcarlson.broadcom.com>
References: <4E78FC38.7040903@kasperkp.dk>
MIME-Version: 1.0
In-Reply-To: <4E78FC38.7040903@kasperkp.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 6267DD083KO22059389-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 01:48:56PM -0700, Kasper Pedersen wrote:
> commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
>     tg3: Simplify tx bd assignments
> 
> broke VLAN tagging on outbound packets.
> It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
> is not set anywhere. So vlan never gets set, and
> all packets are sent with vlan=0.
> 
> Change to use the CONFIG_VLAN_xxx defines instead.
> Tested on BCM5721 rev 11.
> 
> Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>

Yes.  This is correct.

Acked-by: Matt Carlson <mcarlson@broadcom.com>

> ---
>  drivers/net/tg3.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index dc3fbf6..a00d21b 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -6234,7 +6234,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		}
>  	}
>  
> -#ifdef BCM_KERNEL_SUPPORTS_8021Q
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
>  	if (vlan_tx_tag_present(skb)) {
>  		base_flags |= TXD_FLAG_VLAN;
>  		vlan = vlan_tx_tag_get(skb);
> 
> 

