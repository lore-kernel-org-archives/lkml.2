Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2KLLUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:20:40 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3200 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2KLLUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:20:38 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1352719205.5201.7.camel@lb-tlvb-dmitry.il.broadcom.com>
Subject: Re: [PATCH v2 3/3] ipgre: capture inner headers during
 encapsulation
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Joseph Gasparakis" <joseph.gasparakis@intel.com>
cc: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>
Date: Mon, 12 Nov 2012 13:20:05 +0200
In-Reply-To: <1352709418-28996-4-git-send-email-joseph.gasparakis@intel.com>
References: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
 <1352709418-28996-4-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CBE050F3P81714505-12-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My last comment was rejected by the lists due to html tag.
Resending it in plain text. Sorry for the spam.
On Mon, 2012-11-12 at 00:36 -0800, Joseph Gasparakis wrote:
> Populating the inner header pointers of skb for ipgre
> This patch has been compile-tested only.
> 
> Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> ---
>  net/ipv4/ip_gre.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 7240f8e..e35ed52 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -766,8 +766,10 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
>  	int    gre_hlen;
>  	__be32 dst;
>  	int    mtu;
> +	unsigned int offset;
>  
> -	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> +	if (!(skb->dev->features & NETIF_F_HW_CSUM_ENC_BIT) &&
> +	    skb->ip_summed == CHECKSUM_PARTIAL &&
>  	    skb_checksum_help(skb))
>  		goto tx_error;
Gre device currently has constant features set, which does not include
CSUM_ENC bit. Do you plan to propagate it from underlying physical
device?
Thanks.



