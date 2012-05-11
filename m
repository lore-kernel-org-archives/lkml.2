Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2EKFB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:01:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57192 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2EKFB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:01:27 -0400
Date: Fri, 11 May 2012 01:01:09 -0400 (EDT)
Message-Id: <20120511.010109.1698578316660207883.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 12/17] netvm: Propagate page->pfmemalloc from
 netdev_alloc_page to skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-13-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-13-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 22:01:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:45:05 +0100

> +/**
> + *	propagate_pfmemalloc_skb - Propagate pfmemalloc if skb is allocated after RX page
> + *	@page: The page that was allocated from netdev_alloc_page
> + *	@skb: The skb that may need pfmemalloc set
> + */
> +static inline void propagate_pfmemalloc_skb(struct page *page,
> +						struct sk_buff *skb)

Please use consistent prefixes in the names for new interfaces.

This one should probably be named "skb_propagate_pfmemalloc()" and
go into skbuff.h since it needs no knowledge of netdevices.

In fact all of these routines are about propagation of attributes
into SKBs, irregardless of any netdevice details.

Therefore they should probably all be named skb_*() and go into
skbuff.h
