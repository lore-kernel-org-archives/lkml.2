Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab0LNWdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:33:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759081Ab0LNWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:33:45 -0500
Date: Tue, 14 Dec 2010 14:33:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
Message-Id: <20101214143306.485f2c7c.akpm@linux-foundation.org>
In-Reply-To: <1291995985-5913-2-git-send-email-mel@csn.ul.ie>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
	<1291995985-5913-2-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 15:46:20 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> When the allocator enters its slow path, kswapd is woken up to balance the
> node. It continues working until all zones within the node are balanced. For
> order-0 allocations, this makes perfect sense but for higher orders it can
> have unintended side-effects. If the zone sizes are imbalanced, kswapd may
> reclaim heavily within a smaller zone discarding an excessive number of
> pages.

Why was it doing this?  

> The user-visible behaviour is that kswapd is awake and reclaiming
> even though plenty of pages are free from a suitable zone.

Suitable for what?  I assume you refer to a future allocation which can
be satisfied from more than one of the zones?

But what if that allocation wanted to allocate a high-order page from
a zone which we just abandoned?

> This patch alters the "balance" logic for high-order reclaim allowing kswapd
> to stop if any suitable zone becomes balanced to reduce the number of pages

again, suitable for what?

> it reclaims from other zones. kswapd still tries to ensure that order-0
> watermarks for all zones are met before sleeping.

Handling order-0 pages differently from higher-order pages sounds weird
and wrong.

I don't think I understand this patch.

