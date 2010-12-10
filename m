Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0LJUAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:00:48 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:35523 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab0LJUAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:46 -0500
From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: unable to handle kernel NULL pointer dereference in skb_dequeue
Date: Fri, 10 Dec 2010 21:51:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-git5-home1; KDE/4.4.5; x86_64; ; )
Cc: Andrej Ota <andrej@ota.si>, linux-kernel@vger.kernel.org, gvs@zemos.net,
        Rami Rosen <ramirose@gmail.com>, netdev <netdev@vger.kernel.org>
References: <0fe401cb92e7$85ba2260$912e6720$@si> <aa43945b38cee751a8231084866b074d@192.168.253.23> <1291387595.2897.350.camel@edumazet-laptop>
In-Reply-To: <1291387595.2897.350.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012102151.04983.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 December 2010 16:46:35 Eric Dumazet wrote:
> Le vendredi 03 décembre 2010 à 15:37 +0100, Andrej Ota a écrit :
> > >> Patch that works for me is below. Now I only hope I haven't
> > >> (re)introduced a memory leak...
> > > 
> > > Problem comes from commit 55c95e738da85 (fix return value of
> > > __pppoe_xmit() method)
> > > 
> > > I am not sure patch is OK
> > 
> > Me neither. That's why I wrote "works for me". All I dare say is that it
> > works better than current code and is probably no worse than it was
> > before above mentioned commit. Apart from that, there is no point in
> > having return value for __pppoe_xmit if return value isn't needed.
> > 
> > Easiest way of triggering this BUG is by terminating PPPoE on the server
> > side, which then hits "if (!dev) { goto abort; }". This in turn calls
> > "kfree_skb(skb); return 0;" which returns to pppoe_rcv_core which then
> > goto-s to "abort_put" which again calls "kfree_skb(skb)". Voila the bug.
> > 
> > I don't know how to trigger "if (skb_cow_head(skb, ..." to see if I have
> > just caused another BUG. However, if I read file comments at the top, I
> > see a comment from 19/07/01 stating that I have to delete original skb
> > if code succeeds and never delete it on failure. About the skb copy
> > mentioned in the same comment, I don't know. 2001 was many commits ago.
> 
> Well, all I wanted to say was that _I_ was not sure, but probably other
> network guys have a better diagnostic.
> 
> Rami, could you re-explain the rationale of your patch ?
> 
> Thanks
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Is there any plans to queue any patch to stable?
pppoe is almost dead in 2.6.36.*

