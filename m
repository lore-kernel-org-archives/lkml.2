Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1ENOdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:33:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46945 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1ENOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NYutR7FO0Zz0K+DDc9WR/iOxCNBd/FEnEmfh2Iy8+YvANnf1XyGv+Rtx9U6TjmooYG
         APDcFnvHw7zEMqiYIb0St8g4W0pZ18Iy51kUyO7xF6OwBWg2KBmW+WR3ef+VyrSGdFJV
         Pw0vNejZhxCMUDuz9zKPf0B+m9Ta+lYbrwMAQ=
Subject: Re: [PATCH] net: ipv6: mcast: Removing invalid check
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Maxin B John <maxin.john@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, pekkas@netcore.fi,
        kuznet@ms2.inr.ac.ru, davem@davemloft.net
In-Reply-To: <20110514134307.GA3603@maxin>
References: <20110514134307.GA3603@maxin>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 16:33:30 +0200
Message-ID: <1305383610.3120.62.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 mai 2011 à 16:43 +0300, Maxin B John a écrit :
> Since the variable 'first' is assigned to 1, the check
> "if (truncate && !first)" will always be false.
> 
> Thanks to Coverity for spotting this issue.
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 76b8937..441c1a4 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c
> @@ -1536,8 +1536,6 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
>  
>  		if (AVAILABLE(skb) < sizeof(*psrc) +
>  		    first*sizeof(struct mld2_grec)) {
> -			if (truncate && !first)
> -				break;	 /* truncate these */
>  			if (pgr)
>  				pgr->grec_nsrcs = htons(scount);
>  			if (skb)

At a first glance, I would say Coverity is wrong, unless you can explain
why it's right ;)

first can be 0 at this point, we are in a loop.

BTW "Removing invalid check" is a really wrong patch title.

Once you can prove your point, you should use "Remove useless check"

Thanks


