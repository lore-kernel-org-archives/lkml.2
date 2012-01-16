Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2APNmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:42:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45331 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2APNmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF46@saturn3.aculab.com>
References: <1326719999.2255.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <AE90C24D6B3A694183C094C60CF0A2F6D8AF46@saturn3.aculab.com>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@gmail.com>
Date: Mon, 16 Jan 2012 14:42:12 +0100
Message-ID: <CAGsizzJr1nOBP=Sd8c3OrK8+BVr+dwT+_2y-9Xts4-NbZV_KwQ@mail.gmail.com>
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: David Laight <David.Laight@aculab.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/16 David Laight <David.Laight@aculab.com>:
>> > +   for (i = 0; i < GRETAP_BR_HASH_SIZE; i++) {
>> > +           struct ipgre_tap_bridge_entry *entry;
>> > +           struct hlist_node *h, *n;
>> > +           hlist_for_each_entry_safe(entry, h, n,
>> > +                   &tunnel->hash[i], hlist)
>> > +           {
>> > +                   unsigned long this_timer;
>> > +                   this_timer = entry->ageing_timer + delay;
>> > +                   if (time_before_eq(this_timer, jiffies))
>> > +                           ipgre_tap_bridge_delete(entry);
>> > +                   else if (time_before(this_timer, next_timer))
>> > +                           next_timer = this_timer;
>> > +           }
>> > +   }
>> > +   spin_unlock_bh(&tunnel->hash_lock);
>> > +   mod_timer(&tunnel->gc_timer, round_jiffies(next_timer + HZ/4));
>>
>> wow... why setup a 250 ms timer, if entries are valid 300 seconds ?
>
> Isn't that code trying to wakeup 250ms after the first expiry of any
> of its items?
>
> Do you even need a timer at all?
>
> It may be enough to just put a timestamp into each entry
> and tidy up when scanning one of the hash chains in (say)
> the 'add item' path - when you need write access anyway.
>
> A hash table might not be the best structure either!
> The hash lookup is still o(n) for n >> table_size.
> It also may be likely that you'll do repeated lookups for a small
> number of items - in which case using a hash to cache recent lookups
> might be useful (maybe with some type of balanced tree structure)
>
>        David
>
>

That part of code is modified from original linux bridge code, as I
wanted to avoid of developing something that was already developed.
The timer is actually needed to network


-- 
Stefan Gula
