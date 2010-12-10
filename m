Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0LJUSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:18:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50223
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab0LJUSR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:18:17 -0500
Date: Fri, 10 Dec 2010 12:18:45 -0800 (PST)
Message-Id: <20101210.121845.70177370.davem@davemloft.net>
To: nuclearcat@nuclearcat.com
Cc: eric.dumazet@gmail.com, andrej@ota.si, linux-kernel@vger.kernel.org,
        gvs@zemos.net, ramirose@gmail.com, netdev@vger.kernel.org
Subject: Re: unable to handle kernel NULL pointer dereference in skb_dequeue
From: David Miller <davem@davemloft.net>
In-Reply-To: <201012102151.04983.nuclearcat@nuclearcat.com>
References: <aa43945b38cee751a8231084866b074d@192.168.253.23>
	<1291387595.2897.350.camel@edumazet-laptop>
	<201012102151.04983.nuclearcat@nuclearcat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date: Fri, 10 Dec 2010 21:51:04 +0200

> On Friday 03 December 2010 16:46:35 Eric Dumazet wrote:
>> Le vendredi 03 décembre 2010 à 15:37 +0100, Andrej Ota a écrit :
>> > >> Patch that works for me is below. Now I only hope I haven't
>> > >> (re)introduced a memory leak...
>> > > 
>> > > Problem comes from commit 55c95e738da85 (fix return value of
>> > > __pppoe_xmit() method)
>> > > 
>> > > I am not sure patch is OK
>> > 
>> > Me neither. That's why I wrote "works for me". All I dare say is that it
>> > works better than current code and is probably no worse than it was
>> > before above mentioned commit. Apart from that, there is no point in
>> > having return value for __pppoe_xmit if return value isn't needed.
>> > 
>> > Easiest way of triggering this BUG is by terminating PPPoE on the server
>> > side, which then hits "if (!dev) { goto abort; }". This in turn calls
>> > "kfree_skb(skb); return 0;" which returns to pppoe_rcv_core which then
>> > goto-s to "abort_put" which again calls "kfree_skb(skb)". Voila the bug.
>> > 
>> > I don't know how to trigger "if (skb_cow_head(skb, ..." to see if I have
>> > just caused another BUG. However, if I read file comments at the top, I
>> > see a comment from 19/07/01 stating that I have to delete original skb
>> > if code succeeds and never delete it on failure. About the skb copy
>> > mentioned in the same comment, I don't know. 2001 was many commits ago.
>> 
>> Well, all I wanted to say was that _I_ was not sure, but probably other
>> network guys have a better diagnostic.
>> 
>> Rami, could you re-explain the rationale of your patch ?
>> 
>> Thanks
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Is there any plans to queue any patch to stable?
> pppoe is almost dead in 2.6.36.*

I'll deal with it for -stable once I evaluate this patch for upstream,
which I haven't even gotten to yet.

When people bark about -stable this and -stable that, it just takes
more time away from me actually getting through all the patches.  If
it causes a crash, I know it should go to stable and I'll take care of
it.  So there is no need to make an explicit note or query about it.

Thanks.
