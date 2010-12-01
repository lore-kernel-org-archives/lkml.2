Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0LACXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:23:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50946 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0LACXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:23:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 1/3] mm: kswapd: Stop high-order balancing when any suitable zone is balanced
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Simon Kirby <sim@hostway.ca>, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291169636.12777.43.camel@sli10-conroe>
References: <1291137339-6323-2-git-send-email-mel@csn.ul.ie> <1291169636.12777.43.camel@sli10-conroe>
Message-Id: <20101201112354.ABA8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 11:23:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-12-01 at 01:15 +0800, Mel Gorman wrote:
> > When the allocator enters its slow path, kswapd is woken up to balance the
> > node. It continues working until all zones within the node are balanced. For
> > order-0 allocations, this makes perfect sense but for higher orders it can
> > have unintended side-effects. If the zone sizes are imbalanced, kswapd
> > may reclaim heavily on a smaller zone discarding an excessive number of
> > pages. The user-visible behaviour is that kswapd is awake and reclaiming
> > even though plenty of pages are free from a suitable zone.
> > 
> > This patch alters the "balance" logic to stop kswapd if any suitable zone
> > becomes balanced to reduce the number of pages it reclaims from other zones.
> from my understanding, the patch will break reclaim high zone if a low
> zone meets the high order allocation, even the high zone doesn't meet
> the high order allocation. This, for example, will make a high order
> allocation from a high zone fallback to low zone and quickly exhaust low
> zone, for example DMA. This will break some drivers.

Have you seen patch [3/3]? I think it migigate your pointed issue.



