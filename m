Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0IBA1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:27:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41666 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab0IBA1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:27:00 -0400
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
In-Reply-To: <alpine.DEB.2.00.1009011919110.20518@router.home>
References: <20100901203422.GA19519@csn.ul.ie> <alpine.DEB.2.00.1009011919110.20518@router.home>
Message-Id: <20100902092628.D065.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Sep 2010 09:26:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 1 Sep 2010, Mel Gorman wrote:
> 
> > > > >         if (delta < 0 && abs(delta) > nr_free_pages)
> > > > >                 delta = -nr_free_pages;
> > >
> > > Not sure what the point here is. If the delta is going below zero then
> > > there was a concurrent operation updating the counters negatively while
> > > we summed up the counters.
> >
> > The point is if the negative delta is greater than the current value of
> > nr_free_pages then nr_free_pages would underflow when delta is applied to it.
> 
> Ok. then
> 
> 	nr_free_pages += delta;
> 	if (nr_free_pages < 0)
> 		nr_free_pages = 0;

nr_free_pages is unsined. this wouldn't works ;)




