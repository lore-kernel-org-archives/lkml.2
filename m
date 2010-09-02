Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0IBAtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:49:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38553 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0IBAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:49:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1009011942150.21189@router.home>
References: <1283276257-1793-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1009011942150.21189@router.home>
Message-Id: <20100902094830.D068.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Sep 2010 09:49:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 31 Aug 2010, Mel Gorman wrote:
> 
> > +#ifdef CONFIG_SMP
> > +/* Called when a more accurate view of NR_FREE_PAGES is needed */
> > +unsigned long zone_nr_free_pages(struct zone *zone)
> > +{
> > +	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
> 
> You cannot call zone_page_state here because zone_page_state clips the
> counter at zero. The nr_free_pages needs to reflect the unclipped state
> and then the deltas need to be added. Then the clipping at zero can be
> done.

Good spotting. you are right.



