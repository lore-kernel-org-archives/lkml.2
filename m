Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1GUJfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:35:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59085 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1GUJfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:35:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E27F2EC.2010902@jp.fujitsu.com>
Date: Thu, 21 Jul 2011 18:35:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: page allocator: Reconsider zones for allocation
 after direct reclaim
References: <1310389274-13995-1-git-send-email-mgorman@suse.de> <1310389274-13995-4-git-send-email-mgorman@suse.de> <4E1CE9FF.3050707@jp.fujitsu.com> <20110713111017.GG7529@suse.de> <4E1E6086.4060902@jp.fujitsu.com> <20110714061049.GK7529@suse.de>
In-Reply-To: <20110714061049.GK7529@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi





>> So, I think we don't need to care zonelist, just kswapd turn off
>> their own node.
> 
> I don't understand what you mean by this.

This was the answer of following your comments.

> Instead, couldn't we turn zlc->fullzones off from kswapd?
> >
> > Which zonelist should it clear (there are two)

I mean, buddy list is belong to zone, not zonelist. therefore, kswapd
don't need to look up zonelist.

So, I'd suggest either following way,
 - use direct reclaim path, but only clear a zlc bit of zones in reclaimed zonelist, not all. or
 - use kswapd and only clear a zlc bit at kswap exiting balance_pgdat

I'm prefer to add a branch to slowpath (ie reclaim path) rather than fast path.


>> And, just curious, If we will have a proper zlc clear point, why
>> do we need to keep HZ timeout?
> 
> Yes because we are not guaranteed to call direct reclaim either. Memory
> could be freed by a process exiting and I'd rather not add cost to
> the free path to find and clear all zonelists referencing the zone the
> page being freed belongs to.

Ok, it's good trade-off. I agree we need to keep HZ timeout.



