Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2AYJRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:17:48 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64989 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab2AYJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:17:45 -0500
MIME-Version: 1.0
In-Reply-To: <1327480624.14373.51.camel@edumazet-laptop>
References: <20120123.134352.1621146585245670953.davem@davemloft.net>
 <CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
 <CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
 <20120124.230203.1478271172075708903.davem@davemloft.net> <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
 <1327480624.14373.51.camel@edumazet-laptop>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 10:17:24 +0100
X-Google-Sender-Auth: dJ5_BFMSBWhCvyFZseYfO5AlJMY
Message-ID: <CAGsizz+n0HHCNdC-WKaBcrRn=yF3aLcMKeTt0OryA8TDAsHqkA@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jesse Gross <jesse@nicira.com>, David Miller <davem@davemloft.net>,
        joseph.glanville@orionvm.com.au, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0P9IIU0002434

2012/1/25 Eric Dumazet <eric.dumazet@gmail.com>:
> Le mardi 24 janvier 2012 à 23:11 -0800, Jesse Gross a écrit :
>
>> I think it's actually the opposite - Open vSwitch can be used to
>> implement this type of thing as well as for many other use cases.  On
>> the other hand, even when implementing a multipoint L2 solution it can
>> be useful to have additional levels of control but you can't do that
>> with this patch because it essentially statically glues together
>> tunneling and bridging.
>
> Unless you can provide a working solution in a very short time, this
> patch is a pragmatic one.
>
> Code is not perfect and could be improved (for example using a helper
> function to keep ipgre_rcv() shorter and reduce indentation level)
>
> Stefan, could you move this code out of ipgre_rcv() ?
>
>
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +                       if (ipv4_is_multicast(tunnel->parms.iph.daddr)) {
> +                               tethhdr = eth_hdr(skb);
> +                               if (!is_multicast_ether_addr(
> +                                       tethhdr->h_source)) {
> +                                       head = &tunnel->hash[
> +                                               ipgre_tap_bridge_hash(
> +                                                       tethhdr->h_source)];
> +                                       entry = ipgre_tap_bridge_find_rcu(head,
> +                                               tethhdr->h_source);
> +                                       if (likely(entry)) {
> +                                               entry->raddr = orig_source;
> +                                               entry->updated = jiffies;
> +                                       } else {
> +                                         spin_lock(&tunnel->hash_lock);
> +                                         if (!ipgre_tap_bridge_find(head,
> +                                               tethhdr->h_source))
> +                                               ipgre_tap_bridge_create(
> +                                                       head,
> +                                                       orig_source,
> +                                                       tethhdr->h_source);
> +                                         spin_unlock(&tunnel->hash_lock);
> +                                       }
> +                               }
> +                       }
> +#endif
>
>
>
Ok
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
