Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2APOsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:48:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42597 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2APOr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:47:59 -0500
MIME-Version: 1.0
In-Reply-To: <1326723932.2255.41.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
 <1326719999.2255.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAGsizzJpdF5xzsEiZd5R0GD8r7pDJyz4ro=4vLBnonxfAVYg-Q@mail.gmail.com> <1326723932.2255.41.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@gmail.com>
Date: Mon, 16 Jan 2012 15:47:38 +0100
Message-ID: <CAGsizz+LEPJEGhMEHgswFJL4=Mh9R8g9FX6BcjqH0LBp2MUg0Q@mail.gmail.com>
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Eric Dumazet <eric.dumazet@gmail.com>
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

Dňa 16. januára 2012 15:25, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> Le lundi 16 janvier 2012 à 15:05 +0100, Štefan Gula a écrit :
>> Dňa 16. januára 2012 14:19, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
>
>> > Unfortunately you call ipgre_tap_bridge_get() from
>> > ipgre_tap_bridge_get_raddr() but you dont release the refcount on
>> > use_count. Leak in ipgre_tunnel_xmit()
>> >
>> >
>> >> +__be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
>> >> +     const unsigned char *addr)
>> >> +{
>> >> +     struct ipgre_tap_bridge_entry *entry;
>> >> +     entry = ipgre_tap_bridge_get(tunnel, addr);
>> >
>> >        So maybe you want __ipgre_tap_bridge_get(tunnel, addr); here ?
>> >
>> Hmmm.. I am sorry, I am maybe not that expert on C coding, as most of
>> the codes were copied from linux bridge code. Can you give me a hint
>> how should I change that?
>
> I dont see in net/bridge the code you copied.
>
> Could you give more information ?
>
>

File: net/birdge/br_fdb.c
Functions:
__br_fdb_get
br_fdb_get
My analogy fuctions:
__ipgre_tap_bridge_get
ipgre_tap_bridge_get

-- 
Stefan Gula
