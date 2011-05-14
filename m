Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1ENORG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:17:06 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:52305 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab1ENORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:17:02 -0400
Date: Sat, 14 May 2011 16:14:36 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Maxin B John <maxin.john@gmail.com>
Cc: kaber@trash.net, yoshfuji@linux-ipv6.org, jmorris@namei.org,
        pekkas@netcore.fi, kuznet@ms2.inr.ac.ru, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv6: mcast: Removing invalid check
Message-ID: <20110514161436.570ffd93@absol.kitzblitz>
In-Reply-To: <20110514134307.GA3603@maxin>
References: <20110514134307.GA3603@maxin>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maxin B John <maxin.john@gmail.com>:
> Since the variable 'first' is assigned to 1, the check
> "if (truncate && !first)" will always be false.
> 
> Thanks to Coverity for spotting this issue.
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---

I don't see that. We are within a 'for' loop, and some lines
below you will find an assignment of 'first = 0;'.

Best regards,
Nicolas Kaiser

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
