Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1CWLWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:22:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64481 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab1CWLWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NLPejzKr+FuWhnR6bF/lK95cKabd6622TXKos7fRBd8W03ArUA6E5d/rXpK1NlOYBf
         6hPaNQx8eaIdWhvcNUrdFiKfZxxm15jLHuzt+3Wt5eR5BfuvEZZ8PLsqOj/9YUIp/RKF
         Qm/voJw2/nGsAQbQqHfS+QLcYk27/r1V8FhqY=
MIME-Version: 1.0
In-Reply-To: <1300873779.3063.39.camel@edumazet-laptop>
References: <AANLkTinacRCOx+z02n1OwBjGfVL5itzZs7Jqv_4PRXZK@mail.gmail.com>
	<1300873779.3063.39.camel@edumazet-laptop>
Date: Wed, 23 Mar 2011 14:22:12 +0300
Message-ID: <AANLkTikP5eBNQp2jwMKeFG-ZxcQGGkKdCfcds9D6t0dd@mail.gmail.com>
Subject: Re: 2.6.39-rc: WARNING: at __ip_select_ident+0xd3/0xf0()
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Alexander for this bug report.
>
> Here is a patch to fix this issue (and other crash you mentioned in next
> mail)
>
Hi Eric,
Thank you for the fix, have not it checked however.

I did not know that the second problem
(https://lkml.org/lkml/2011/3/23/38) had the same reason.
I did not notice inetpeer_free_rcu() in its calltrace.

Thanks for that.
>
> [PATCH] ipv4: fix ip_rt_update_pmtu()
>
> commit 2c8cec5c10bc (Cache learned PMTU information in inetpeer) added
> an extra inet_putpeer() call in ip_rt_update_pmtu().
>
> This results in various problems, since we can free one inetpeer, while
> it is still in use.
>
> Ref: http://www.spinics.net/lists/netdev/msg159121.html
>
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  net/ipv4/route.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 870b518..34921b0 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1593,8 +1593,6 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu)
>                        rt->rt_peer_genid = rt_peer_genid();
>                }
>                check_peer_pmtu(dst, peer);
> -
> -               inet_putpeer(peer);
>        }
>  }
>
>
>
>
