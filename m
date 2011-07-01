Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1GADta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab1GADt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:49:29 -0400
Message-ID: <4E0D43C3.5090502@redhat.com>
Date: Fri, 01 Jul 2011 11:49:23 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
References: <cover.1309482314.git.joe@perches.com>	 <4E0D3E80.5080209@redhat.com> <1309491349.7277.22.camel@Joe-Laptop>
In-Reply-To: <1309491349.7277.22.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月01日 11:35, Joe Perches 写道:
>
>> BTW, you can kill the export of netpoll_send_skb_on_dev() too.
>
> Not too sure about that.
>
> It's used in netpoll.h by netpoll_send_skb.
> It could be called from anywhere.
> It's currently called/used by bonding.h.

% git grep netpoll_send_skb_on_dev .
include/linux/netpoll.h:void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
include/linux/netpoll.h:        netpoll_send_skb_on_dev(np, skb, np->dev);
net/core/netpoll.c:void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
net/core/netpoll.c:EXPORT_SYMBOL(netpoll_send_skb_on_dev);

No modules use it...
