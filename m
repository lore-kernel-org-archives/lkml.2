Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab2APWwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:52:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2APWwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120116202907.GF1077372@jupiter.n2.diac24.net>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
 <20120116202907.GF1077372@jupiter.n2.diac24.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Mon, 16 Jan 2012 23:52:25 +0100
X-Google-Sender-Auth: JmY6qWVrd9encvAzfldp7MDWWlA
Message-ID: <CAGsizz+NuyPHtau3b2LjCqdAGyrPf1-08v2uD0xJBSJS9qs5Fg@mail.gmail.com>
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: David Lamparter <equinox@diac24.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dňa 16. januára 2012 21:29, David Lamparter <equinox@diac24.net> napísal/a:
> At the risk of repeating myself, Linux GRE support already has
> provisions for multipoint tunnels. And unlike your code, those reuse the
> existing neighbor table infrastructure, including all of its user
> interface and introspection capabilities.
>
> It's actually slightly visible in your patch:
>
> On Mon, Jan 16, 2012 at 08:45:14PM +0100, Štefan Gula wrote:
>> +++ linux-3.2.1-my/net/ipv4/ip_gre.c  2012-01-16 20:42:03.000000000 +0100
>> @@ -716,7 +942,19 @@ static netdev_tx_t ipgre_tunnel_xmit(str
> [...]
>>               /* NBMA tunnel */
>>
>>               if (skb_dst(skb) == NULL) {
>
>
> -David

That code you are referring to is used only for routed traffic inside
GRE - L3 traffic over L3 routed infrastructure. My patch is dealing
with L2 traffic over L3 routed infrastructure - so the decision here
is based on destination MAC addresses and not based on IPv4/IPv6
addresses.

-- 
Stefan Gula
CCNP, CCIP
