Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1GAHGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:06:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1GAHGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:06:50 -0400
Date: Fri, 01 Jul 2011 00:06:46 -0700 (PDT)
Message-Id: <20110701.000646.268663722441785795.davem@davemloft.net>
To: amwang@redhat.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E0D43C3.5090502@redhat.com>
References: <4E0D3E80.5080209@redhat.com>
	<1309491349.7277.22.camel@Joe-Laptop>
	<4E0D43C3.5090502@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 01 Jul 2011 00:06:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Fri, 01 Jul 2011 11:49:23 +0800

> 于 2011年07月01日 11:35, Joe Perches 写道:
>>
>>> BTW, you can kill the export of netpoll_send_skb_on_dev() too.
>>
>> Not too sure about that.
>>
>> It's used in netpoll.h by netpoll_send_skb.
>> It could be called from anywhere.
>> It's currently called/used by bonding.h.
> 
> % git grep netpoll_send_skb_on_dev .
> include/linux/netpoll.h:void netpoll_send_skb_on_dev(struct netpoll
> *np, struct sk_buff *skb,
> include/linux/netpoll.h: netpoll_send_skb_on_dev(np, skb, np->dev);
> net/core/netpoll.c:void netpoll_send_skb_on_dev(struct netpoll *np,
> struct sk_buff *skb,
> net/core/netpoll.c:EXPORT_SYMBOL(netpoll_send_skb_on_dev);
> 
> No modules use it...

Right, this is a relic that bonding was using at one point
in the past but it no longer does.
