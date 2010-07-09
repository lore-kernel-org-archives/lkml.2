Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0GIRyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:54:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46144 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0GIRya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AuTgOSCaL36c2wK3dZ1pwOErNup7hq+0j8RmGgI8NfqPLNg6GE2UCny9XHFJcUK7Cl
         0Mbm8lzW1OoVJiaBA8DnZ1izhlW6h9PltgcKjS0uO4y9PkW39mhbgy0UPei/cza/5ku/
         ooQemUOuOFaq34HIJMsjbCK777EDdTHQusnXY=
Subject: Re: [PATCH 001/001] QoS and/or fair queueing: Stateless NAT BUG
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rodrigo Partearroyo =?ISO-8859-1?Q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Iratxo Pichel Ortiz <ipichel@albentia.com>,
       Noelia =?ISO-8859-1?Q?Mor=F3n?= <nmoron@albentia.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <201007091937.17349.rpartearroyo@albentia.com>
References: <201007091937.17349.rpartearroyo@albentia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 19:54:23 +0200
Message-ID: <1278698063.2696.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 juillet 2010 à 19:37 +0200, Rodrigo Partearroyo González
a écrit :
> Hi all,
> I have been testing Stateless NAT and found that ICMP packets with length
> less than 20 bytes were not correctly NAT'ed. I have found a BUG that
> makes taking into account IP header length twice, so ICMP packets smaller
> than 20 bytes were being dropped.
> 
> Proposed formal patch is below, as suggested by Eric Dumazet, thanks.
> It is taken from 2.6.34.1 stable version.
> 
> Signed-off-by: Rodrigo Partearroyo González <rpartearroyo@albentia.com>

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

> ---
> diff -uprN a/net/sched/act_nat.c b/net/sched/act_nat.c
> --- a/net/sched/act_nat.c	2010-07-09 18:25:18.000000000 +0200
> +++ b/net/sched/act_nat.c	2010-07-09 18:26:16.000000000 +0200
> @@ -202,7 +202,7 @@ static int tcf_nat(struct sk_buff *skb, 
>  	{
>  		struct icmphdr *icmph;
>  
> -		if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
> +		if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
>  			goto drop;
>  
>  		icmph = (void *)(skb_network_header(skb) + ihl);
> @@ -223,7 +223,7 @@ static int tcf_nat(struct sk_buff *skb, 
>  
>  		if (skb_cloned(skb) &&
>  		    !skb_clone_writable(skb,
> -					ihl + sizeof(*icmph) + sizeof(*iph)) &&
> +					ihl + sizeof(*icmph)) &&
>  		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
>  			goto drop;
> 




