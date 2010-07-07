Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0GGMVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:21:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45626 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0GGMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:21:14 -0400
Date: Wed, 7 Jul 2010 21:21:11 +0900
From: Simon Horman <horms@verge.net.au>
To: xiaoyu Du <tingsrain@gmail.com>
Cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: IPVS: Incorrect helper use for SCTP [was:
 wensong@linux-vs.org, horms@verge.net.au]
Message-ID: <20100707122110.GF17967@verge.net.au>
References: <AANLkTinEKn_UBpjf3k2DZn1euMM6z2UM_yeDPvdEQkav@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinEKn_UBpjf3k2DZn1euMM6z2UM_yeDPvdEQkav@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCed netdev]

Thanks,

that looks correct to me. Have you tested this change?
If so could you provided a Signed-off-by line
as per section 12 of Documentation/SubmittingPatches?

On Wed, Jul 07, 2010 at 05:19:06PM +0800, xiaoyu Du wrote:
> Hi，all
> 
> After I compared the sctp with tcp and udp, I thinkt his a bug that
> sctp_dnat_handler Incorrectly invoked ip_vs_app_pkt_out.
> below is the patch.
> 
> ---
>  net/netfilter/ipvs/ip_vs_proto_sctp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index c9a3f7a..db55759 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> @@ -173,7 +173,7 @@ sctp_dnat_handler(struct sk_buff *skb,
>                        return 0;
> 
>                /* Call application helper if needed */
> -               if (!ip_vs_app_pkt_out(cp, skb))
> +               if (!ip_vs_app_pkt_in(cp, skb))
>                        return 0;
>        }
> 
> --
> --
> To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
