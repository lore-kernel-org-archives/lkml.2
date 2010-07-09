Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0GIPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:15:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0GIPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y5Aw0Xz8nSQqM59u+F8fTJnw54K5Bec8KnjASeaa3ax4xTUZgcoyO8iLrhsLrh20dp
         VPbnKBBj1D5MWIZZL5ZlBM/tyaDqelfL/kJlT/8Dek6SWeI7cszDMS8QTEPNdA1PVR4s
         D1Dq8Ryw9no3GnWZKHMNvjVMxWODsZJDTiCMo=
Subject: Re: net/sched/act_nat.c BUG
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rodrigo Partearroyo =?ISO-8859-1?Q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Iratxo Pichel Ortiz <ipichel@albentia.com>,
       Noelia =?ISO-8859-1?Q?Mor=F3n?= <nmoron@albentia.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <201007091637.57660.rpartearroyo@albentia.com>
References: <201007091637.57660.rpartearroyo@albentia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 17:13:40 +0200
Message-ID: <1278688420.2696.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 juillet 2010 à 16:37 +0200, Rodrigo Partearroyo González
a écrit :
> Hi all,
> 
> I have been testing Stateless NAT and found that ICMP packets with length less 
> than 20 bytes were not correctly NAT'ed. I have found a BUG that makes taking 
> into account IP header length twice, so ICMP packets smaller than 20 bytes 
> were being dropped.
> 

CC netdev

> The proposed fix is:
> 
> Index: net/sched/act_nat.c
> ===================================================================
> --- net/sched/act_nat.c
> +++ net/sched/act_nat.c
> @@ -202,7 +202,7 @@
>         {
>                 struct icmphdr *icmph;
>  
> -               if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
> +               if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
>                         goto drop;
>  
>                 icmph = (void *)(skb_network_header(skb) + ihl);
> 
> Please, consider applying it.

Nice catch, but take a look at next lines too,
when call to skb_clone_writable() is done, since same error is present.

	skb_clone_writable(skb,
			   ihl + sizeof(*icmph) + sizeof(*iph))

Please submit a formal patch, with your "Signed-off-by: ...", as
documented in Documentation/SubmittingPatches

Thanks


