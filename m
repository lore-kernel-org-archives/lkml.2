Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2AQJvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:51:16 -0500
Received: from spaceboyz.net ([87.106.131.203]:37685 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2AQJvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:51:12 -0500
Date: Tue, 17 Jan 2012 10:50:49 +0100
From: David Lamparter <equinox@diac24.net>
To: =?utf-8?Q?=C5=A0tefan?= Gula <steweg@ynet.sk>
Cc: David Lamparter <equinox@diac24.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
Message-ID: <20120117095049.GG1077372@jupiter.n2.diac24.net>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
 <20120116202907.GF1077372@jupiter.n2.diac24.net>
 <CAGsizz+NuyPHtau3b2LjCqdAGyrPf1-08v2uD0xJBSJS9qs5Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsizz+NuyPHtau3b2LjCqdAGyrPf1-08v2uD0xJBSJS9qs5Fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:52:25PM +0100, Štefan Gula wrote:
> Dňa 16. januára 2012 21:29, David Lamparter <equinox@diac24.net> napísal/a:
> > At the risk of repeating myself, Linux GRE support already has
> > provisions for multipoint tunnels. And unlike your code, those reuse the
> > existing neighbor table infrastructure, including all of its user
> > interface and introspection capabilities.
> >
> > It's actually slightly visible in your patch:
> >
> > On Mon, Jan 16, 2012 at 08:45:14PM +0100, Štefan Gula wrote:
> >> +++ linux-3.2.1-my/net/ipv4/ip_gre.c  2012-01-16 20:42:03.000000000 +0100
> >> @@ -716,7 +942,19 @@ static netdev_tx_t ipgre_tunnel_xmit(str
> > [...]
> >>               /* NBMA tunnel */
> >>
> >>               if (skb_dst(skb) == NULL) {
> >
> >
> > -David
> 
> That code you are referring to is used only for routed traffic inside
> GRE - L3 traffic over L3 routed infrastructure. My patch is dealing
> with L2 traffic over L3 routed infrastructure - so the decision here
> is based on destination MAC addresses and not based on IPv4/IPv6
> addresses.

Yes, it currently only does IPv4/IPv6 -> IPv4 through the neighbor
table. That doesn't mean it can't be extended to handle ethernet
addresses the same way.


-David
