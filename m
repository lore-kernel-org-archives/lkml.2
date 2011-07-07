Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1GGPk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:40:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40901 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1GGPkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:40:24 -0400
Date: Thu, 7 Jul 2011 08:40:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for July 7 (net/af_packet)
Message-Id: <20110707084008.586fa694.randy.dunlap@oracle.com>
In-Reply-To: <20110707.081839.2119597618388053074.davem@davemloft.net>
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
	<20110707081202.6dddcbce.randy.dunlap@oracle.com>
	<20110707.081839.2119597618388053074.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E15D362.01D7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jul 2011 08:18:39 -0700 (PDT) David Miller wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Thu, 7 Jul 2011 08:12:02 -0700
> 
> > On Thu, 7 Jul 2011 17:25:44 +1000 Stephen Rothwell wrote:
> > 
> >> Hi all,
> >> 
> >> The next linux-next release will (probably) be next-20110718.
> >> 
> >> Changes since 20110706:
> > 
> > 
> > When CONFIG_INET is not enabled:
> > 
> > af_packet.c:(.text+0x3d130): undefined reference to `ip_defrag'
> > or
> > ERROR: "ip_defrag" [net/packet/af_packet.ko] undefined!
> 
> Sorry about that, fixed thusly:
> 
> --------------------
> packet: Fix build with INET disabled.
> 
> af_packet.c:(.text+0x3d130): undefined reference to `ip_defrag'
> or
> ERROR: "ip_defrag" [net/packet/af_packet.ko] undefined!
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  net/packet/af_packet.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index aa4c73a..d2294ad 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -456,6 +456,7 @@ static struct sock *fanout_demux_cpu(struct packet_fanout *f, struct sk_buff *sk
>  
>  static struct sk_buff *fanout_check_defrag(struct sk_buff *skb)
>  {
> +#ifdef CONFIG_INET
>  	const struct iphdr *iph;
>  	u32 len;
>  
> @@ -486,6 +487,7 @@ static struct sk_buff *fanout_check_defrag(struct sk_buff *skb)
>  			skb->rxhash = 0;
>  		}
>  	}
> +#endif
>  	return skb;
>  }
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
