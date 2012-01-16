Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2APOZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:25:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45804 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab2APOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:25:38 -0500
Message-ID: <1326723932.2255.41.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=C5=A0tefan?= Gula <steweg@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Jan 2012 15:25:32 +0100
In-Reply-To: <CAGsizzJpdF5xzsEiZd5R0GD8r7pDJyz4ro=4vLBnonxfAVYg-Q@mail.gmail.com>
References: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
	 <1326719999.2255.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAGsizzJpdF5xzsEiZd5R0GD8r7pDJyz4ro=4vLBnonxfAVYg-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 janvier 2012 à 15:05 +0100, Štefan Gula a écrit :
> Dňa 16. januára 2012 14:19, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:

> > Unfortunately you call ipgre_tap_bridge_get() from
> > ipgre_tap_bridge_get_raddr() but you dont release the refcount on
> > use_count. Leak in ipgre_tunnel_xmit()
> >
> >
> >> +__be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
> >> +     const unsigned char *addr)
> >> +{
> >> +     struct ipgre_tap_bridge_entry *entry;
> >> +     entry = ipgre_tap_bridge_get(tunnel, addr);
> >
> >        So maybe you want __ipgre_tap_bridge_get(tunnel, addr); here ?
> >
> Hmmm.. I am sorry, I am maybe not that expert on C coding, as most of
> the codes were copied from linux bridge code. Can you give me a hint
> how should I change that?

I dont see in net/bridge the code you copied.

Could you give more information ?


