Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2KKPSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:18:44 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4531 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2KKPSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:18:43 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <1352647110.5201.4.camel@lb-tlvb-dmitry.il.broadcom.com>
Subject: Re: [PATCH 3/3] ipgre: capture inner headers during
 encapsulation
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Joseph Gasparakis" <joseph.gasparakis@intel.com>
cc: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>
Date: Sun, 11 Nov 2012 17:18:30 +0200
In-Reply-To: <1352427483-4380-4-git-send-email-joseph.gasparakis@intel.com>
References: <1352427483-4380-1-git-send-email-joseph.gasparakis@intel.com>
 <1352427483-4380-4-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7C811EBB3R0791904-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 18:18 -0800, Joseph Gasparakis wrote:
>  
>  	if (skb->ip_summed == CHECKSUM_PARTIAL &&
>  	    skb_checksum_help(skb))
> @@ -902,6 +903,17 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
>  			tunnel->err_count = 0;
>  	}
>  
> +	offset = skb->data - skb->head;
> +
> +	skb_reset_inner_mac_header(skb);
> +
> +	if (skb->network_header)
> +		skb_set_inner_network_header(skb, skb->network_header - offset);
> +
> +	if (skb->transport_header)
> +		skb_set_inner_transport_header(skb, skb->transport_header -
> +					       offset);
> +
>  	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + rt->dst.header_len;
>  
>  	if (skb_headroom(skb) < max_headroom || skb_shared(skb)||

How it will be useful if skb_checksum_help(skb) will calculate csum? And
leaves nothing to offload 



