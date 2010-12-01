Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0LACN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:13:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:39846 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0LACN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:13:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631829135"
Subject: Re: [PATCH 1/3] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
From: Shaohua Li <shaohua.li@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291137339-6323-2-git-send-email-mel@csn.ul.ie>
References: <1291137339-6323-1-git-send-email-mel@csn.ul.ie>
	 <1291137339-6323-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 10:13:56 +0800
Message-ID: <1291169636.12777.43.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 01:15 +0800, Mel Gorman wrote:
> When the allocator enters its slow path, kswapd is woken up to balance the
> node. It continues working until all zones within the node are balanced. For
> order-0 allocations, this makes perfect sense but for higher orders it can
> have unintended side-effects. If the zone sizes are imbalanced, kswapd
> may reclaim heavily on a smaller zone discarding an excessive number of
> pages. The user-visible behaviour is that kswapd is awake and reclaiming
> even though plenty of pages are free from a suitable zone.
> 
> This patch alters the "balance" logic to stop kswapd if any suitable zone
> becomes balanced to reduce the number of pages it reclaims from other zones.
from my understanding, the patch will break reclaim high zone if a low
zone meets the high order allocation, even the high zone doesn't meet
the high order allocation. This, for example, will make a high order
allocation from a high zone fallback to low zone and quickly exhaust low
zone, for example DMA. This will break some drivers.

